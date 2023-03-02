require "Target"
require "MoveTarget"
require "Player"
require "BonusTarget"
math.randomseed(os.clock())
game = {
  cartridges = 20,
  spread = 30,
  SPEED = 100,
  gameTime = 30,
  minSize = 30,
  spawnKD = 0.5,
  targets = {},
  maxSize = 50,
  WINDOWWIDTH = love.graphics.getWidth(),
  WINDOWHEIGHT = love.graphics.getHeight(),
  scores = 0,
  bonusTime = 0.25,
}

player = Player:new()

local function stopGame(dt)
  game.gameTime = game.gameTime - dt

  if game.gameTime <= 0 then
    os.exit()
  end
end

function DeleteTarget(pos)
  game.targets[pos], game.targets[#game.targets] = game.targets[#game.targets], game.targets[pos]
  table.remove(game.targets, #game.targets)
end

 function Point_dist(a, b, a1, b1) 
  return math.sqrt((a1-a)^2+(b1-b)^2) 
end

local function addTarget()

  local targetType = math.random(1,100)
  
  if (targetType <45) then
    table.insert(game.targets, Target:new())  
  elseif (targetType <90) then
    table.insert(game.targets, MoveTarget:new())
  else
    table.insert (game.targets, BonusTarget:new())
  end
  game.spawnKD = 0.5
end
function love.update(dt)
  
  stopGame(dt)
  
  game.spawnKD = game.spawnKD - dt
  
  if game.spawnKD <= 0 then
    addTarget()
  end


  for i = 1, #game.targets do

    if game.targets[i] ~= nil and game.targets[i].moveType~=nil  then
      game.targets[i]:move(dt)
    end

    if game.targets[i] ~= nil and game.targets[i]:isTimeToDie(dt) then
      DeleteTarget(i)
    end
  

    player:shoot(i, dt)

  end
end

function love.draw()
  if player.shootType ~= "Default" then
    love.graphics.circle("line", love.mouse.getX(), love.mouse.getY(), game.spread)
  end
  for i = 1, #game.targets do
    if (game.targets[i].type == "Bonus") then
      game.targets[i]:drawBonus()
    else
      game.targets[i]:draw()
    end
  end
  
  love.graphics.setColor(256, 256, 256)
  love.graphics.print("Your score = " .. tostring(game.scores))
  love.graphics.print("Time to end = " .. tostring(game.gameTime), 1, 15)
  love.graphics.print("Shoot Type =  " .. player.shootType, 1, 30)
  
end
