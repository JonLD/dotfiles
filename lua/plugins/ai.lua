-- Get current project path using claude-code plugin's logic
local function get_current_project_path()
  local git = require("claude-code.git")
  local git_root = git.get_git_root()

  local path = git_root or vim.fn.getcwd()
  return path
end

-- Format time ago string
local function format_time_ago(mtime)
  local now = os.time()
  local diff = now - mtime

  if diff < 60 then
    return "just now"
  elseif diff < 3600 then
    local minutes = math.floor(diff / 60)
    return minutes == 1 and "1 minute ago" or minutes .. " minutes ago"
  elseif diff < 86400 then
    local hours = math.floor(diff / 3600)
    return hours == 1 and "1 hour ago" or hours .. " hours ago"
  elseif diff < 2592000 then
    local days = math.floor(diff / 86400)
    return days == 1 and "1 day ago" or days .. " days ago"
  else
    local months = math.floor(diff / 2592000)
    return months == 1 and "1 month ago" or months .. " months ago"
  end
end

-- Parse all Claude conversations from all projects
local function get_all_conversations()
  local claude_dir = vim.fn.expand("~/.claude/projects")
  local project_dirs = vim.fn.readdir(claude_dir)
  local conversations = {}

  for _, project_dir in ipairs(project_dirs) do
    -- Decode directory name: C--dev-reedline -> C:/dev/reedline
    local decoded_path = project_dir:gsub("%-%-", ":/"):gsub("%-", "/")
    local history_file_path = claude_dir .. "/" .. project_dir
    local conv_files = vim.fn.readdir(history_file_path)

    for _, file in ipairs(conv_files) do
      if file:match("%.jsonl$") then
        local file_path = history_file_path .. "/" .. file
        local lines = vim.fn.readfile(file_path)

        local summary = nil
        local session_id = nil

        -- Parse through all lines to find summary and session info
        for _, line in ipairs(lines) do
          local ok, data = pcall(vim.json.decode, line)
          if ok then
            if data.type == "summary" and data.summary then
              summary = data.summary
            elseif data.sessionId and not session_id then
              session_id = data.sessionId
            end
          end
        end

        -- Only include conversations that have a session ID (indicating actual conversation content)
        if session_id then
          local display_summary = summary or ("Conversation " .. session_id:sub(1, 8))
          local stat = vim.loop.fs_stat(file_path)
          local uuid = file:gsub("%.jsonl$", "")

          table.insert(conversations, {
            summary = display_summary,
            project_path = decoded_path,
            uuid = uuid,
            mtime = stat and stat.mtime.sec or 0
          })
        end
      end
    end
  end

  return conversations
end

-- Local Claude conversation picker (current project only)
local function claude_conversation_picker_local()
  local current_path = get_current_project_path()
  local all_conversations = get_all_conversations()

  -- Filter conversations for current project
  local local_conversations = {}
  for _, conv in ipairs(all_conversations) do
    if conv.project_path == current_path then
      table.insert(local_conversations, conv)
    end
  end

  if #local_conversations == 0 then
    vim.notify("No conversations found for current project: " .. current_path, vim.log.levels.INFO)
    return
  end

  -- Sort by modification time (newest first)
  table.sort(local_conversations, function(a, b) return a.mtime > b.mtime end)

  local items = {}
  for _, conv in ipairs(local_conversations) do
    table.insert(items, {
      text = conv.summary,
      uuid = conv.uuid,
      time_ago = format_time_ago(conv.mtime),
    })
  end

  Snacks.picker({
    name = "claude_conversations_local",
    items = items,
    format = function(item)
      return {
        { item.text, "SnacksPickerMatch" },
        { " (" .. item.time_ago .. ")", "SnacksPickerComment" }
      }
    end,
    confirm = function(picker)
      local selected = picker:current()
      if selected and selected.uuid then
        local claude_code = require("claude-code")
        local original_command = claude_code.config.command

        claude_code.config.command = original_command .. ' --resume ' .. selected.uuid
        claude_code.toggle()
        claude_code.config.command = original_command
      end
    end
  })
end

-- Global Claude conversation picker (all projects)
local function claude_conversation_picker_global()
  local all_conversations = get_all_conversations()

  if #all_conversations == 0 then
    vim.notify("No conversations found", vim.log.levels.INFO)
    return
  end

  -- Sort by modification time (newest first)
  table.sort(all_conversations, function(a, b) return a.mtime > b.mtime end)

  local items = {}
  for _, conv in ipairs(all_conversations) do
    table.insert(items, {
      text = conv.summary,
      desc = conv.project_path,
      uuid = conv.uuid,
      project_path = conv.project_path,
      time_ago = format_time_ago(conv.mtime),
    })
  end

  Snacks.picker({
    name = "claude_conversations_global",
    items = items,
    format = function(item)
      return {
        { item.text, "SnacksPickerMatch" },
        { " (" .. item.desc .. " • " .. item.time_ago .. ")", "SnacksPickerComment" }
      }
    end,
    confirm = function(picker)
      local selected = picker:current()
      if selected and selected.uuid then
        local claude_code = require("claude-code")

        -- Change to the project directory
        local original_cwd = vim.fn.getcwd()
        vim.notify("Debug: Changing from " .. original_cwd .. " to " .. selected.project_path)
        vim.cmd("cd " .. vim.fn.fnameescape(selected.project_path))
        vim.notify("Debug: Now in " .. vim.fn.getcwd())

        local original_command = claude_code.config.command
        local resume_command = original_command .. ' --resume ' .. selected.uuid
        vim.notify("Debug: Running command: " .. resume_command)
        claude_code.config.command = resume_command
        claude_code.toggle()
        claude_code.config.command = original_command

        -- Restore original directory
        vim.cmd("cd " .. vim.fn.fnameescape(original_cwd))
      end
    end
  })
end

return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  keys = {
    { "<C-a>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude terminal" },
    { "<leader>cC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude continue" },
    { "<leader>a", group = "AI", icon = "🤖" },
    { "<leader>ar", claude_conversation_picker_local, desc = "Claude conversations (local)" },
    { "<leader>aR", claude_conversation_picker_global, desc = "Claude conversations (global)" },
  },
  opts = {
    shell = {
      separator = ';',      -- Use ';' instead of '&&' for nushell
      pushd_cmd = 'cd',     -- Use 'cd' for directory changes in nushell
      popd_cmd = '',        -- Empty since we're not using directory stack
    },
    git = {
      use_git_root = true,  -- Keep git root functionality with nushell-compatible commands
    },
    window = {
      position = "vertical"  -- Open in vertical split instead of horizontal
    },
    keymaps = {
      toggle = {
        normal = false,  -- disable plugin's default keymap
        terminal = false,
      },
    },
  }
}
