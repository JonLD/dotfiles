-- Get current project path using claude-code plugin's logic
local function get_current_project_path()
  local git = require("claude-code.git")
  local git_root = git.get_git_root()

  local path = git_root or vim.fn.getcwd()
  return path
end

-- Update summary in conversation file (for sessionId-based conversations)
local function update_summary(uuid, new_summary, project_path)
  local claude_dir = vim.fn.expand("~/.claude/projects")
  local encoded_path = project_path:gsub(":/", "--"):gsub("/", "-")
  local conversation_file = claude_dir .. "/" .. encoded_path .. "/" .. uuid .. ".jsonl"

  vim.notify("Debug: Looking for file: " .. conversation_file, vim.log.levels.INFO)

  -- Check if conversation file exists
  if vim.fn.filereadable(conversation_file) == 0 then
    vim.notify("Debug: File not found or not readable", vim.log.levels.ERROR)
    return false
  end

  local lines = vim.fn.readfile(conversation_file)
  local updated = false

  vim.notify("Debug: File has " .. #lines .. " lines", vim.log.levels.INFO)

  -- Find and update the summary line in the conversation file
  for i, line in ipairs(lines) do
    local ok, data = pcall(vim.json.decode, line)
    if ok and data.type == "summary" then
      vim.notify("Debug: Found summary line at " .. i .. ": " .. data.summary, vim.log.levels.INFO)
      local updated_data = vim.deepcopy(data)
      updated_data.summary = new_summary
      lines[i] = vim.json.encode(updated_data)
      updated = true
      break
    end
  end

  if updated then
    vim.fn.writefile(lines, conversation_file)
    vim.notify("Debug: File written successfully", vim.log.levels.INFO)
    return true
  else
    vim.notify("Debug: No summary line found in conversation file", vim.log.levels.WARN)
  end

  return false
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

        -- Parse through all lines to find summary, session info, and first user message
        local first_user_message = nil
        for _, line in ipairs(lines) do
          local ok, data = pcall(vim.json.decode, line)
          if ok then
            if data.summary then
              summary = data.summary
            end
            if data.sessionId and not session_id then
              session_id = data.sessionId
            end
            -- Capture first user message as fallback summary (skip system/caveat messages)
            if data.type == "user" and data.message and data.message.content and not first_user_message then
              local content_text = nil
              if type(data.message.content) == "table" and data.message.content[1] and data.message.content[1].text then
                content_text = data.message.content[1].text
              elseif type(data.message.content) == "string" then
                content_text = data.message.content
              end

              -- Skip system-generated messages and caveats
              if content_text and not content_text:match("^Caveat:") and not content_text:match("^<.*>") then
                first_user_message = content_text
              end
            end
          end
        end

        -- Only include conversations that have a session ID (indicating actual conversation content)
        if session_id then
          local display_summary, summary_type
          if summary then
            display_summary = summary
            summary_type = "Summary"
          elseif first_user_message then
            display_summary = first_user_message
            summary_type = "Message"
            -- Truncate long first messages to keep picker readable
            if #display_summary > 50 then
              display_summary = display_summary:sub(1, 47) .. "..."
            end
          else
            display_summary = "Conversation " .. session_id:sub(1, 8)
            summary_type = "Auto"
          end

          local stat = vim.loop.fs_stat(file_path)
          local uuid = file:gsub("%.jsonl$", "")

          table.insert(conversations, {
            summary = display_summary,
            project_path = decoded_path,
            uuid = uuid,
            mtime = stat and stat.mtime.sec or 0,
            summary_type = summary_type
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
      summary_type = conv.summary_type,
    })
  end

  Snacks.picker({
    name = "claude_conversations_local",
    items = items,
    format = function(item)
      return {
        { item.text, "SnacksPickerMatch" },
        { " [" .. item.summary_type .. "]", "SnacksPickerComment" },
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
    end,
    win = {
      input = {
        keys = {
          ["e"] = { "edit_summary", mode = { "n", "i" } },
        },
      },
    },
    actions = {
      edit_summary = function(picker)
        local selected = picker:current()
        if selected and selected.summary_type == "Summary" then
          local new_summary = vim.fn.input("Edit summary: ", selected.text)
          if new_summary and new_summary ~= "" and new_summary ~= selected.text then
            local current_path = get_current_project_path()
            if update_summary(selected.uuid, new_summary, current_path) then
              vim.notify("Summary updated successfully!", vim.log.levels.INFO)
              -- Refresh the picker
              picker:close()
              claude_conversation_picker_local()
            else
              vim.notify("Failed to update summary", vim.log.levels.ERROR)
            end
          end
        else
          vim.notify("Can only edit [Summary] type conversations", vim.log.levels.WARN)
        end
      end
    }
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
      summary_type = conv.summary_type,
    })
  end

  Snacks.picker({
    name = "claude_conversations_global",
    items = items,
    format = function(item)
      return {
        { item.text, "SnacksPickerMatch" },
        { " [" .. item.summary_type .. "]", "SnacksPickerComment" },
        { " (" .. item.desc .. " • " .. item.time_ago .. ")", "SnacksPickerComment" }
      }
    end,
    win = {
      input = {
        keys = {
          ["e"] = { "edit_summary", mode = { "n", "i" } },
        },
      },
    },
    actions = {
      edit_summary = function(picker)
        local selected = picker:current()
        if selected and selected.summary_type == "Summary" then
          local new_summary = vim.fn.input("Edit summary: ", selected.text)
          if new_summary and new_summary ~= "" and new_summary ~= selected.text then
            if update_summary(selected.uuid, new_summary, selected.project_path) then
              vim.notify("Summary updated successfully!", vim.log.levels.INFO)
              -- Refresh the picker
              picker:close()
              claude_conversation_picker_global()
            else
              vim.notify("Failed to update summary", vim.log.levels.ERROR)
            end
          end
        else
          vim.notify("Can only edit [Summary] type conversations", vim.log.levels.WARN)
        end
      end
    },
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
    { "<C-z>", "<CMD>ClaudeCode<CR>", desc = "Toggle Claude terminal" },
    { "<leader>ac", function() require("claude-code").continue() end, desc = "Claude continue" },
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
      window_navigation = false,
      toggle = {
        normal = false,  -- disable plugin's default keymap
        terminal = false,
      },
    },
  }
}
