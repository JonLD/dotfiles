# nudot - Nushell Dotfile Manager
# A simple, cross-platform dotfile manager written in nushell

# Configuration file path
const CONFIG_FILE = "nudot-config.nu"

# Color helper functions for nice output
def color-error [text: string] { $"\e[31m($text)\e[0m" }      # Red
def color-success [text: string] { $"\e[32m($text)\e[0m" }    # Green
def color-warning [text: string] { $"\e[33m($text)\e[0m" }    # Yellow
def color-info [text: string] { $"\e[36m($text)\e[0m" }       # Cyan
def color-bold [text: string] { $"\e[1m($text)\e[0m" }        # Bold
def color-dim [text: string] { $"\e[90m($text)\e[0m" }        # Bright black (lighter gray)

# Load configuration from file, or use default if file doesn't exist
def load-config [] {
  let config_path = (get-dotfiles-dir | path join $CONFIG_FILE)

  if ($config_path | path exists) {
    # Import the config file and call its function
    # We execute it in a subprocess to get the config data
    let result = (nu -c $"source '($config_path)'; get-dotfiles-config | to json")
    if ($result | is-empty) {
      []
    } else {
      $result | from json
    }
  } else {
    # Return empty config - user should use 'nudot add' to add files
    []
  }
}

# Save configuration to file
def save-config [config: list] {
  let config_path = (get-dotfiles-dir | path join $CONFIG_FILE)

  # Generate human-readable config file
  let config_items = ($config | each {|item|
    let windows_str = if ($item.targets.windows == null) { "null" } else {
      let escaped_path = ($item.targets.windows | str replace --all "\\" "\\\\")
      $"\"($escaped_path)\""
    }
    let linux_str = if ($item.targets.linux == null) { "null" } else { $"\"($item.targets.linux)\"" }
    let macos_str = if ($item.targets.macos == null) { "null" } else { $"\"($item.targets.macos)\"" }

    $"    \{
      name: \"($item.name)\"
      source: \"($item.source)\"
      targets: \{
        windows: ($windows_str)
        linux: ($linux_str)
        macos: ($macos_str)
      \}
    \}"
  } | str join "\n")

  let config_content = $"# nudot configuration file
# This file is automatically managed by nudot, but can be manually edited
# You can add paths for other operating systems before switching to them

export def get-dotfiles-config [] \{
  [
($config_items)
  ]
\}"

  $config_content | save -f $config_path
}

# Get current operating system
def get-os [] {
  let os_info = (sys host | get name)
  # Handle various Linux distributions that include "Linux" in their name
  if ($os_info | str contains "Linux") {
    "linux"
  } else {
    match $os_info {
      "Windows" => "windows"
      "Darwin" => "macos"
      _ => (error make {msg: $"Unsupported OS: ($os_info)"})
    }
  }
}

# Get the dotfiles directory (assumes script is in dotfiles repo)
def get-dotfiles-dir [] {
  $env.PWD
}

