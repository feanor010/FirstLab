math.randomseed(os.clock())

local game = {
  cartridges = 20,
  spread = 30,
  SPEED = 200,
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

local Target = {
  isActive,
  currentWidth = 0,
  currentHeight = 0,
  x,
  y,
  width,
  height,
  liveTime = 2,
  direction
}

function Target:new()
  local obj = {
    width = math.random(game.minSize, game.maxSize),
    height = math.random(game.minSize, game.maxSize),
    x = math.random(0, game.windowWidth - 50),
    y = math.random(0, game.windowHeight - 50),
    liveTime = math.random(1, 3),
    isActive = math.random(0, 1),
    direction = math.random(1, 2)
  }
  self.__index = self
  setmetatable(obj, self)
  return obj
end

function Target:draw()
  if self.currentWidth < self.width then
    self.currentWidth = self.currentWidth + 7
  end
  if self.currentHeight < self.height then
    self.currentHeight = self.currentHeight + 7
  end
  love.graphics.rectangle('fill', self.x, self.y, self.currentWidth, self.currentHeight)
end

function Target:isTimeToDie(dt)
  self.liveTime = self.liveTime - dt

  if self.liveTime <= 0 then
    return true
  end
end

function Target:isCursorOnTarget(pos)
  if
      love.mouse.getX() >= game.targets[pos].x
      and love.mouse.getX() <= (game.targets[pos].x + game.targets[pos].width)
      and love.mouse.getY() >= game.targets[pos].y
      and love.mouse.getY() <= (game.targets[pos].y + game.targets[pos].height)
  then
    return true
  end
end

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
    while point_dist(--ДОПИСАТЬ!!!!!!!!!!!!!!!!!!!!!
  ) >= game.spread do
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
function love.update(dt)
  stopGame(dt)
  game.spawnKD = game.spawnKD - dt
  if game.spawnKD <= 0 then
    table.insert(game.targets, Target:new())
    game.spawnKD = 0.5
  end

  for i = 1, #game.targets do
    if game.targets[i] ~= nil and game.targets[i].isActive == 1 then
      if game.targets[i].direction == 2 then
        game.targets[i].x = game.targets[i].x + dt * game.SPEED
      else
        game.targets[i].x = game.targets[i].x - dt * game.SPEED
      end
    end

    if game.targets[i] ~= nil and game.targets[i]:isTimeToDie(dt) then
      deleteTarget(i)
    end

    if game.targets[i] ~= nil and love.mouse.isDown(1) then
      shrapnelShoot()
      --[[ penetration(i)
      deleteTarget(i) ]]
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
