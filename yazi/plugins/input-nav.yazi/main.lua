local function entry(_, args)
	ya.notify { title = "input-nav", content = "fired: " .. (args[1] or "?"), timeout = 2 }
	ya.emit("arrow", { tonumber(args[1]) or 1 })
end

return { entry = entry }
