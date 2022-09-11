---@diagnostic disable: lowercase-global

show_debugging = false
enemy_num = 10


function calculateDistance(x1, y1, x2, y2)
    return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end


 function saveGame (score)
    data = {
        high_score = score or 0
    }
    serialized = lume.serialize(data)
    -- The filetype actually doesn't matter, and can even be omitted.
    love.filesystem.write("savedata.txt", serialized)
end

