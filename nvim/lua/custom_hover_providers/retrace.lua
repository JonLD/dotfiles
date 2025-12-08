local M = {}

M.name = 'Retrace'
M.priority = 1000  -- High priority to check first

M.enabled = function()
  return true
end

-- Helper function to normalize trace IDs
local function normalize_trace_id(trace_id, trace_type)
    trace_id = trace_id:upper()

    if trace_type == "test" then
        -- Handle format like TS-001.arm_bracelet_illumination_level
        local ts_part, description = trace_id:match("^([^%.]+)%.(.+)$")
        if ts_part and description then
            local prefix, number = ts_part:match("^(%a+)%-(%d+)$")
            if prefix and number then
                return prefix .. "-" .. string.format("%04d", tonumber(number)) .. "." .. description
            end
        end
    else
        -- Handle format like RS-0069-0685
        local parts = {}
        for part in trace_id:gmatch("[^-]+") do
            local prefix = part:match("^(%a+)")
            local number = part:match("(%d+)$")
            if prefix and number then
                table.insert(parts, prefix .. string.format("%04d", tonumber(number)))
            else
                table.insert(parts, part)
            end
        end
        return table.concat(parts, "-")
    end

    return trace_id
end

-- Helper function to parse HTML and extract content
local function parse_html(html)
    local content_lines = {}

    -- Extract the short description from the first table
    local desc_match = html:match('<td class="emptyCheck">%s*([^<]+)')
    if desc_match and type(desc_match) == "string" then
        table.insert(content_lines, "Description:")
        local clean_desc = desc_match:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
        table.insert(content_lines, clean_desc)
        table.insert(content_lines, "")
    end

    -- Extract the detailed description
    local detailed = html:match('<h3>Detailed Description</h3>%s*<p[^>]*>(.-)</p>')
    if detailed then
        table.insert(content_lines, "Detailed Description:")
        -- Remove HTML tags and entities
        local clean = detailed:gsub("<[^>]+>", "")
                              :gsub("&nbsp;", " ")
                              :gsub("&lt;", "<")
                              :gsub("&gt;", ">")
                              :gsub("&amp;", "&")

        -- Split long text into wrapped lines
        local max_width = 78
        for para in clean:gmatch("[^\r\n]+") do
            para = para:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
            if para:match("%S") then
                -- Simple word wrapping
                local current_line = ""
                for word in para:gmatch("%S+") do
                    if #current_line + #word + 1 <= max_width then
                        current_line = current_line == "" and word or current_line .. " " .. word
                    else
                        if current_line ~= "" then
                            table.insert(content_lines, current_line)
                        end
                        current_line = word
                    end
                end
                if current_line ~= "" then
                    table.insert(content_lines, current_line)
                end
            end
        end
    end

    return content_lines
end

M.execute = function(opts, done)
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Check both @reqtrace{...} and @testtrace{...} patterns
  local patterns = {
    { type = "req", pattern = "@reqtrace%{([^}]+)%}" },
    { type = "test", pattern = "@testtrace%{([^}]+)%}" }
  }

  for _, trace_pattern in ipairs(patterns) do
    for trace_id in line:gmatch(trace_pattern.pattern) do
      local full_pattern = "@" .. trace_pattern.type .. "trace%{" .. trace_id:gsub("([%.%-])", "%%%1") .. "%}"
      local match_start, match_end = line:find(full_pattern)

      if match_start and match_end and col >= match_start and col <= match_end then
        -- Normalize the trace ID
        local normalized_id = normalize_trace_id(trace_id, trace_pattern.type)
        local url = "https://tech.cmrsurgical.com/retrace/trunk/req/" .. normalized_id

        -- Fetch the URL content asynchronously
        vim.system(
          { "curl", "-s", url },
          { text = true },
          vim.schedule_wrap(function(result)
            if result.code ~= 0 then
              done()
              return
            end

            -- Parse HTML to extract content
            local content_lines = parse_html(result.stdout)

            if #content_lines == 0 then
              done()
              return
            end

            -- Return the content to hover.nvim
            done({ lines = content_lines, filetype = "markdown" })
          end)
        )

        return
      end
    end
  end

  -- Not on a trace pattern, let other providers handle it
  done()
end

return M
