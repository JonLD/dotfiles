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

# Basic UI configuration
c.colors.webpage.darkmode.enabled = True
c.tabs.position = "left"
c.tabs.padding = {"top": 8, "bottom": 8, "left": 5, "right": 5}

# Tab indicator colors
c.colors.tabs.indicator.start = "#5f8787"  # Loading (blue-ish)
c.colors.tabs.indicator.stop = "#2d2d2d"   # Success (same as tab bg - invisible)
c.colors.tabs.indicator.error = "#ff5f5f"  # Error (red)
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

# Subtle dark color scheme
# Base colors - muted and subtle
base_bg = "#1e1e1e"          # Main background
darker_bg = "#0d1117"        # Darker background for menus
lighter_bg = "#252526"       # Slightly lighter sections
subtle_accent = "#404040"    # Subtle grey accent (much less prominent)
text_primary = "#d4d4d4"     # Primary text color
text_secondary = "#9d9d9d"   # Secondary text
success_green = "#4ec9b0"    # Success/HTTPS color
error_red = "#f44747"        # Error color
warning_orange = "#ffcc02"   # Warning color

# Tab colors - balanced darkness
c.colors.tabs.bar.bg = base_bg
c.colors.tabs.even.bg = "#1a1a1a"    # Not too dark for unselected
c.colors.tabs.odd.bg = "#1a1a1a"     # Not too dark for unselected
c.colors.tabs.even.fg = text_primary
c.colors.tabs.odd.fg = text_primary
c.colors.tabs.selected.even.bg = "#2a2a2a"    # Darker grey for selected
c.colors.tabs.selected.odd.bg = "#2a2a2a"     # Darker grey for selected
c.colors.tabs.selected.even.fg = "#ffffff"
c.colors.tabs.selected.odd.fg = "#ffffff"

# Status bar colors
c.colors.statusbar.normal.bg = base_bg
c.colors.statusbar.normal.fg = text_primary
c.colors.statusbar.insert.bg = subtle_accent
c.colors.statusbar.insert.fg = "#ffffff"
c.colors.statusbar.command.bg = darker_bg
c.colors.statusbar.command.fg = text_primary

# URL bar colors (in status bar)
c.colors.statusbar.url.fg = text_primary
c.colors.statusbar.url.success.https.fg = success_green
c.colors.statusbar.url.error.fg = error_red
c.colors.statusbar.url.warn.fg = warning_orange

# Completion menu colors - dark and subtle
c.colors.completion.fg = text_primary
c.colors.completion.odd.bg = darker_bg
c.colors.completion.even.bg = base_bg
c.colors.completion.category.fg = text_secondary
c.colors.completion.category.bg = darker_bg
c.colors.completion.item.selected.fg = "#ffffff"
c.colors.completion.item.selected.bg = subtle_accent
c.colors.completion.item.selected.border.top = subtle_accent
c.colors.completion.item.selected.border.bottom = subtle_accent
c.colors.completion.match.fg = warning_orange

# Downloads
c.colors.downloads.bar.bg = base_bg
c.colors.downloads.start.fg = "#ffffff"
c.colors.downloads.start.bg = subtle_accent
c.colors.downloads.stop.fg = "#ffffff"
c.colors.downloads.stop.bg = success_green
c.colors.downloads.error.fg = "#ffffff"
c.colors.downloads.error.bg = error_red

# Hint colors - dark blue background
c.colors.hints.fg = "#ffffff"           # White text
c.colors.hints.bg = "#2c3e50"           # Dark blue-grey background
c.colors.hints.match.fg = "#ffffff"     # White text for matches
c.hints.border = "1px solid #2c3e50"    # Border matches background