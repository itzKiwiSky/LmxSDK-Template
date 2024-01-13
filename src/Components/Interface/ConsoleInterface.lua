return function()
    slab.BeginWindow("ConsoleWindow", {Title = "Console"})
        slab.Input("ConsoleWindowOutputMultiline", {MultiLine = true, ReadOnly = true, Text = table.concat(consoleData.output, "\n"), W = 640, H = 480})
        if slab.Input("ConsoleWindowInput", {Text = consoleData.input, W = 600, H = 24}) then
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