local function recursiveLoader(_path)
    local items = love.filesystem.getDirectoryItems(_path)
    for item = 1, #items, 1 do
        local path = _path .. "/" .. items[item]
        if love.filesystem.getInfo(path).type == "directory" then
            recursiveLoader(path)
        end
        if love.filesystem.getInfo(path).type == "file" then
            require(path:gsub(".lua", ""))
        end
    end
end

return recursiveLoader