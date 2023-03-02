require "Target"
MoveTarget= {
}
setmetatable(MoveTarget ,{__index = Target}) 
function MoveTarget:new()
    local obj = Target:new()
    self.__index = self; 
    return obj
end
