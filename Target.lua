Target = {
    currentWidth = 0,
    currentHeight = 0,
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    liveTime = 2,
    direction = 0
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

function Target:easelnSine(dt)

end