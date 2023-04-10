require("MoveType")
local bezie = require("Bezier_Movement")
MoveTarget = {
    SPEED = 200,
    moveType = MoveType.bez, -- использовать MoveType (enum)
    abciss = 0,
    directionX = 0,
    directionY = 0,
    time = 0,
}
setmetatable(MoveTarget, { __index = Target })
function MoveTarget:new()
    local obj = Target:new()
    -- obj.moveType = math.random(1, #MoveType)
    obj.randPoints = { p2 = { x = 0, y = 0 }, p3 = { x = 0, y = 0 }, p4 = { x = 0, y = 0 } }
    obj.moveType = MoveType.bez
    if obj.moveType == MoveType.bez then
        obj.randPoints.p2 = { x = math.random(0, game.WINDOWWIDTH), y = math.random(0, game.WINDOWHEIGHT) }
        obj.randPoints.p3 = { x = math.random(0, game.WINDOWWIDTH), y = math.random(0, game.WINDOWHEIGHT) }
        obj.randPoints.p4 = { x = math.random(0, game.WINDOWWIDTH), y = math.random(0, game.WINDOWHEIGHT) }
    end
    obj.type = "Move"
    obj.abciss = 0
    obj.time = 0
    obj.directionX = math.random(0, 1)
    if obj.directionX == 0 then
        obj.directionX = -1
    end
    obj.directionY = math.random(0, 1)
    if obj.directionY == 0 then
        obj.directionY = -1
    end
    self.__index = self;
    setmetatable(obj, self)
    return obj
end

function MoveTarget:move(dt)
    if self.moveType == MoveType.easelnSine then
        self:easelnSine(dt)
    elseif self.moveType == MoveType.easeInBack then
        self:easeInBack(dt)
    elseif self.moveType == MoveType.easeInOutElastic then
        self:easeInOutElastic(dt)
    elseif self.moveType == MoveType.bez then
        self:bez(dt)
    end

    self:repulsion()
end

function MoveTarget:repulsion()
    if (self.x <= 0 or self.x + self.width >= love.graphics.getPixelWidth()) then
        self.directionX = self.directionX * -1
    elseif (self.y <= 0 or self.y + self.height >= love.graphics.getPixelHeight()) then
        self.directionY = self.directionY * -1
    end
end

function MoveTarget:bez(dt)
    self.abciss = self.abciss + 1 / 1000 * dt
    self.x = bezie.cubic_bezier({ x = self.x, y = self.y },
            { x = self.randPoints.p2.x, y = self.randPoints.p2.y },
            { x = self.randPoints.p3.x, y = self.randPoints.p3.y },
            { x = self.randPoints.p4.x, y = self.randPoints.p4.y },
            self.abciss).x
    self.y = bezie.cubic_bezier({ x = self.x, y = self.y },
            { x = self.randPoints.p2.x, y = self.randPoints.p2.y },
            { x = self.randPoints.p3.x, y = self.randPoints.p3.y },
            { x = self.randPoints.p4.x, y = self.randPoints.p4.y },
            self.abciss).y
end

---Применить функцию плавности "синус"
---@param dt any
function MoveTarget:easelnSine(dt)
    self.abciss = self.abciss + dt
    self.x = self.x + (self.SPEED * dt) * self.directionX
    self.y = self.y - (self.SPEED * dt * (1 - math.cos((self.abciss * math.pi) / 2))) * self.directionY
end

function MoveTarget:easeInBack(dt)
    self.abciss = 0
    self.abciss = self.abciss + dt
    local C1 = 1.70158
    local C3 = C1 + 1

    self.x = self.x + self.SPEED * dt * self.directionX
    self.y = self.y -
        self.SPEED * dt * (C3 * self.abciss * self.abciss * self.abciss - C1 * self.abciss * self.abciss) *
        self.directionY
end

function MoveTarget:easeInOutElastic(dt)
    self.abciss = self.abciss + dt
    local C5 = (2 * math.pi) / 4.5

    self.x = self.x + self.SPEED * dt * self.directionX

    if (self.abciss < 0.5) then
        self.y = self.y -
            self.SPEED * dt * (math.pow(2, 20 * self.abciss - 10) * math.sin((20 * self.abciss - 11.125) * C5)) / 2 *
            self.directionX
    else
        self.y = self.y -
            self.SPEED * dt * (math.pow(2, -20 * self.abciss - 10) * math.sin((20 * self.abciss - 11.125) * C5)) / 2 +
            1 * self.directionY
    end
end
