---@param a number
---@param b number
---@param t number
---@return number
local function lerp(a, b, t)
    return a * (1 - t) + b * t
end

---@param a table
---@param b table
---@param t number
---@return table
local function lerp2d(a, b, t)
    return {
        x = lerp(a.x, b.x, t),
        y = lerp(a.y, b.y, t),
    }
end

---comment
---@param p1 table{x,y}
---@param t number
---@return table
local function cubic_bezier(p1, p2, p3, p4, t)
    local a = lerp2d(p1, p2, t)
    local b = lerp2d(p2, p3, t)
    local c = lerp2d(p3, p4, t)
    local aa = lerp2d(a, b, t)
    local bb = lerp2d(b, c, t)
    local aaa = lerp2d(aa, bb, t)
    return aaa
end


return {
    lerp = lerp,
    lerp2d = lerp2d,
    cubic_bezier = cubic_bezier
}
