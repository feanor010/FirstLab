Bullet = {
    x = 0,
    y = 0,
    liveTime = 0,
    width = 0,
    height = 0
}

---@param coordX number
---@param coordY number
---@return table
function Bullet:new(coordX, coordY)
    local obj = {
        x = coordX,
        y = coordY,
        liveTime = 1,
        width = 5,
        height = 5
    }
    self.__index = self
    setmetatable(obj, self)
    return obj
end

function Bullet:bulletDraw()
    love.graphics.setColor(256, 256, 256)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end


