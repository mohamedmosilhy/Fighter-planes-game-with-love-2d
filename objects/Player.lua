---@diagnostic disable: undefined-global
require "globals"
local Laser = require"objects/Laser"

function Player(num_lives,sfx)
    EXPLOAD_DUR = 1
   return{
    x = love.graphics.getWidth() * 0.45 ,
    y = love.graphics.getHeight() - 200,
    image = love.graphics.newImage("src/ships/Biploar_type4_1.png"),
    speed = 500,
    width = 170,
    height = 165,
    radius = 20,
    lasers = {},
    expload_time = 0, -- if the ship crashed
    exploading = false, -- if ship exploading
    MAX_LASERS = 6,
    lives = num_lives or 3,
    live_image = love.graphics.newImage("src/ships/ship_0005.png"),

    drawLives = function (self,faded)
        if not faded then

                if self.lives == 2 then
                    love.graphics.setColor(1, 1, 0.5)
                elseif self.lives == 1 then
                    love.graphics.setColor(1, 0.2, 0.2)
                else
                    love.graphics.setColor(1, 1, 1)
                end
                local x_pos, y_pos = 45, 30
                for i = 1, self.lives do
                    if self.exploading then
                        if i == self.lives then
                            love.graphics.setColor(1, 0, 0)
                        end
                    end
                  
                    love.graphics.draw(self.live_image, x_pos * i,y_pos)
                end
            end
        end,



    shoot = function (self)
            if (#self.lasers <= self.MAX_LASERS) then
                table.insert(self.lasers, Laser(self.x + self.width / 2 + 15, self.y + 15))

                 -- add laser sfx
                sfx:playFX("laser")
            end
             
    end,

    destroyLaser = function (self,index)
        table.remove(self.lasers, index)
    end,

    exceedEdges = function (self)
        if self.x + self.width > love.graphics.getWidth() - 30 then -- right 
            self.x = love.graphics.getWidth() - (self.width + 30)
            return true
        elseif self.x < 0 then --left
            self.x = 0 
            return true
        end
        if self.y + self.height > love.graphics.getHeight() - 30 then -- down 
            self.y = love.graphics.getHeight() - (self.height + 30)
            return true
        elseif self.y < 0 then --up
            self.y = 0
            return true
        end

        return false
    end,

    move =function (self,dt)
        self.exploading = self.expload_time > 0
        if not self.exploading then
            if love.keyboard.isDown("a") or love.keyboard.isDown("left")  then
                self.x = self.x - self.speed * dt
                self:exceedEdges()
            elseif love.keyboard.isDown("d") or love.keyboard.isDown("right")   then
                self.x = self.x + self.speed * dt
                self:exceedEdges()
            elseif love.keyboard.isDown("w") or love.keyboard.isDown("up")   then
                self.y = self.y - self.speed * dt
                self:exceedEdges()
            elseif love.keyboard.isDown("s") or love.keyboard.isDown("down")   then
                self.y = self.y + self.speed * dt
                self:exceedEdges()
            end
        end
        for i, laser in pairs(self.lasers) do
            if (laser.y < 0) and (laser.exploading == 0)  then
                laser:expload()
            end
            if laser.exploading == 0 then -- 0 -> laser not exploading
                laser:move(dt)
            elseif laser.exploading == 2 then -- 2 -> laser is done exploading
                self.destroyLaser(self, i)
            end
        end

    end,




    draw = function (self,faded)
        if not self.exploading then
            if show_debugging then
                love.graphics.setColor(1, 0, 0)
        
                love.graphics.rectangle( "line", self.x + 30, self.y + 35, self.width, self.height)
                
    
                love.graphics.setColor(1, 1, 1)
    
            end
            love.graphics.setColor(1, 1, 1, opacity)
    
            for _, laser in pairs(self.lasers) do
                laser:draw()
            end
            if not faded then
                love.graphics.draw(self.image, self.x ,self.y)
            end
            
        else -- if the ship exploaded
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", self.x + 30 + 85, self.y + 35, self.radius * 1.5)

            love.graphics.setColor(1, 158/255, 0)
            love.graphics.circle("fill", self.x + 30 + 85, self.y + 35, self.radius * 1)

            love.graphics.setColor(1, 234/255, 0)
            love.graphics.circle("fill", self.x + 30 + 85, self.y + 35, self.radius * 0.5)

            love.graphics.setColor(1,1,1)
        end
        
    end,

    expload = function (self) -- player can now expload
        sfx:playFX("ship_explosion")
        self.expload_time = math.ceil(EXPLOAD_DUR * love.timer.getFPS())
    end,

   } 
end

return Player