
local game = require "Game"
math.randomseed(os.clock())
function love.update(dt)
  game.gameUpdate(dt)
end

function love.draw()
  game.gameDraw()
end