# Install a single dotfile
def install-dotfile [config: record, force: bool = false, dry_run: bool = false] {
  let os = (get-os)
  let dotfiles_dir = (get-dotfiles-dir)

  # Get target path for current OS
  let target = ($config.targets | get -o $os)

  if ($target == null) {
    print $"Skipping ($config.name) - not configured for ($os)"
    return
  }

  let source_path = ($dotfiles_dir | path join $config.source)

  # Check if source exists
  if not ($source_path | path exists) {
    print $"Warning: Source ($source_path) does not exist for ($config.name)"
    return
  }

  if $dry_run {
    print $"[DRY RUN] Would link ($config.name): ($source_path) -> ($target)"
    if ($target | path exists) {
      let target_type = ($target | path type)
      if $target_type == "symlink" {
        print $"  - Target is already a symlink \(would recreate\)"
      } else {
        print $"  - Target exists as a ($target_type) \(would backup to ($target).backup\)"
      }
    }
    return
  }

  # Create parent directory if it doesn't exist
  let parent_dir = ($target | path dirname)
  if not ($parent_dir | path exists) {
    mkdir $parent_dir
  }

  # Handle existing file/symlink if it exists
  if ($target | path exists) {
    let target_type = ($target | path type)

    if $target_type == "symlink" {
      # It's already a symlink, just remove it to recreate
      rm $target
    } else {
      # It's a real file/directory - handle carefully
      if $force {
        rm -rf $target
      } else {
        # Backup the existing config
        let backup_path = $"($target).backup"
        if ($backup_path | path exists) {
          let timestamp = (date now | format date "%Y%m%d_%H%M%S")
          let backup_path = $"($target).backup.($timestamp)"
          mv $target $backup_path
        } else {
          mv $target $backup_path
        }
      }
    }
  }

  # Create symlink

  match (get-os) {
    "windows" => {
      # Use mklink on Windows
      try {
        if ($source_path | path type) == "dir" {
          run-external "cmd" "/c" "mklink" "/D" $target $source_path
        } else {
          run-external "cmd" "/c" "mklink" $target $source_path
        }
      } catch {
        print $"ERROR: Failed to create symlink for ($config.name)"
        print "This usually means you need Administrator privileges on Windows."
        print "Solutions:"
        print "  1. Run your terminal as Administrator (Right-click > Run as Administrator)"
        print "  2. Enable Developer Mode in Windows Settings (Settings > Update & Security > For Developers)"
        print "  3. Use 'nudot attach' from an elevated terminal"
        print ""
        print "Alternatively, you can manually copy the files instead of using symlinks."
      }
    }
    _ => {
      # Use ln on Unix-like systems
      run-external "ln" "-sf" $source_path $target
    }
  }
}

# Remove a file from dotfiles management
def "nudot remove" [target_identifier: string, --force, --backup] {
  let config = (load-config)
  let os = (get-os)
  let dotfiles_dir = (get-dotfiles-dir)

  # Try to find the config entry either by name or by target path
  let abs_target = ($target_identifier | path expand)

  # First try to match by target path (full path)
  let matching_by_path = ($config | where {|item|
    let target = ($item.targets | get -o $os)
    $target != null and $target == $abs_target
  })

  # If no match by path, try to match by config name
  let matching_by_name = if ($matching_by_path | is-empty) {
    ($config | where {|item| $item.name == $target_identifier})
  } else {
    []
  }

  let matching_config = if not ($matching_by_path | is-empty) {
    $matching_by_path
  } else if not ($matching_by_name | is-empty) {
    $matching_by_name
  } else {
    []
  }

  if ($matching_config | is-empty) {
    print (color-error $"ERROR: No config entry found for '($target_identifier)'")
    print $"Available configs: (color-bold ($config | get name | str join ', '))"
    print ""
    print (color-bold "Usage:")
    print ((color-info "  nudot remove <config_name>") + "    " + (color-dim "# e.g., 'nudot remove nvim'"))
    print ((color-info "  nudot remove <full_path>") + "      " + (color-dim "# e.g., 'nudot remove /path/to/config'"))
    exit 1
  }

  let config_entry = ($matching_config | first)
  let config_name = $config_entry.name
  let source_path = ($dotfiles_dir | path join $config_entry.source)
  let actual_target = ($config_entry.targets | get -o $os)

  print (color-info $"Removing (color-bold $config_name) from dotfiles...")

  # Check if source files exist in the repo
  let source_exists = ($source_path | path exists)
  if not $source_exists {
    print (color-warning $"Note: No source files found at ($source_path)")
    print (color-dim "This appears to be a config-only entry (path configured without files)")
  }

  # Handle the target location (use actual target from config, not input)
  if ($actual_target | path exists) {
    let target_type = ($actual_target | path type)

    if $target_type == "symlink" {
      # Normal case: it's a symlink, remove it
      rm $actual_target
    } else {
      # Target exists but isn't a symlink - this could be dangerous
      if (not $force and not $backup) {
        print (color-error $"ERROR: ($actual_target) exists but is not a symlink!")
        print "This could be your actual config file. nudot won't overwrite it without explicit permission."
        print ""
        print (color-bold "Options:")
        print (color-info "  --force   : Replace the existing file with the one from the repo")
        print (color-info "  --backup  : Backup the existing file first, then restore from repo")
        print ""
        print (color-bold "Example:")
        print (color-info $"  nu nudot.nu remove ($target_identifier) --backup")
        exit 1
      }

      if $backup {
        mv $actual_target $"($actual_target).backup"
      } else if $force {
        rm -rf $actual_target
      }
    }
  }

  # Move files back from repo to original location (if they exist)
  if $source_exists {
    # Create parent directory if needed
    let parent_dir = ($actual_target | path dirname)
    if not ($parent_dir | path exists) {
      mkdir $parent_dir
    }

    # Move the files back
    mv $source_path $actual_target
  } else {
    print (color-info "No files to restore (config-only entry)")
  }

  # Remove from config
  let new_config = ($config | where {|item| $item.name != $config_name})
  save-config $new_config

  print ""
  print (color-success $"✓ Success! (color-bold $config_name) is no longer managed by nudot")
  if $source_exists {
    print $"Files have been restored to: (color-dim $actual_target)"
  } else {
    print (color-dim "Configuration entry removed (was config-only)")
  }
  print (color-warning "Don't forget to commit the config changes to git!")
}

