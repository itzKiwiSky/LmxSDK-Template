return function(_tblToRemove)
    local callbacks = {}
    for k, v in pairs(love.handlers) do
        table.insert(callbacks, k)
    end

    for c = 1, #_tblToRemove, 1 do
        for d = 1, #callbacks, 1 do
            if callbacks[d] == _tblToRemove[c] then
                table.remove(callbacks, c)
            end
        end
    end

    return callbacks
end