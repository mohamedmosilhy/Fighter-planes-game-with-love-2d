---@diagnostic disable: lowercase-global
function Enemy(x, y, level,sfx)

    local ENEMY_SPEED = (level * 70)

    return{
        x = x,
        y = y,
        y_vel = ENEMY_SPEED ,
        width = 170,
        height = 165,
        image = love.graphics.newImage("src/ships/Biploar_type6_1.png"),

        draw = function (self,faded)
            if show_debugging then
                love.graphics.setColor(1, 0, 0)
      
                love.graphics.rectangle( "line", self.x + 55 , self.y + 45, self.width, self.height)
                
    
                love.graphics.setColor(1, 1, 1)
    
            end
            if  not faded then
                love.graphics.draw(self.image, self.x ,self.y)
            end
            
        end,

        move = function (self,dt)
            self.y = self.y + self.y_vel * dt
            self:exceedEdges()
        end,

        exceedEdges = function (self)
            if self.y + self.height > love.graphics.getHeight() - 30 then
                return true
            else
                return false
            end
        end,

        destroyEnemy = function (self,game)
            game.score = game.score + 100
            if game.score > game.high_score then -- change high score if score is higher than it
                game.high_score = game.score
            end
            saveGame(game.score)
            sfx:playFX("enemy_explosion")
            table.remove(enemies,enemy_num)
                enemy_num = enemy_num - 1
                if enemy_num == 0 then
                    enemy_num = 10 * game.level
                end
        end
    }
end
return Enemy