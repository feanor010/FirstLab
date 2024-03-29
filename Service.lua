function IsTimeToDie(dt, el)
    el.liveTime = el.liveTime - dt

    if el.liveTime <= 0 then
        return true
    else
        return false
    end
end

---Удаляет элемент
---@param pos integer
---@param arr table
function DeleteEl(pos, arr)
    if (arr ~= nil) then
        arr[pos], arr[#arr] = arr[#arr], arr[pos]
        table.remove(arr, #arr)
    end
end

---Проверяет находится ли курсор на цели
---@param x number
---@param y number
---@param target table
---@return boolean
function IsOnTheTarget(x, y, target)
    if target ~= nil and
        x >= target.x
        and x <= (target.x + target.width)
        and y >= target.y
        and y <= (target.y + target.height) then
        
        return true
    else
        return false
    end
end
