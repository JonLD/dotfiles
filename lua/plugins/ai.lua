-- Get current project path using claude-code plugin's logic
local function get_current_project_path()
  local git = require("claude-code.git")
  local git_root = git.get_git_root()

  local path = git_root or vim.fn.getcwd()
  return path
end

-- Get current conversation UUID (if tracked)
local function get_current_conversation_uuid()
  return vim.g.claude_current_uuid
end


-- Get the last message UUID from a conversation file
local function get_last_message_uuid(conversation_file)
  local lines = vim.fn.readfile(conversation_file)

  -- Go through lines in reverse to find the last message with a UUID
  for i = #lines, 1, -1 do
    local ok, data = pcall(vim.json.decode, lines[i])
    if ok and data.uuid and (data.type == "user" or data.type == "assistant") then
      return data.uuid
    end
  end

  return nil
end

-- Update or create summary in conversation file
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

  -- First, try to find and update existing summary
  for i, line in ipairs(lines) do
    local ok, data = pcall(vim.json.decode, line)
    if ok and data.type == "summary" then
      vim.notify("Debug: Found existing summary line at " .. i .. ": " .. data.summary, vim.log.levels.INFO)
      local updated_data = vim.deepcopy(data)
      updated_data.summary = new_summary
      lines[i] = vim.json.encode(updated_data)
      updated = true
      break
    end
  end

  -- If no existing summary found, warn instead of creating new one for active conversations
  if not updated then
    vim.notify("This conversation doesn't have a summary yet. Claude CLI might create one automatically later.", vim.log.levels.WARN)
    return false
  end

  if updated then
    vim.fn.writefile(lines, conversation_file)
    vim.notify("Debug: File written successfully", vim.log.levels.INFO)
    return true
  end

  return false
end

