require "Target"
MoveTarget= {
    moveType = 0
}
setmetatable(MoveTarget ,{__index = Target}) 
function MoveTarget:new()
    local obj = Target:new()
    obj.moveType = math.random(1,3)
    obj.type = "Move" 
    self.__index = self;
    setmetatable(obj, self)
    return obj
end

function MoveTarget:isAtTheBorder()
    if self.x >= game.WINDOWWIDTH - game.maxSize
    or self.x <= 0 
    or self.y >= game.WINDOWHEIGHT - game.maxSize
    or self.y <= 0
    then
        return true
    else
        return false
    end 
    
end

function MoveTarget:move(dt)

    if self:isAtTheBorder() == false then
        if (self.moveType == 1) then
            self:easelnSine(dt)
        elseif (self.moveType == 2 ) then
            self:easeInBack(dt)
        elseif (self.moveType == 3 ) then
            self:easeInOutElastic(dt)
        end
    end
end

function MoveTarget:easelnSine(dt)
    self.x = self.x + game.SPEED * dt
    self.y = self.y - game.SPEED * dt * (1 - math.cos((1 - self.liveTime * math.pi)/2))
end

function MoveTarget:easeInBack(dt)
    local abciss = 1 - self.liveTime
    local C1 = 1.70158
    local C3 = C1 + 1

    self.x = self.x + game.SPEED * dt
    self.y = self.y - game.SPEED * dt * (C3*abciss*abciss*abciss - C1 * abciss * abciss)
end

function MoveTarget:easeInOutElastic(dt)
    local abciss = 1 - self.liveTime
    local C5 = (2 * math.pi) / 4.5

    self.x = self.x + game.SPEED * dt

    if (abciss < 0.5 ) then
        self.y = self.y - game.SPEED * dt * (math.pow(2, 20 * abciss - 10) * math.sin ((20 * abciss - 11.125) * C5)) / 2
    else
        self.y = self.y - game.SPEED * dt * (math.pow(2, -20 * abciss - 10) * math.sin ((20 * abciss - 11.125) * C5)) / 2 + 1 
    end
end
