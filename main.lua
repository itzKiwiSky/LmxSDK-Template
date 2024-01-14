require('src.Components.Initialization.Run')
require('src.Components.Initialization.ErrorHandler')
preloader = require 'src.Components.Initialization.Preloader'

function love.load()
    --% lib sources %--
    json = require 'libraries.json'
    g3d = require 'libraries.g3d'
    camera = require 'libraries.camera'
    gamestate = require 'libraries.gamestate'
    timer = require 'libraries.timer'
    lip = require 'libraries.lip'
    nativefs = require 'libraries.nativefs'
    xml = require 'libraries.xml'
    slab = require 'libraries.slab'
    suit = require 'libraries.suit'
    bump = require 'libraries.bump'
    moonshine = require 'libraries.moonshine'
    sunlight = require 'libraries.sunlight'
    lollipop = require 'libraries.lollipop'
    object = require 'libraries.object'
    thirst = require 'libraries.thirst'
    collision = require 'libraries.collision'
    recursiveLoader = require 'src.Components.Initialization.RecursiveLoader'

    love.graphics.setDefaultFilter("nearest", "nearest")

    --% Console setup %--
    slab.SetINIStatePath(nil)
    slab.Initialize({"NoDocks"})
    consoleInterface = require 'src.Components.Interface.ConsoleInterface'
    consoleControl = require 'src.Components.ConsoleControl'
    consoleData = {
        output = {},
        input = "",
        active = false,
    }
    require('src.Components.Initialization.ConsoleCommands')()

    --% Game registers %--
    registers = {
        system = {
            fontSize = 20
        },
        enableConsole = true
    }

    --% Addon loader %--
    recursiveLoader("src/Addons")


    --% State loader %--
    recursiveLoader("src/States")

    --% Helper functions %--
    fontmanager = require 'src.Components.Helpers.FontManager'
    lovecallbacks = require 'src.Components.Helpers.LoveCallbacks'

    --% Save setup %--
    lollipop.currentSave.game = {}

    lollipop.initializeSlot("game")

    --% Content management %--
    if love.filesystem.isFused() then
        local sucess1 = love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "source") 
        local sucess2 = love.filesystem.mount(love.filesystem.newFileData(love.filesystem.read("source/game.assetdata"), "gameassets.zip"), "resources")

        if not sucess1 then
            love.window.showMessageBox("Luminix Error", "An Error occurred and the engine could not be initialized", "error")
            love.event.quit()
        end

        if not sucess2 then
            love.window.showMessageBox("Luminix Error", "An Error occurred during load folder 'resources'. The file does not exist.", "error")
            love.event.quit()
        end
    end

    --% Asset queue %--
    loveimage = love.graphics.newImage("resources/images/love.png")
    lmxsdk = love.graphics.newImage("resources/images/luminixsdk.png")
    plus = love.graphics.newImage("resources/images/plus.png")
    gradientPresent = love.graphics.newGradient("vertical", {255, 255, 255, 255}, {0, 0, 0, 0})


    AssetQueue = {
        images = {},
        sounds = {},
        fonts = {},
    }


    --% Asset preloading %--
    preloader.init("images", "resources/images")
    preloader.present("images")

    preloader.init("sounds", "resources/sounds")
    preloader.present("sounds")

    preloader.init("fonts", "resources/fonts")
    preloader.present("fonts")

    fontmanager.updateFontList()

    --% Release unused assets %--
    loveimage:release()
    lmxsdk:release()
    plus:release()
    gradientPresent:release()
    collectgarbage("collect")

    local lovehandlers = lovecallbacks({"draw"})
    gamestate.registerEvents(lovehandlers)
    gamestate.switch(playstate)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    gamestate.current():draw()
    love.graphics.print(love.timer.getFPS(), 5, 5)
    
    love.graphics.push()
    slab.Draw()
    love.graphics.pop()
end

function love.update(elapsed)
    slab.Update(elapsed)
    if consoleData.active then
        consoleInterface()
    end
end

function love.keypressed(k)
    if k == "'" then
        if registers.enableConsole then
            if consoleData.active then
                consoleData.active = false
            else
                consoleData.active = true
            end
        end
    end
end