# Test if we can create a symlink (without actually doing it permanently)
def test-symlink-creation [source_path: string, target_path: string] {
  let test_target = $"($target_path).nudot_test"

  try {
    match (get-os) {
      "windows" => {
        if ($source_path | path type) == "dir" {
          run-external "cmd" "/c" "mklink" "/D" $test_target $source_path
        } else {
          run-external "cmd" "/c" "mklink" $test_target $source_path
        }
      }
      _ => {
        run-external "ln" "-sf" $source_path $test_target
      }
    }

    # If we got here, the symlink worked - clean it up
    rm $test_target
    true
  } catch {
    # Symlink failed
    false
  }
}

# Add a file to dotfiles management
def "nudot add" [target_path: string, --name: string, --source: string, --force, --config-only] {
  let os = (get-os)
  let dotfiles_dir = (get-dotfiles-dir)
  let config = (load-config)

  # Resolve the target path to absolute
  let abs_target = ($target_path | path expand)

  # In config-only mode, we don't need the file to exist
  if not $config_only {
    # Check if target exists
    if not ($abs_target | path exists) {
      print (color-error $"ERROR: Target path does not exist: ($abs_target)")
      exit 1
    }

    # Check if it's already a symlink
    if ($abs_target | path type) == "symlink" {
      print $"($abs_target) is already a symlink, skipping"
      return
    }
  }

  # Generate a name if not provided
  let config_name = if ($name != null) {
    $name
  } else {
    ($abs_target | path basename)
  }

  # Generate source path if not provided
  let source_path = if ($source != null) {
    $source
  } else {
    $config_name
  }

  let source_full_path = ($dotfiles_dir | path join $source_path)
  let need_to_copy = not ($source_full_path | path exists)

  # Check if config already exists (by name or target path)
  let existing_by_name = ($config | where {|item| $item.name == $config_name})
  let existing_by_target = ($config | where {|item|
    let target = ($item.targets | get -o $os)
    $target != null and $target == $abs_target
  })

  if (not ($existing_by_name | is-empty) or not ($existing_by_target | is-empty)) {
    let existing_name = if not ($existing_by_name | is-empty) {
      ($existing_by_name | first | get name)
    } else {
      ($existing_by_target | first | get name)
    }

    if not $force {
      print (color-error $"ERROR: Config '($existing_name)' already exists for this target!")
      print $"Target: (color-dim $abs_target)"
      print $"Existing config name: (color-bold $existing_name)"
      print ""
      print "To override the existing config, use:"
      print (color-info $"  nu nudot.nu add ($target_path) --force")
      exit 1
    } else {
      print $"Force overriding existing config '($existing_name)'..."
      # Remove the existing config entry
      let config = ($config | where {|item| $item.name != $existing_name})
    }
  }

  if $config_only {
    print (color-info $"Adding (color-bold $config_name) configuration \(config-only mode\)...")

    # In config-only mode, ensure the source directory exists in the repo
    if not ($source_full_path | path exists) {
      print (color-warning $"Note: Source directory ($source_full_path) will be created when files are added")
    }
  } else {
    print (color-info $"Adding (color-bold $config_name) to dotfiles...")

    # Step 1: Copy to repo (temporarily)
    if $need_to_copy {
      cp -r $abs_target $source_full_path
    }

    # Step 2: Test symlink creation
    let can_symlink = (test-symlink-creation $source_full_path $abs_target)

    if not $can_symlink {
      print (color-error "ERROR: Cannot create symlinks!")
      print "Windows requires Administrator privileges or Developer Mode to create symlinks."
      print ""
      print (color-bold "Solutions:")
      print "  1. Run your terminal as Administrator"
      print "  2. Enable Developer Mode (Windows 10/11):"
      print (color-dim "     Settings > Update & Security > For Developers > Developer Mode")

      # Clean up: remove the copy we made if we made one
      if $need_to_copy {
        rm -rf $source_full_path
      }

      print "Symlink creation failed. No changes were made."
      exit 1
    }

    # Step 3: All tests passed, now commit the changes
    # Remove the original
    rm -rf $abs_target

    # Create parent directory if needed
    let parent_dir = ($abs_target | path dirname)
    if not ($parent_dir | path exists) {
      mkdir $parent_dir
    }

    # Create the actual symlink (we know this will work since we tested it)
    match (get-os) {
      "windows" => {
        if ($source_full_path | path type) == "dir" {
          run-external "cmd" "/c" "mklink" "/D" $abs_target $source_full_path
        } else {
          run-external "cmd" "/c" "mklink" $abs_target $source_full_path
        }
      }
      _ => {
        run-external "ln" "-sf" $source_full_path $abs_target
      }
    }
  }

  # Step 4: Save configuration
  let new_config_entry = {
    name: $config_name
    source: $source_path
    targets: {
      windows: (if $os == "windows" { $abs_target } else { null })
      linux: (if $os == "linux" { $abs_target } else { null })
      macos: (if $os == "macos" { $abs_target } else { null })
    }
  }

  let new_config = ($config | append $new_config_entry)
  save-config $new_config

  print ""
  if $config_only {
    print (color-success $"✓ Success! Added (color-bold $config_name) configuration")
    print $"Target path configured: (color-dim $abs_target)"
    print $"Source will be: (color-dim $source_full_path)"
    print (color-info "Use 'nudot attach' when files are available to create symlinks")
  } else {
    print (color-success $"✓ Success! Added (color-bold $config_name) to configuration")
    print $"Your config is now managed at: (color-dim $source_full_path)"
  }
  print (color-warning "Don't forget to commit to git!")
}

