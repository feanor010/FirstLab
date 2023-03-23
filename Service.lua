function isTimeToDie(dt, el)
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
