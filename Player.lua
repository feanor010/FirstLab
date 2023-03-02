Player = {
    shootType = "Default",
    shrapnelTime = 0
    }

function Player:new()
    local obj = {}
    self.__index = self
    setmetatable(obj, self)
    return obj
end

function Player:defaultBonus()
    game.gameTime = game.gameTime + game.bonusTime
    game.scores = game.scores + 10

    
end

function Player : moveTypeBonus()
    game.gameTime = game.gameTime + game.bonusTime * 1.5
    game.scores = game.scores + 20
end

function  Player:defaultShoot(pos)
    if game.targets[pos] ~= nil and love.mouse.isDown(1) and game.targets[pos]:isCursorOnTarget(pos) then
        if (game.targets[pos].type == "Bonus") then
            self.shootType = "Shrapnel"
            self.shrapnelTime = 3
        end
        DeleteTarget(pos)
        
        if (game.targets[pos] ~= nil and game.targets[pos].moveType ~= nil) then
            self:defaultBonus()
        else 
            self:moveTypeBonus()
        end
    end
    
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
    for i = 1, game.cartridges do
        local coords = { x = 0, y = 0 }
        while Point_dist(coords.x, coords.y, love.mouse.getX(), love.mouse.getY())  >= game.spread do
            coords.x = math.random(love.mouse.getX() - game.spread, love.mouse.getX() + game.spread)
            coords.y = math.random(love.mouse.getY() - game.spread, love.mouse.getY() + game.spread)
        end 
        if game.targets[pos] ~= nil and love.mouse.isDown(1) and isShrapnelEnter(coords.x, coords.y, i) then
            if (game.targets[pos].type == "Bonus") then
                self.shootType = "Shrapnel"
                self.shrapnelTime = 3
            end
                DeleteTarget(pos)
        end
    end
end

function Player:shoot (pos, dt) 
    if self.shrapnelTime > 0 then
        self.shrapnelTime = self.shrapnelTime - dt
    else
        self.shootType = "Default"
    end
    if self.shootType == "Default" then
        self:defaultShoot(pos)
        love.mouse.setVisible(true)
    else
        self:shrapnelShoot(pos)
        love.mouse.setVisible(false)
    end
end
