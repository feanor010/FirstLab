math.randomseed(os.clock())
gameTime = 30
minSize = 30
spawnKD = 1
targets = {}
liveTime = 5000
maxSize = 50
windowWidth = love.graphics.getWidth()
windowHeight = love.graphics.getHeight()

local Target = {
  x,
  y,
  width, 
  height,
  
}
--usu
function Target:new ()
  self.x = math.random(0,windowWidth)
  self.y = math.random(0,windowHeight)
  self.width = math.random(minSize,maxSize)
  self.height = math.random(minSize,maxSize)
  local obj = {}
  self.__index = self
  setmetatable(obj, self)
  return  obj
end
function Target:draw()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
function Target:update()
  self.x = self.x + 1
end

function love.update(dt)
  
  spawnKD = spawnKD - dt
  if spawnKD <=0 then
    table.insert(targets, Target:new())
    spawnKD = 1
  end
  for i  = 1, #targets do
    targets[i]:update(dt)
  end
  gameTime = gameTime-dt
  if gameTime <=0 then
    os.exit()
  end
end
function love.draw()
  for i = 1, #targets do
    targets[i]:draw()
  end
end