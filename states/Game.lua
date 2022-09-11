---@diagnostic disable: lowercase-global
local Text = require "components/Text"
local Enemy = require "objects/Enemy"

function Game(save_data,sfx)
    return {
        level = 1,
        state = { -- will store game state
            menu = true,
            paused = false,
            running = false,
            ended = false
        },
        score = 0, -- set initial score on game start
        high_score = save_data.high_score , -- saved high score
        screen_text = {},
        game_over_showing = false,

        -- will allow to change game state
        changeGameState = function (self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"

            if self.state.ended then
                self:gameOver()
            end
        end,

        gameOver = function (self)
            -- thanks to our cusom Text component, this will fade in/out
            self.screen_text = {Text(
                "GAME OVER",
                0,
                love.graphics.getHeight() * 0.4,
                "h1",
                true,
                true,
                love.graphics.getWidth(),
                "center"
            )}

            self.game_over_showing = true
        end,

        draw = function (self, faded)

            local opacity = 1 -- set opacity to 1
            
            if faded then
                Text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
            end


            for index, text in pairs(self.screen_text) do
                if self.game_over_showing then
                    -- do this until return false
                    self.game_over_showing = text:draw(self.screen_text, index)

                    if not self.game_over_showing then
                        self:changeGameState("menu")
                    end
                else
                    text:draw(self.screen_text, index)
                end
            end

             -- Text that should always be on screen when in game state
             Text( -- show user score
             "SCORE: " .. self.score,
             -20,
             10,
             "h4",
             false,
             false,
             love.graphics.getWidth(),
             "right",
              opacity or 0.6 -- if faded, use provided opacity, otherwise 0.6
         ):draw()

         Text( -- show user high score
             "HIGH SCORE: " .. self.high_score,
             0,
             10,
             "h5",
             false,
             false,
             love.graphics.getWidth(),
             "center",
              opacity or 0.5
         ):draw()


        end,

        startNewGame = function (self,player)
            if player.lives <= 0 then
                self:changeGameState("ended")
            else
                self:changeGameState("running")
            end
            enemies = {}

            self.screen_text = {Text(
                "Level " .. self.level,
                0,
                love.graphics.getHeight() * 0.25,
                "h1",
                true,
                true,
                love.graphics.getWidth(),
                "center"
            )}
            
            for i = 1, enemy_num do
                local as_x = math.floor(math.random(love.graphics.getHeight()))
                table.insert(enemies, i, Enemy(as_x, -100, self.level,sfx))
            end    
        end,

    }
end

return Game