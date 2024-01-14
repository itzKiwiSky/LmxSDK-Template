return function()
    slab.BeginWindow("ConsoleWindow", {Title = "Console"})
        slab.Input("ConsoleWindowOutputMultiline", {MultiLine = true, ReadOnly = true, Text = table.concat(consoleData.output, "\n"), W = love.graphics.getWidth() / 2 + 48, H = love.graphics.getHeight() / 2})
        if slab.Input("ConsoleWindowInput", {Text = consoleData.input, W = love.graphics.getWidth() / 2, H = 24}) then
            consoleData.input = slab.GetInputText()
        end
        slab.SameLine()
        if slab.Button("OK", {W = 48, H = 24}) then
            table.insert(consoleData.output, consoleData.input)
            consoleControl.fireCommand(consoleData.input)
            consoleData.input = ""
        end
    slab.EndWindow()
end