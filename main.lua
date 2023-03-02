require "Target"
require "MoveTarget"
require "Player"
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
local function isShrapnelEnter(x, y, pos)
  if 
    x >= game.targets[pos].x 
    and x <= (game.targets[pos].x + game.targets[pos].width) 
    and y >= game.targets[pos].y 
    and y <= (game.targets[pos].y + game.targets[pos].height) 
  then
    return true
  end
end

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

local function point_dist(a, b, a1, b1) 
  return math.sqrt((a1-a)^2+(b1-b)^2) 
end

local function shrapnelShoot()
  for i = 1, game.cartridges do
    local coords = { x = 0, y = 0 }
    while point_dist(coords.x, coords.y, love.mouse.getX(), love.mouse.getY())  >= game.spread do
      coords.x = math.random(love.mouse.getX() - game.spread, love.mouse.getX() + game.spread)
      coords.y = math.random(love.mouse.getY() - game.spread, love.mouse.getY() + game.spread)
    end 
    for i = 1, #game.targets do
      if game.targets[i] ~= nil then
        if isShrapnelEnter(coords.x, coords.y, i) then
          DeleteTarget(i)
        end
      end
    end
  end
end

local function addTarget()

  local targetType = math.random(1,2)
  
  if (targetType == 1) then
    table.insert(game.targets, Target:new())  
  else
    table.insert(game.targets, MoveTarget:new())
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
    
    player.shootType = "Default"

    player:shoot(i)

  end
end

function love.draw()
  for i = 1, #game.targets do
    game.targets[i]:draw()
  end
  love.graphics.print("Your score = " .. tostring(game.scores))
  love.graphics.print("Time to end = " .. tostring(game.gameTime), 1, 15)
end