# Attach all dotfiles (create symlinks)
def "nudot attach" [--force, --dry-run] {
  if $dry_run {
    print (color-warning "DRY RUN: Previewing what would be attached...")
    print ""
  } else if $force {
    print (color-warning "Force attaching dotfiles (existing files will be removed)...")
  } else {
    print (color-info "Attaching dotfiles (existing files will be backed up)...")
  }

  let config = (load-config)

  if ($config | is-empty) {
    print (color-warning "No dotfiles configured. Use 'nudot add <path>' to add some.")
    return
  }

  for config_item in $config {
    install-dotfile $config_item $force $dry_run
  }

  if $dry_run {
    print ""
    print (color-info "This was a dry run. No changes were made.")
    print "Run without --dry-run to actually create the symlinks."
  } else {
    print ""
    print (color-success "✓ Done! Your dotfiles are now attached.")
    if not $force {
      print (color-dim "Note: Any existing configs were backed up with .backup extension")
    }
  }
}

# List all configured dotfiles
def "nudot list" [] {
  let os = (get-os)
  let config = (load-config)

  print (color-bold $"Configured dotfiles for ($os):")
  print ""

  for config_item in $config {
    let target = ($config_item.targets | get -o $os)
    let status = if ($target == null) {
      color-dim "not configured"
    } else if ($target | path exists) {
      if ($target | path type) == "symlink" {
        color-success "linked"
      } else {
        color-warning "exists (not linked)"
      }
    } else {
      color-error "not installed"
    }

    print $"  (color-bold $config_item.name): ($status)"
    if ($target != null) {
      print $"    Target: (color-dim $target)"
    }
    print ""
  }
}

