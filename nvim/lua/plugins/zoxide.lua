return {
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      -- Custom zoxide integration for snacks picker
      local function zoxide_picker()
        local Job = require("plenary.job")

        Job:new({
          command = "zoxide",
          args = { "query", "--list" },
          on_exit = function(j, return_val)
            if return_val ~= 0 then
              vim.notify("Zoxide failed: " .. table.concat(j:stderr_result(), "\n"), vim.log.levels.ERROR)
              return
            end

            local results = j:result()
            if #results == 0 then
              vim.notify("No zoxide entries found", vim.log.levels.WARN)
              return
            end

            vim.schedule(function()
              local formatted_items = {}
              for _, path in ipairs(results) do
                local dir_name = vim.fn.fnamemodify(path, ":t")
                table.insert(formatted_items, {
                  text = dir_name .. " (" .. path .. ")",
                  file = path,
                })
              end

              Snacks.picker.pick({
                source = "zoxide",
                items = formatted_items,
                confirm = function(item)
                  vim.schedule(function()
                    vim.cmd("cd " .. vim.fn.fnameescape(item.file))
                    vim.notify("Changed directory to: " .. item.file)
                  end)
                end,
              })
            end)
          end,
        }):start()
      end

      -- Add zoxide command
      vim.api.nvim_create_user_command("Z", function(args)
        if args.args == "" then
          zoxide_picker()
        else
          -- Query specific directory
          local Job = require("plenary.job")
          Job:new({
            command = "zoxide",
            args = { "query", args.args },
            on_exit = function(j, return_val)
              if return_val ~= 0 then
                vim.notify("Zoxide query failed: " .. table.concat(j:stderr_result(), "\n"), vim.log.levels.ERROR)
                return
              end

              local result = j:result()[1]
              if result then
                vim.schedule(function()
                  vim.cmd("cd " .. vim.fn.fnameescape(result))
                  vim.notify("Changed directory to: " .. result)
                end)
              else
                vim.notify("No directory found for: " .. args.args, vim.log.levels.WARN)
              end
            end,
          }):start()
        end
      end, {
        nargs = "?",
        desc = "Jump to directory using zoxide",
        complete = function()
          -- Basic completion with zoxide query
          local Job = require("plenary.job")
          local results = {}
          Job:new({
            command = "zoxide",
            args = { "query", "--list" },
            on_exit = function(j, return_val)
              if return_val == 0 then
                results = j:result()
              end
            end,
          }):sync()

          -- Return just directory names for completion
          local completions = {}
          for _, path in ipairs(results) do
            table.insert(completions, vim.fn.fnamemodify(path, ":t"))
          end
          return completions
        end,
      })

      return opts
    end,
  }
}
