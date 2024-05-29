local _FPSCap = 300
local _unfocusedFPSCap = 15
slab = require 'libraries.slab'
local debugMode = false

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end

    if love.load then 
        love.load(love.arg.parseGameArguments(arg), arg)

        local parsedArgs = love.arg.parseGameArguments(arg)
        debugMode = parsedArgs[1] == "--debug" and true or false

        if debugMode then
            slab.SetINIStatePath(nil)
            slab.Initialize({"NoDocks"})
            
            consoleInterface = require 'src.Components.Interface.ConsoleInterface'
            consoleControl = require 'src.Components.Modules.ConsoleControl'
            consoleData = {
                output = {},
                input = "",
                active = false,
            }
            require('src.Components.Initialization.ConsoleCommands')()
        end
    end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local elapsed = 0

    -- Main loop time.
    return function()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                if debugMode then
                    if name == "keypressed" then
                        if a == "'" then
                            consoleData.active = not consoleData.active
                        end
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then elapsed = love.timer.step() end

        -- Call update and draw
        if love.update then 
            love.update(elapsed)
            if debugMode then
                slab.Update(elapsed)
                if consoleData.active then
                    consoleInterface()
                end
            end
        end -- will pass 0 if love.timer is disabled

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then 
                love.draw()

                if debugMode then
                    slab.Draw()
                    love.graphics.print(love.timer.getFPS(), 5, 5)
                end
            end

            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
        collectgarbage("collect")
    end
end