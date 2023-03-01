require "Target"
MoveTarget= {
    moveType = 0
}
setmetatable(MoveTarget ,{__index = Target}) 
function MoveTarget:new()

    local obj= {moveType = math.random}
    
    self.__index = self; return obj
end
