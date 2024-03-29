require "Target"
require "MoveTarget"
require "Player"
require "BonusTarget"
require "FakeTarget"
require "Bullet"
require "Service"
game = {
    bullets = {},
    gameTime = 3000,
    SPAWNKD = 0.5,
    targets = {},
    WINDOWWIDTH = love.graphics.getWidth(),
    WINDOWHEIGHT = love.graphics.getHeight(),
    bonusTime = 0.5,
}
local player = Player:new()

local function stopGame(dt)
    game.gameTime = game.gameTime - dt

    if game.gameTime <= 0 then
        os.exit()
    end
end

---Добавляет мишень
local function addTarget()
    local targetType = math.random(1, 100)

    if (targetType < 30) then
        table.insert(game.targets, Target:new())
    elseif (targetType < 70) then
        table.insert(game.targets, MoveTarget:new())
    elseif (targetType < 80) then
        table.insert(game.targets, FakeTarget:new())
    else
        table.insert(game.targets, BonusTarget:new())
    end
    game.SPAWNKD = 0.5
end

local function gameUpdate(dt)
    player:combTime(dt)
    stopGame(dt)

    game.SPAWNKD = game.SPAWNKD - dt

    if game.SPAWNKD <= 0 then
        addTarget()
    end

    for i = 1, #game.targets do
        if game.targets[i] ~= nil and game.targets[i].moveType ~= nil then
            game.targets[i]:move(dt)
        end
        if game.targets[i] ~= nil and IsTimeToDie(dt, game.targets[i]) then
            DeleteEl(i, game.targets)
        end
    end
    player:shoot(dt)
    for i = 1, #game.bullets do
        if game.bullets[i] ~= nil and IsTimeToDie(dt, game.bullets[i]) then
            DeleteEl(i, game.bullets)
        end
    end
end

local function gameDraw()
    if player.shootType ~= "Default" then
        love.graphics.circle("line", love.mouse.getX(), love.mouse.getY(), player.SPREAD)
    end
    for i = 1, #game.targets do
        if (game.targets[i].type == "Bonus") then
            game.targets[i]:drawBonus()
        elseif (game.targets[i].type == "Fake") then
            game.targets[i]:drawFake()
        else
            game.targets[i]:draw()
        end
    end
    for i = 1, #game.bullets do
        if (game.bullets[i] ~= nil) then
            game.bullets[i]:bulletDraw()
        end
    end


    love.graphics.setColor(256, 256, 256)
    love.graphics.print("Your score = " .. tostring(player.scores))
    love.graphics.print("Time to end = " .. tostring(game.gameTime), 1, 15)
    love.graphics.print("Shoot Type =  " .. player.shootType, 1, 30)
    love.graphics.print("Combo Bonus =  " .. tostring(player.playerCombo), 1, 45)
    love.graphics.print("Combo Bonus =  " .. tostring(player.mousewasUp), 1, 60)
end

return {
    gameDraw = gameDraw,
    gameUpdate = gameUpdate
}