# Check status of dotfiles
def "nudot status" [] {
  let os = (get-os)
  let dotfiles_dir = (get-dotfiles-dir)
  let config = (load-config)

  print $"Dotfiles status \(OS: ($os), Dir: ($dotfiles_dir)\):\n"

  for config_item in $config {
    let target = ($config_item.targets | get -o $os)
    let source_path = ($dotfiles_dir | path join $config_item.source)

    print $"($config_item.name):"
    print $"  Source: ($source_path) " + (if ($source_path | path exists) { "✓" } else { "✗" })

    if ($target == null) {
      print $"  Target: not configured for ($os)"
    } else {
      let target_status = if ($target | path exists) {
        if ($target | path type) == "symlink" {
          let link_target = (run-external "readlink" $target | str trim)
          if ($link_target == $source_path) {
            "✓ correctly linked"
          } else {
            $"✗ linked to wrong target: ($link_target)"
          }
        } else {
          "✗ exists but not a symlink"
        }
      } else {
        "✗ not installed"
      }
      print $"  Target: ($target) ($target_status)"
    }
    print ""
  }
}

# Remove all symlinks (files stay in repo)
def "nudot detach" [] {
  let os = (get-os)
  let config = (load-config)

  print "Detaching all dotfile symlinks (files stay in repo)..."

  for config_item in $config {
    let target = ($config_item.targets | get -o $os)

    if ($target == null) {
      continue
    }

    if ($target | path exists) and (($target | path type) == "symlink") {
      print $"Detaching symlink: ($target)"
      rm $target
    }
  }

  print "Done! Your dotfiles are still safe in the repo."
}

