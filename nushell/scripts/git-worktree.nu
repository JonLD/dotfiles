def git-worktrees [repo?: string] {
	let repo_root = if ($repo | is-empty) {
		(^git rev-parse --show-toplevel | str trim)
	} else {
		(^git -C $repo rev-parse --show-toplevel | str trim)
	}

	let raw = (^git -C $repo_root worktree list --porcelain | lines)
	mut worktrees = []
	mut current = {}

	for line in $raw {
		if ($line | is-empty) {
			if (($current | columns | length) > 0) {
				$worktrees = ($worktrees | append $current)
				$current = {}
			}
			continue
		}

		if ($line | str starts-with "worktree ") {
			$current.worktree = ($line | str replace "worktree " "")
		} else if ($line | str starts-with "HEAD ") {
			$current.HEAD = ($line | str replace "HEAD " "")
		} else if ($line | str starts-with "branch ") {
			$current.branch = ($line | str replace "branch refs/heads/" "")
		} else if ($line == "detached") {
			$current.branch = "detached"
		}
	}

	if (($current | columns | length) > 0) {
		$worktrees = ($worktrees | append $current)
	}

	$worktrees | each {|wt|
		let path = ($wt | get worktree)
		let name = ($path | path basename)
		let branch = ($wt | get -o branch | default "detached")
		let head = ($wt | get -o HEAD | default "" | str substring 0..6)

		{
			name: $name
			branch: $branch
			head: $head
			path: $path
		}
	}
}

def pick-git-worktree [repo?: string] {
	let selected = (
		git-worktrees $repo
		| each {|wt| $"($wt.path)\t($wt.name)\t($wt.branch)\t($wt.head)"}
		| str join (char nl)
		| ^fzf --delimiter "\t" --with-nth "2,3,4,1" --prompt "worktree> " --height "40%"
	)

	if ($selected | is-empty) {
		null
	} else {
		$selected | split row "\t" | get 0
	}
}

def --env gwt [repo?: string] {
	let selected_path = (pick-git-worktree $repo)

	if ($selected_path != null) {
		cd $selected_path
	}
}

def --env gwtc [repo?: string] {
	let selected_path = (pick-git-worktree $repo)

	if ($selected_path != null) {
		cd $selected_path
		^claude
	}
}

def --env gwtn [repo?: string] {
	let selected_path = (pick-git-worktree $repo)

	if ($selected_path != null) {
		cd $selected_path
		^nvim .
	}
}

def --env gwta [name: string, branch?: string] {
	let repo_root = (^git rev-parse --show-toplevel | str trim)
	let worktree_dir = ($repo_root | path join ".worktrees" $name)
	if ($branch | is-empty) {
		^git -C $repo_root worktree add $worktree_dir -b $name
	} else {
		^git -C $repo_root worktree add $worktree_dir $branch
	}
	cd $worktree_dir
}

def gwr [repo?: string] {
	let repo_root = if ($repo | is-empty) {
		(^git rev-parse --show-toplevel | str trim)
	} else {
		(^git -C $repo rev-parse --show-toplevel | str trim)
	}
	let selected_path = (pick-git-worktree $repo_root)

	if ($selected_path == null) {
		return
	}

	if ($selected_path == $env.PWD) {
		error make {msg: "refusing to remove the current working tree"}
	}

	let confirm = (
		input $"remove worktree ($selected_path)? [y/N]: "
		| str trim
		| str downcase
	)

	if $confirm in ["y", "yes"] {
		^git -C $repo_root worktree remove $selected_path
	}
}
