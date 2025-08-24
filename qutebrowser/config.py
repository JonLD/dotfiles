config.load_autoconfig(False)

# Editor configuration
c.editor.command = ['wt', 'nvim', '{file}', '-c', 'normal {line}G{column0}l']

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}"
}

# Fun start page options (uncomment one you like):
# c.url.start_pages = ["https://excalidraw.com"]                    # Drawing app
c.url.start_pages = ["https://hacker-news.firebaseapp.com"]      # Clean HN reader  
# c.url.start_pages = ["https://github.com/trending"]              # Trending repos
# c.url.start_pages = ["https://www.poolsuite.net"]                # Aesthetic vibes
# c.url.start_pages = ["https://neal.fun"]                         # Fun interactive sites
# c.url.start_pages = ["https://www.nasa.gov/image-of-the-day"]     # NASA daily image
# c.url.start_pages = ["https://www.reddit.com/r/EarthPorn"]       # Beautiful landscapes
# c.url.start_pages = ["https://uselessweb.com"]                   # Random fun sites

# Gruvbox Dark color scheme
# Base gruvbox colors
bg_hard = "#1d2021"          # Hard dark background
bg_normal = "#282828"        # Normal dark background  
bg_soft = "#32302f"          # Soft dark background
bg1 = "#3c3836"              # Background 1
bg2 = "#504945"              # Background 2
fg = "#ebdbb2"               # Foreground
fg1 = "#ebdbb2"              # Foreground 1
fg2 = "#d5c4a1"              # Foreground 2
fg3 = "#bdae93"              # Foreground 3
fg4 = "#a89984"              # Foreground 4
red = "#cc241d"              # Red
green = "#98971a"            # Green
yellow = "#d79921"           # Yellow
blue = "#458588"             # Blue
purple = "#b16286"           # Purple
aqua = "#689d6a"             # Aqua
gray = "#928374"             # Gray
orange = "#d65d0e"           # Orange

# Basic UI configuration
c.colors.webpage.darkmode.enabled = True
c.tabs.position = "left"
c.tabs.padding = {"top": 8, "bottom": 8, "left": 5, "right": 5}

# Tab indicator colors
c.colors.tabs.indicator.start = blue       # Loading (gruvbox blue)
c.colors.tabs.indicator.stop = bg_normal   # Success (invisible)
c.colors.tabs.indicator.error = red        # Error (gruvbox red)
c.colors.tabs.indicator.system = "rgb"

# Font configuration - JetBrains Mono for browser UI
c.fonts.default_family = "JetBrains Mono"
c.fonts.default_size = "12pt"

# Window configuration
c.window.hide_decoration = True
c.window.title_format = "{current_title} - qutebrowser"

# Status bar - only show when needed
c.statusbar.show = "in-mode"

# Custom keybindings for search/completion navigation
config.bind('<Ctrl+j>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl+k>', 'completion-item-focus prev', mode='command')
config.bind('<Ctrl+c>', 'mode-leave', mode='command')
config.bind('<Ctrl+l>', 'command-accept', mode='command')

# Tab movement keybindings
config.bind('<Ctrl+J>', 'tab-move +1')
config.bind('<Ctrl+K>', 'tab-move -1')

# Page scrolling keybindings
config.bind('<Ctrl+j>', 'scroll-page 0 0.5')
config.bind('<Ctrl+k>', 'scroll-page 0 -0.5')

# Hint keybindings
config.bind('F', 'hint links tab-fg')

# Smooth scrolling
c.scrolling.smooth = True
c.qt.args = ["--enable-smooth-scrolling"]

# Tab colors - gruvbox style
c.colors.tabs.bar.bg = bg_normal
c.colors.tabs.even.bg = bg1
c.colors.tabs.odd.bg = bg1
c.colors.tabs.even.fg = fg2
c.colors.tabs.odd.fg = fg2
c.colors.tabs.selected.even.bg = bg_soft
c.colors.tabs.selected.odd.bg = bg_soft
c.colors.tabs.selected.even.fg = fg
c.colors.tabs.selected.odd.fg = fg

# Status bar colors
c.colors.statusbar.normal.bg = bg_normal
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.insert.bg = blue
c.colors.statusbar.insert.fg = bg_normal
c.colors.statusbar.command.bg = bg1
c.colors.statusbar.command.fg = fg

# URL bar colors (in status bar)
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.error.fg = red
c.colors.statusbar.url.warn.fg = yellow

# Completion menu colors - gruvbox style
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg1
c.colors.completion.even.bg = bg_normal
c.colors.completion.category.fg = fg3
c.colors.completion.category.bg = bg2
c.colors.completion.item.selected.fg = bg_normal
c.colors.completion.item.selected.bg = yellow
c.colors.completion.item.selected.border.top = yellow
c.colors.completion.item.selected.border.bottom = yellow
c.colors.completion.match.fg = orange

# Downloads
c.colors.downloads.bar.bg = bg_normal
c.colors.downloads.start.fg = bg_normal
c.colors.downloads.start.bg = blue
c.colors.downloads.stop.fg = bg_normal
c.colors.downloads.stop.bg = green
c.colors.downloads.error.fg = bg_normal
c.colors.downloads.error.bg = red

# Hint colors - gruvbox style
c.colors.hints.fg = bg_normal           # Dark text on bright background
c.colors.hints.bg = yellow              # Gruvbox yellow for hints
c.colors.hints.match.fg = bg_normal     # Dark text for matches
c.hints.border = f"1px solid {orange}"  # Orange border