BonusTarget = {
}
setmetatable(BonusTarget ,{__index = MoveTarget})
function BonusTarget:new()
    local obj = MoveTarget:new()
    self.__index = self;
    obj.type = "Bonus"
    setmetatable(obj, self)
    return obj
end 

function BonusTarget:drawBonus ()
    love.graphics.setColor(0, 128, 0, 100)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end