-- Edit summary of currently open conversation
local function edit_current_conversation_summary()
  local current_uuid = get_current_conversation_uuid()
  if not current_uuid then
    vim.notify("No active conversation tracked. Use conversation picker first.", vim.log.levels.WARN)
    return
  end

  local current_path = get_current_project_path()
  local claude_dir = vim.fn.expand("~/.claude/projects")
  local encoded_path = current_path:gsub(":/", "--"):gsub("/", "-")
  local conversation_file = claude_dir .. "/" .. encoded_path .. "/" .. current_uuid .. ".jsonl"

  -- Get current summary info using existing parsing logic
  local lines = vim.fn.readfile(conversation_file)
  local current_summary = nil
  local summary_type = "Auto"

  -- Find existing summary and first user message (reuse existing logic)
  local first_user_message = nil
  for _, line in ipairs(lines) do
    local ok, data = pcall(vim.json.decode, line)
    if ok then
      if data.summary then
        current_summary = data.summary
        summary_type = "Summary"
      end
      if data.type == "user" and data.message and data.message.content and not first_user_message then
        local content_text = nil
        if type(data.message.content) == "table" and data.message.content[1] and data.message.content[1].text then
          content_text = data.message.content[1].text
        elseif type(data.message.content) == "string" then
          content_text = data.message.content
        end

        if content_text and not content_text:match("^Caveat:") and not content_text:match("^<.*>") then
          first_user_message = content_text
        end
      end
    end
  end

  -- Set display summary and type (same logic as picker)
  if not current_summary and first_user_message then
    current_summary = first_user_message
    summary_type = "Message"
    if #current_summary > 50 then
      current_summary = current_summary:sub(1, 47) .. "..."
    end
  end

  if summary_type ~= "Summary" then
    vim.notify("This conversation doesn't have a summary yet. You can only edit existing summaries to avoid breaking conversation continuity.", vim.log.levels.WARN)
    return
  end

  local prompt_text = "Edit summary: "
  local default_text = current_summary or ""
  local new_summary = vim.fn.input(prompt_text, default_text)

  if new_summary and new_summary ~= "" and new_summary ~= current_summary then
    if update_summary(current_uuid, new_summary, current_path) then
      vim.notify("Summary updated successfully!", vim.log.levels.INFO)
    else
      vim.notify("Failed to update summary", vim.log.levels.ERROR)
    end
  end
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

        -- Parse through all lines to find summary, session info, first user message, and timestamps
        local first_user_message = nil
        local created_time = nil
        local last_edited_time = nil

        for _, line in ipairs(lines) do
          local ok, data = pcall(vim.json.decode, line)
          if ok then
            if data.summary then
              summary = data.summary
            end
            if data.sessionId and not session_id then
              session_id = data.sessionId
            end

            -- Track timestamps from messages
            if data.timestamp and (data.type == "user" or data.type == "assistant") then
              if not created_time then
                created_time = data.timestamp
              end
              last_edited_time = data.timestamp -- Keep updating to get the last one
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

          local uuid = file:gsub("%.jsonl$", "")

          -- Convert timestamp to Unix epoch for sorting (fallback to file mtime if no timestamp)
          local last_edited_epoch = 0
          if last_edited_time then
            -- Parse ISO timestamp to Unix epoch
            local year, month, day, hour, min, sec = last_edited_time:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
            if year then
              last_edited_epoch = os.time({
                year = tonumber(year),
                month = tonumber(month),
                day = tonumber(day),
                hour = tonumber(hour),
                min = tonumber(min),
                sec = tonumber(sec)
              })
            end
          else
            -- Fallback to file modification time
            local stat = vim.loop.fs_stat(file_path)
            last_edited_epoch = stat and stat.mtime.sec or 0
          end

          table.insert(conversations, {
            summary = display_summary,
            project_path = decoded_path,
            uuid = uuid,
            mtime = last_edited_epoch,
            created_time = created_time,
            last_edited_time = last_edited_time,
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
        { " (Edited " .. item.time_ago .. ")", "SnacksPickerComment" }
      }
    end,
    confirm = function(picker)
      local selected = picker:current()
      if selected and selected.uuid then
        local claude_code = require("claude-code")
        local original_command = claude_code.config.command

        -- Store the UUID for current conversation tracking
        vim.g.claude_current_uuid = selected.uuid

        claude_code.config.command = original_command .. ' --resume ' .. selected.uuid
        claude_code.toggle()
        claude_code.config.command = original_command
      end
    end,
    win = {
      input = {
        keys = {
          ["e"] = { "edit_summary", mode = "n" },
          ["<M-e>"] = { "edit_summary", mode = "i" },
        },
      },
    },
    actions = {
      edit_summary = function(picker)
        local selected = picker:current()
        if selected then
          if selected.summary_type ~= "Summary" then
            vim.notify("This conversation doesn't have a summary yet. You can only edit existing summaries to avoid breaking conversation continuity.", vim.log.levels.WARN)
            return
          end

          local prompt_text = "Edit summary: "
          local default_text = selected.text or ""
          local new_summary = vim.fn.input(prompt_text, default_text)

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
        { " (" .. item.desc .. " • Edited " .. item.time_ago .. ")", "SnacksPickerComment" }
      }
    end,
    win = {
      input = {
        keys = {
          ["e"] = { "edit_summary", mode = "n" },
          ["<M-e>"] = { "edit_summary", mode = "i" },
        },
      },
    },
    actions = {
      edit_summary = function(picker)
        local selected = picker:current()
        if selected then
          if selected.summary_type ~= "Summary" then
            vim.notify("This conversation doesn't have a summary yet. You can only edit existing summaries to avoid breaking conversation continuity.", vim.log.levels.WARN)
            return
          end

          local prompt_text = "Edit summary: "
          local default_text = selected.text or ""
          local new_summary = vim.fn.input(prompt_text, default_text)

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
    { "<leader>ae", edit_current_conversation_summary, desc = "Edit current conversation summary" },
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
