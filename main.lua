require "Target"
require "MoveTarget"
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
  windowWidth = love.graphics.getWidth(),
  windowHeight = love.graphics.getHeight(),
  scores = 0,
  bonusTime = 0.25,
}
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

local function deleteTarget(pos)
  game.targets[pos], game.targets[#game.targets] = game.targets[#game.targets], game.targets[pos]
  table.remove(game.targets, #game.targets)
end

local function penetration(pos)
  if game.targets[pos].isActive == 1 then
    game.gameTime = game.gameTime + game.bonusTime * 1.5
    game.scores = game.scores + 20
  else
    game.gameTime = game.gameTime + game.bonusTime
    game.scores = game.scores + 10
  end
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
          deleteTarget(i)
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
    if game.targets[i] ~= nil and game.targets[i].isActive == 1 then
      game.targets[i].x = game.targets[i].x + game.SPEED * dt
      game.targets[i].y = game.targets[i].y - game.SPEED * dt * (1 - math.cos((1 - game.targets[i].liveTime * math.pi)/2))
    end

    if game.targets[i] ~= nil and game.targets[i]:isTimeToDie(dt) then
      deleteTarget(i)
    end

    if game.targets[i] ~= nil and love.mouse.isDown(1) and game.targets[i]:isCursorOnTarget(i) then
      --shrapnelShoot()
      penetration(i)
      deleteTarget(i) 
    end
  end
end

function love.draw()
  for i = 1, #game.targets do
    game.targets[i]:draw()
  end
  love.graphics.print("Your score = " .. tostring(game.scores))
  love.graphics.print("Time to end = " .. tostring(game.gameTime), 1, 15)
end
