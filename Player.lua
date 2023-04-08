require "Service"
Player = {
    shootType = "Default",
    SPREAD = 30,
    CARTRIGES = 20,
    shrapnelTime = 0,
    playerCombo = 1,
    scores = 0,
    timeCombo = 0,
    mousewasUp = true,
    kdAfterStoot = 0
}

function Player:new()
    local obj = {}
    self.__index = self
    setmetatable(obj, self)
    return obj
end

---Дает игроку обычный бонус
function Player:defaultBonus()
    self.playerCombo = self.playerCombo + 0.1
    self.timeCombo = 2
    game.gameTime = game.gameTime + game.bonusTime
    self.scores = self.scores + 10 * self.playerCombo
end

---Уменьшает время комбо, а также само комбо
---@param dt any
function Player:combTime(dt)
    self.timeCombo = self.timeCombo - dt
    if self.timeCombo <= 0 then
        self.playerCombo = 1
    end
end

---Дает бонус за зеленую мешень
function Player:moveTypeBonus()
    self.timeCombo = 2
    self.playerCombo = self.playerCombo + 0.2
    game.gameTime = game.gameTime + game.bonusTime * 1.5
    self.scores = self.scores + 20 * self.playerCombo
end

---Снимает очки за красную мешень
function Player:fakeBonus()
    self.playerCombo = 1
    self.timeCombo = 0
    game.gameTime = game.gameTime - game.bonusTime
    self.scores = self.scores - 20
end

---Обычная стрельба
---@param dt any
function Player:defaultShoot(dt)
    for i, targ in ipairs(game.targets) do
        if targ ~= nil and love.mouse.isDown(1) and IsOnTheTarget(love.mouse.getX(), love.mouse.getY(), targ) and self.mousewasUp then
            self.mousewasUp = false
            self:bonus(i)
            self.kdAfterStoot = 0.5
            DeleteEl(i, game.targets)
        elseif (love.mouse.isDown(1) and self.kdAfterStoot <= 0) then
            self.timeCombo = 0
        end
        self.kdAfterStoot = self.kdAfterStoot - dt
    end
    if (love.mouse.isDown(1) and self.mousewasUp == true) then
        table.insert(game.bullets, Bullet:new(love.mouse.getX(), love.mouse.getY()))
        self.mousewasUp = false
    end
end

---Выбирает, какой бонус дать игроку
---@param pos number
function Player:bonus(pos)
    if (game.targets[pos].type == "Bonus") then
        self.shootType = "Shrapnel"
        self.shrapnelTime = self.shrapnelTime + 4
    elseif (game.targets[pos] ~= nil and game.targets[pos].type == "Move") then
        self:moveTypeBonus()
    elseif (game.targets[pos] ~= nil and game.targets[pos].type == "Fake") then
        self:fakeBonus()
    else
        self:defaultBonus()
    end
end

---Вычисляет расстояние между точками
---@param a number
---@param b number
---@param a1 number
---@param b1 number
---@return number
function Point_dist(a, b, a1, b1)
    return math.sqrt((a1 - a) ^ 2 + (b1 - b) ^ 2)
end

function Player:shrapnelShoot()
    if (love.mouse.isDown(1) and self.mousewasUp) then
        self.mousewasUp = false
        for i = 1, self.CARTRIGES do
            local coords = { x = 0, y = 0 }
            repeat
                coords.x = math.random(love.mouse.getX() - self.SPREAD, love.mouse.getX() + self.SPREAD)
                coords.y = math.random(love.mouse.getY() - self.SPREAD, love.mouse.getY() + self.SPREAD)
            until Point_dist(coords.x, coords.y, love.mouse.getX(), love.mouse.getY()) <= self.SPREAD
            table.insert(game.bullets, Bullet:new(coords.x, coords.y))
            for k, v in ipairs(game.targets) do
                if game.targets[k] ~= nil and IsOnTheTarget(coords.x, coords.y, game.targets[k]) then
                    self:bonus(k)
                    DeleteEl(k, game.targets)
                end
            end
        end
    end
end

---Выбор выстрела
---@param dt any
function Player:shoot(dt)
    if love.mouse.isDown(1) == false then
        self.mousewasUp = true
    end
    if self.shrapnelTime > 0 then
        self.shrapnelTime = self.shrapnelTime - dt
    else
        self.shootType = "Default"
    end
    if self.shootType == "Default" then
        self:defaultShoot(dt)
        love.mouse.setVisible(true)
    else
        self:shrapnelShoot()
        love.mouse.setVisible(false)
    end
end
