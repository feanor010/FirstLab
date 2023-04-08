---@enum moveTypes
MoveType = {
    easelnSine = 1,
    easeInBack = 2,
    easeInOutElastic = 3,
    bez = 4,
}

local VALUES = {}
for k, v in pairs(MoveType) do
    table.insert(VALUES, v)
end

function MoveType.random()
    return VALUES[math.random(1, #VALUES)]
end
