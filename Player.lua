Player = {
    shootType = ""
    }

function Player:new()
    local obj = {}
    self.__index = self
    setmetatable(obj, self)
    return obj
end

function Player:defaultBonus()
    game.gameTime = game.gameTime + game.bonusTime * 1.5
    game.scores = game.scores + 20
end

function Player : moveTypeBonus()
    game.gameTime = game.gameTime + game.bonusTime
    game.scores = game.scores + 10
end

function  Player:defaultShoot(pos)
    if game.targets[pos] ~= nil and love.mouse.isDown(1) and game.targets[pos]:isCursorOnTarget(pos) then
        DeleteTarget(pos)
        if (game.targets[pos] ~= nil and game.targets[pos].moveType ~= nil) then
            self:defaultBonus()
        else 
            self:moveTypeBonus()
        end
    end
    
end

function Player:shoot (pos) 
    if self.shootType == "Default" then
        self:defaultShoot(pos)
    end
end
