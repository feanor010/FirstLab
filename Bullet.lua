Bullet = {
    x = 0,
    y = 0,
    liveTime = 0
}

function Bullet:new()
    local obj = {
        liveTime = 1
    }
    self.__index = self
    setmetatable(obj, self)
    return obj
end

function  Bullet:MinusLive(dt)
    self.liveTime = self.liveTime - dt
end