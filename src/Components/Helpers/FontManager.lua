local fontManager = {}
fontManager.fontList = {}

function fontManager.updateFontList()
    for k, v in pairs(AssetQueue.fonts) do
        table.insert(fontManager.fontList, k)
    end
end

function fontManager.setGlobalFontSize(_size)
    for k, v in pairs(AssetQueue.fonts) do
        AssetQueue.fonts[k] = love.graphics.newFont("resources/fonts/" .. k .. ".ttf", _size)
    end
end

function fontManager.updateFontSize(_font, _size)
    AssetQueue.fonts[_font] = love.graphics.newFont("resources/fonts/" .. _font .. ".ttf", _size)
end

return fontManager