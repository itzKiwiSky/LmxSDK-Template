return function()
    --% Register your commands here %--
    consoleControl.registerCommands("echo", function(...)
        local args = {...}
        consoleControl.trace("[" ..  os.date("%Y-%m-%d %H:%M:%S") .. "] | " .. table.concat(args, " "))
    end)
end