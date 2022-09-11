---@diagnostic disable: lowercase-global, param-type-mismatch
local love = require"love"
local Player = require("objects/Player")
local Game = require("states/Game")
local Menu = require "states.Menu"
local SFX = require "components.SFX"
local resetComplete = false -- if game needs to be reset

lume = require "lume"


math.randomseed(os.time())
io.stdout:setvbuf("no")

function reset()
    if love.filesystem.getInfo("savedata.txt") ~= nil then
        file = love.filesystem.read("savedata.txt")
        data = lume.deserialize(file)
    else

        saveGame()
        file = love.filesystem.read("savedata.txt")
        data = lume.deserialize(file)
       
    end

    -- create the soundeffects
    sfx = SFX()
    player = Player(3, sfx)
    game = Game(data, sfx)
    menu = Menu(game, player, sfx)
end

function love.load()
    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0, 0
    image = love.graphics.newImage("src/background.png")
    reset()

    -- will play bgm, does not have to be inside reset(), since
    -- it doesn't have to restart or anything when game over
    sfx:playBGM()
end


function love.keypressed(key)
    if game.state.running then
        if key == "space" then
            player:shoot()
        end

        if key == "escape" then
            game:changeGameState("paused")
        end

    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
    
    
end


function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            player:shoot()
        else
            clickedMouse = true -- set if mouse is clicked
        end
    end
end


function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
   
    if game.state.running then
       
        player:move(dt)
        if  not (enemies[enemy_num] == nil) and enemy_num ~= 0 then
  
            enemies[enemy_num]:move(dt)
            if not player.exploading then
                if calculateDistance(player.x, player.y, enemies[enemy_num].x, enemies[enemy_num].y) < enemies[enemy_num].height then
                    -- check if ship and asteroid colided
                    player:expload()
                    enemies[enemy_num]:destroyEnemy(game)
                end
            else
                player.expload_time = player.expload_time - 1
                if player.expload_time == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end
                    player = Player(player.lives - 1, sfx)
                end
            end
            for _, laser in pairs(player.lasers) do
                if  not (enemies[enemy_num] == nil) and enemy_num ~= 0 then
                    if calculateDistance(laser.x, laser.y, enemies[enemy_num].x, enemies[enemy_num].y) < (enemies[enemy_num].height)  then
                        laser:expload() -- delete laser
                        enemies[enemy_num]:destroyEnemy(game)
                    elseif enemies[enemy_num]:exceedEdges() then
                        enemies[enemy_num]:destroyEnemy(game)
                    end
                end
            end
        end

        if #enemies == 0 then
            game.level = game.level + 1
            game:startNewGame(player)
        end


    elseif game.state.menu then
        menu:run(clickedMouse)
        clickedMouse = false

        -- this will reset everything to original state
        if not resetComplete then
            reset()
            resetComplete = true
        end
    elseif game.state.ended then
        -- we should reset the game
        resetComplete = false
    end
    end


function love.draw()
    love.graphics.draw(image)


    if game.state.running or game.state.paused then

        player:drawLives(game.state.paused)
        player:draw(game.state.paused)

        if  not (enemies[enemy_num] == nil) then
            enemies[enemy_num]:draw(game.state.paused)
        end

        game:draw(game.state.paused) -- we can now draw the paused screen 
    elseif game.state.menu then
        menu:draw()
    elseif game.state.ended then
        game:draw()
    end

    love.graphics.setColor(1, 1, 1)

    if not game.state.running then -- draw cursor if not in running state
        love.graphics.circle("fill", mouse_x, mouse_y, 10)
    end

    love.graphics.print(love.timer.getFPS(), 10, 10)

end