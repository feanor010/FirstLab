FakeTarget = {
}
setmetatable(FakeTarget ,{__index = MoveTarget})
function FakeTarget:new()
    local obj = MoveTarget:new()
    self.__index = self;
    obj.type = "Fake"
    setmetatable(obj, self)
    return obj
end 

function  FakeTarget:drawFake()
    love.graphics.setColor(255, 0, 0, 100)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end