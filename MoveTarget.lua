MoveTarget= {
    SPEED = 100,
    moveType = 0,
    abciss = 0,
    directionX = 0,
    directionY = 0
}
setmetatable(MoveTarget ,{__index = Target}) 
function MoveTarget:new()
    local obj = Target:new()
    obj.moveType = math.random(1,3)
    obj.type = "Move" 
    obj.abciss = 0
    obj.directionX = math.random(0,1)
    if obj.directionX == 0 then
        obj.directionX = -1
    end
    obj.directionY = math.random(0,1)
    if obj.directionY == 0 then
        obj.directionY = -1
    end
    self.__index = self;
    setmetatable(obj, self)
    return obj
end

function MoveTarget:move(dt)
    if (self.moveType == 1) then
        self:easelnSine(dt)
    elseif (self.moveType == 2 ) then
        self:easeInBack(dt)
    elseif (self.moveType == 3 ) then
        self:easeInOutElastic(dt)
    end
end

function MoveTarget:easelnSine(dt)
    self.abciss = self.abciss + dt
    self.x = self.x + (self.SPEED * dt) * self.directionX
    self.y = self.y - (self.SPEED * dt * (1 - math.cos((self.abciss * math.pi)/2))) *self.directionY
end

function MoveTarget:easeInBack(dt)
    self.abciss = 0
    self.abciss = self.abciss + dt
    local C1 = 1.70158
    local C3 = C1 + 1

    self.x = self.x + self.SPEED * dt * self.directionX
    self.y = self.y - self.SPEED * dt * (C3*self.abciss*self.abciss*self.abciss - C1 * self.abciss * self.abciss) * self.directionY
end

function MoveTarget:easeInOutElastic(dt)
    self.abciss = self.abciss + dt
    local C5 = (2 * math.pi) / 4.5

    self.x = self.x + self.SPEED * dt

    if (self.abciss < 0.5 ) then
        self.y = self.y - self.SPEED * dt * (math.pow(2, 20 * self.abciss - 10) * math.sin ((20 * self.abciss - 11.125) * C5)) / 2 * self.directionX
    else
        self.y = self.y - self.SPEED * dt * (math.pow(2, -20 * self.abciss - 10) * math.sin ((20 * self.abciss - 11.125) * C5)) / 2 + 1  * self.directionY
    end
end
