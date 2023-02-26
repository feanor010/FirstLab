math.randomseed(os.clock())
speed = 200
gameTime = 30
minSize = 30
spawnKD = 0.5
targets = {}
maxSize = 50
windowWidth = love.graphics.getWidth()
windowHeight = love.graphics.getHeight()
scores = 0
bonusTime = spawnKD / 2
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

function Target:new ()
  local obj = {width = math.random(minSize,maxSize),height = math.random(minSize,maxSize), x = math.random(0,windowWidth - 50),y = math.random(0,windowHeight - 50), liveTime = math.random(1,3), isActive = math.random(0,1), direction = math.random(1,2)}
  self.__index = self
  setmetatable(obj, self)
  return  obj
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

function Target:IsTimeToDie(dt)
  self.liveTime = self.liveTime - dt
  
  if self.liveTime <= 0 then
    return true
  end

end

function Target:IsCursorOnTarget(pos)
  
  if (love.mouse.getX() >= targets[pos].x and love.mouse.getX() <= (targets[pos].x + targets[pos].width) and love.mouse.getY() >= targets[pos].y and love.mouse.getY() <= (targets[pos].y + targets[pos].height)) then
    return true
  end
end


function StopGame(dt)
  gameTime = gameTime - dt
  
  if gameTime <= 0 then
    os.exit()
  end
end

function DeleteTarget(pos)
  targets[pos], targets[#targets] = targets[#targets], targets[pos]
  table.remove(targets,#targets)
end

function Penetration (pos)
  if targets[pos].isActive == 1 then
    gameTime = gameTime + bonusTime * 1.5
    scores = scores + 20
  else
    gameTime = gameTime + bonusTime
    scores = scores + 10
  end
  DeleteTarget(pos)
end

function love.update(dt)
  StopGame(dt)
  spawnKD = spawnKD - dt
  
  if spawnKD <=0 then
    table.insert(targets, Target:new())
    spawnKD = 0.5
  end
  
  for i  = 1, #targets do 
    if targets[i]~= nil and targets[i].isActive == 1 then
      if targets[i].direction == 2 then
        targets[i].x = targets[i].x + dt * speed
      else 
        targets[i].x = targets[i].x - dt * speed
      end
    end    
    
    if targets[i]~= nil and targets[i]:IsTimeToDie(dt) then
      DeleteTarget(i)
    end
    
    if targets[i] ~= nil and love.mouse.isDown(1) and targets[i]:IsCursorOnTarget(i) then
      Penetration(i)
    end 
  end
    
    
end

function love.draw()
  for i = 1, #targets do
    targets[i]:draw()
  end
  love.graphics.print("Your score = " ..tostring(scores))
  love.graphics.print("Time to end = "..tostring(gameTime), 1,15)
end