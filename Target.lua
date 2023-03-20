Target = {
    type = "standard",
    MINSIZE = 30,
    MAXSIZE = 50,
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
        width = math.random(self.MINSIZE, self.MAXSIZE),
        height = math.random(self.MINSIZE, self.MAXSIZE),
        x = math.random(0, game.WINDOWWIDTH - 50),
        y = math.random(0, game.WINDOWHEIGHT - 50),
        liveTime = math.random(3, 5),
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
    love.graphics.setColor(256, 256, 256)
    love.graphics.rectangle('fill', self.x, self.y, self.currentWidth, self.currentHeight)
end

function Target:isTimeToDie(dt)
    self.liveTime = self.liveTime - dt

    if self.liveTime <= 0 then
        return true
    end
end

---Удаляет мишень
---@param pos number
function Target:DeleteTarget(pos)
    game.targets[pos], game.targets[#game.targets] = game.targets[#game.targets], game.targets[pos]
    table.remove(game.targets, #game.targets)
end

---Проверяет навелся ли игрок на цель
---@param pos number
---@return boolean
function Target:isCursorOnTarget(pos)
    if
        love.mouse.getX() >= game.targets[pos].x
        and love.mouse.getX() <= (game.targets[pos].x + game.targets[pos].width)
        and love.mouse.getY() >= game.targets[pos].y
        and love.mouse.getY() <= (game.targets[pos].y + game.targets[pos].height)
    then
        return true
    else
        return false
    end
end
