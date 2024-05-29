local console = {}
console.commands = {}

function console.registerCommands(_command, _function)
    console.commands[_command] = _function
end

function console.trace(_data)
    table.insert(consoleData.output, _data)
end

function console.fireCommand(_command)
    local tokens = string.split(_command, " ")
    local command = tokens[1]
    table.remove(tokens, 1)
    if console.commands[command] then
        console.commands[command](unpack(tokens))
    end
end

return console