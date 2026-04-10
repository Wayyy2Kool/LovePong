-- PONG Project

function love.load()
    game_height = 600
    game_width = 800   
    
    player = {}
        player.x = game_width/12
        player.y = game_height/2
        player.speed = 5
        player.width = 10
        player.height = 65

    com = {}
        com.x = 730
        com.y = 300
        com.speed = 4
        com.width = 10
        com.height = 65
    score = {}
        score.player = 0
        score.com = 0
    
    paddle = {}
        paddle.w = 10
        paddle.h = 65
    
    ball = {}
        ball.x = 400
        ball.y = 300
        ball.vx = 100
        ball.vy = 100
        ball.speed = 25
        ball.width = 10
        ball.height = 10

end

function love.update(dt)
    --TEMP SUPER ADVANCED COM CODE (TOO COMPLICATED FOR ANYONE TO UNDERSTAND)
    com.y = ball.y - (com.height/2)

    if com.y > (game_height - paddle.h) then
        com.y = (game_height - paddle.h)
    end

    --player controller
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
    end

    --player bounds
    if player.y < 0 then
        player.y = 0
    end

    if player.y > 535 then
        player.y = 535
    end    

    --ball math???
    ball.x = ball.x + (ball.vx * dt)
    ball.y = ball.y + (ball.vy * dt)
    
    --bounds
    if ball.y <= 0 and ball.vy < 0 then
        ball.y = 0
        ball.vy = -ball.vy 
    elseif ball.y >= (game_height - ball.height) and ball.vy > 0 then
        ball.y = (game_height - ball.height)
        ball.vy = -ball.vy
    end

    --com collision
    if ball.x < com.x + com.width and -- Checks if the ball is to the left of com
        ball.x + ball.width > com.x and -- Checks if the com is left of the ball (or ball right of com)
        ball.y < com.y + com.height and -- Checks if the ball is above the com
        ball.y + ball.height > com.y then -- Checks if the com is above the ball (or ball below com)
        ball.vx = -ball.vx
    end
end

function love.draw()
    --draw player
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    --draw computer
    love.graphics.rectangle("fill", com.x, com.y, com.width, com.height)

    --draw ball
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)

    --draw scores
    love.graphics.print(score.player, 200, 60, 0, 2, 2)
    love.graphics.print(score.com, 600, 60, 0, 2, 2)
end