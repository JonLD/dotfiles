--- @since 25.12.29

local get_state = ya.sync(function()
	local h = cx.active.current.hovered
	return {
		cwd    = tostring(cx.active.current.cwd),
		url    = h and h.url,
		is_dir = h and h.cha.is_dir,
		unique = #cx.active.current.files == 1,
	}
end)

-- Convert query into a fuzzy regex: "src" -> "s.*r.*c"
local function fuzzy_pattern(query)
	if query == "" then return "" end
	local chars = {}
	for c in query:gmatch(".") do
		chars[#chars + 1] = c:gsub("([%.%*%+%?%(%)%[%]%{%}%|%^%$%\\])", "\\%1")
	end
	return table.concat(chars, ".*")
end

local function prompt()
	return ya.input {
		title    = "Filter:",
		pos      = { "top-center", y = 2, w = 50 },
		realtime = true,
		debounce = 0.1,
	}
end

local function entry(_, args)
	local auto_enter = args and args[1] == "auto_enter"
	local input      = prompt()
	local prev_cwd   = get_state().cwd

	while true do
		local value, event = input:recv()
		if event == 0 then break end

		if event == 1 or event == 3 then
			ya.emit("filter_do", { fuzzy_pattern(value), insensitive = true })
			ya.emit("arrow", { -math.maxinteger })
		end

		local st = get_state()

		-- Auto-enter when exactly one directory matches (opt-in)
		if auto_enter and event == 3 and st.unique and st.is_dir then
			ya.emit("escape", { filter = true })
			ya.emit("enter", {})
			prev_cwd = get_state().cwd
			input    = prompt()

		-- Submit: open file or enter directory
		elseif event == 1 then
			ya.emit("escape", { filter = true })
			ya.emit(st.is_dir and "enter" or "open", { st.url })
			break

		-- Cancel: C-l/C-h fire `close` before mgr:enter/leave.
		-- Distinguish navigation from Escape by checking whether cwd changed.
		elseif event == 2 then
			ya.emit("escape", { filter = true })
			local new_cwd = get_state().cwd
			if new_cwd ~= prev_cwd then
				prev_cwd = new_cwd
				input    = prompt()
			else
				break
			end
		end
	end
end

return { entry = entry }