# Help command
def "nudot help" [] {
  print ((color-bold "nudot") + " - " + (color-info "Nushell Dotfile Manager"))
  print ""
  
  print (color-bold "Usage:")
  print ("  " + (color-info "nudot attach") + " [--force] [--dry-run] - " + (color-dim "Attach all dotfiles (create symlinks)"))
  print ("  " + (color-info "nudot list") + "                          - " + (color-dim "List all configured dotfiles"))
  print ("  " + (color-info "nudot status") + "                        - " + (color-dim "Show detailed status of all dotfiles"))
  print ("  " + (color-info "nudot detach") + "                        - " + (color-dim "Detach all symlinks (files stay in repo)"))
  print ("  " + (color-info "nudot add") + " <path> [--name <n>] [--force] [--config-only] - " + (color-dim "Add a file/directory to dotfiles"))
  print ("  " + (color-info "nudot remove") + " <path> [--force|--backup] - " + (color-dim "Remove a file from dotfiles management"))
  print ("  " + (color-info "nudot help") + "                          - " + (color-dim "Show this help message"))
  print ""
  
  print (color-bold "Examples:")
  print ("  " + (color-info "nudot add") + " ~/.config/nvim                    - " + (color-dim "Add neovim config"))
  print ("  " + (color-info "nudot add") + " ~/.zshrc --name zsh               - " + (color-dim "Add zsh config with custom name"))
  print ("  " + (color-info "nudot add") + " ~/.gitconfig --source git-config  - " + (color-dim "Add with custom source name"))
  print ("  " + (color-info "nudot add") + " ~/.config/nvim --force            - " + (color-dim "Force override existing config"))
  print ("  " + (color-info "nudot add") + " ~/.config/nvim --config-only      - " + (color-dim "Add config path only (for other OS)"))
  print ("  " + (color-info "nudot attach") + " --dry-run                      - " + (color-dim "Preview what would be attached"))
  print ("  " + (color-info "nudot attach") + " --force                        - " + (color-dim "Attach and override existing files"))
  print ("  " + (color-info "nudot remove") + " ~/.config/nvim                 - " + (color-dim "Remove neovim from management"))
  print ("  " + (color-info "nudot remove") + " ~/.config/nvim --backup        - " + (color-dim "Remove and backup existing file"))
  print ""
  
  print (color-bold "Command descriptions:")
  print ("  " + (color-success "attach") + "    - " + (color-dim "Creates symlinks from target locations to your dotfiles repo"))
  print ("              --force: " + (color-dim "Override existing files without backup"))
  print ("              --dry-run: " + (color-dim "Preview what would be attached without making changes"))
  print ""
  print ("  " + (color-success "detach") + "    - " + (color-dim "Removes all symlinks but leaves files safely in your dotfiles repo"))
  print ("              " + (color-dim "Useful for temporarily disabling dotfiles management"))
  print ""
  print ("  " + (color-success "add") + "       - " + (color-dim "Copies a config to your repo and creates symlink (starts managing it)"))
  print ("              --name: " + (color-dim "Custom name for the config (default: uses filename)"))
  print ("              --source: " + (color-dim "Custom directory name in repo (default: uses config name)"))
  print ("              --force: " + (color-dim "Override existing config with same name or target"))
  print ("              --config-only: " + (color-dim "Add target path to config without copying files (for cross-platform setup)"))
  print ""
  print ("  " + (color-success "remove") + "    - " + (color-dim "Moves config back to original location and stops managing it"))
  print ("              " + (color-dim "Can be called by config name (e.g., 'nvim') or full path"))
  print ("              --force: " + (color-dim "Replace existing file without backup"))
  print ("              --backup: " + (color-dim "Create backup before restoring from repo"))
  print ""
  print ("  " + (color-success "list") + "      - " + (color-dim "Shows all configured dotfiles and their status for current OS"))
  print ""
  print ("  " + (color-success "status") + "    - " + (color-dim "Shows detailed status including source/target paths and symlink health"))
  print ""
  
  print (color-bold "Configuration:")
  print ("  " + (color-dim "Configuration is automatically managed in ") + (color-warning "nudot-config.nu"))
  print ("  " + (color-dim "Files are stored with simple names in your dotfiles repo (") + (color-dim "nvim/") + (color-dim ", ") + (color-dim "gitconfig") + (color-dim ", etc.)"))
  print ("  " + (color-dim "You can manually edit ") + (color-warning "nudot-config.nu") + (color-dim " to add paths for other operating systems"))
}

# Main entry point
def main [command?: string, path?: string, --name: string, --source: string, --force, --backup, --dry-run, --config-only] {
  match $command {
    "attach" => {
      if $force and $dry_run {
        nudot attach --force --dry-run
      } else if $force {
        nudot attach --force
      } else if $dry_run {
        nudot attach --dry-run
      } else {
        nudot attach
      }
    }
    "list" => { nudot list }
    "status" => { nudot status }
    "detach" => { nudot detach }
    "add" => {
      if ($path == null) {
        print (color-error "ERROR: Path is required for add command")
        exit 1
      }
      if $force and $config_only {
        nudot add $path --name $name --source $source --force --config-only
      } else if $force {
        nudot add $path --name $name --source $source --force
      } else if $config_only {
        nudot add $path --name $name --source $source --config-only
      } else {
        nudot add $path --name $name --source $source
      }
    }
    "remove" => {
      if ($path == null) {
        print (color-error "ERROR: Path is required for remove command")
        exit 1
      }
      if $force and $backup {
        print (color-error "ERROR: Cannot use both --force and --backup flags together")
        exit 1
      } else if $force {
        nudot remove $path --force
      } else if $backup {
        nudot remove $path --backup
      } else {
        nudot remove $path
      }
    }
    "help" => { nudot help }
    null => { nudot help }
    _ => {
      print $"Unknown command: ($command)"
      nudot help
    }
  }
}