function Laser(x,y)

    local EXPLODE_DUR = 0.5
    return{
        x = x,
        y = y,
        image = love.graphics.newImage("src/laser/tile_0000.png"),
        speed = 500,
        width = 16,
        height = 16,
        distance = 0,
        first_y = y,
         -- exploading: 0 = safe; 1 = exploading; 2 = done exploading
         exploading = 0,
         expload_time = 0, -- how long has been exploading
 

        move = function (self,dt)
            self.y = self.y - dt * self.speed

            if self.y < 0 then --up
                return false
            end
            self.distance = self.first_y  - self.y
        end,

        draw = function (self)
            local opacity = 1

            if show_debugging then
                love.graphics.setColor(1, 0, 0)
        
                love.graphics.rectangle( "line", self.x + 7 , self.y - 5, self.width , self.height + 27)
                
                love.graphics.setColor(1, 1, 1)
            end

            if self.exploading < 1 then
                love.graphics.draw(self.image, self.x ,self.y,0,2)
            else
                love.graphics.setColor(1, 104/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 10 * 1.5)

                love.graphics.setColor(1, 234/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 10 * 1)
            end
           
        end,

        expload = function (self)
            self.expload_time = math.ceil(EXPLODE_DUR * (love.timer.getFPS() / 100))
            if self.expload_time > EXPLODE_DUR then
                self.exploading = 2
            end
        end,

    }
end
return Laser