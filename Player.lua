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

function Player:defaultBonus()
    self.playerCombo = self.playerCombo + 0.1
    self.timeCombo = 2
    game.gameTime = game.gameTime + game.bonusTime
    self.scores = self.scores + 10 * self.playerCombo

    
end

function Player:combTime(dt)
    self.timeCombo = self.timeCombo - dt
    if self.timeCombo <= 0 then
        self.playerCombo = 1
    end
  end

function Player : moveTypeBonus()
    self.timeCombo = 2
    self.playerCombo = self.playerCombo + 0.2
    game.gameTime = game.gameTime + game.bonusTime * 1.5
    self.scores = self.scores + 20 * self.playerCombo
end

function Player : fakeBonus()
    self.playerCombo = 1
    self.timeCombo = 0
    game.gameTime = game.gameTime - game.bonusTime
    self.scores = self.scores - 20
end

function  Player:defaultShoot(pos,dt)
    self.kdAfterStoot = self.kdAfterStoot - dt
    if game.targets[pos] ~= nil and love.mouse.isDown(1) and game.targets[pos]:isCursorOnTarget(pos) and self.mousewasUp == true then
        self.mousewasUp = false
        if (game.targets[pos].type == "Bonus") then
            self.shootType = "Shrapnel"
            self.shrapnelTime = 3
        elseif (game.targets[pos] ~= nil and    game.targets[pos].type == "Move" ) then
            self:moveTypeBonus()
        elseif (game.targets[pos] ~= nil and game.targets[pos].type == "Fake") then
            self:fakeBonus()
        else
            self:defaultBonus()
        end
        self.kdAfterStoot = 0.5
        game.targets[pos]:DeleteTarget(pos)
    elseif (love.mouse.isDown(1) and self.kdAfterStoot <= 0) then
        self.timeCombo = 0
    end
    
end

function Point_dist(a, b, a1, b1) 
    return math.sqrt((a1-a)^2+(b1-b)^2) 
end

local function isShrapnelEnter(x, y, pos)
    if 
        game.targets[pos] ~= nil and
        x >= game.targets[pos].x 
        and x <= (game.targets[pos].x + game.targets[pos].width) 
        and y >= game.targets[pos].y 
        and y <= (game.targets[pos].y + game.targets[pos].height) 
    then
        return true
    end
end

function  Player:shrapnelShoot(pos)
    for i = 1, self.CARTRIGES do
        local coords = { x = 0, y = 0 }
        while Point_dist(coords.x, coords.y, love.mouse.getX(), love.mouse.getY())  >= self.SPREAD do
            coords.x = math.random(love.mouse.getX() - self.SPREAD, love.mouse.getX() + self.SPREAD)
            coords.y = math.random(love.mouse.getY() - self.SPREAD, love.mouse.getY() + self.SPREAD)
        end 
        if game.targets[pos] ~= nil and love.mouse.isDown(1) and isShrapnelEnter(coords.x, coords.y, i) then
            if (game.targets[pos].type == "Bonus") then
                self.shootType = "Shrapnel"
                self.shrapnelTime = 3
            end
                game.targets[pos]:DeleteTarget(pos)
        end
    end
end

function Player:shoot (pos, dt) 
    if love.mouse.isDown(1) == false then
        self.mousewasUp = true 
    end
    if self.shrapnelTime > 0 then
        self.shrapnelTime = self.shrapnelTime - dt
    else
        self.shootType = "Default"
    end
    if self.shootType == "Default" then
        self:defaultShoot(pos,dt)
        love.mouse.setVisible(true)
    else
        self:shrapnelShoot(pos)
        love.mouse.setVisible(false)
    end
end
