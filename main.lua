-- PONG Project

--  TO DO LIST:
--  - Improve the com player code
--  - Improve the ball physics (angle and speed velocity)
--  - Add charge mechanic

function love.load()
    game_height = 600
    game_width = 800   

    paddle = {}
        paddle.w = 10
        paddle.h = 65    
    
    player = {}
        player.x = 60
        player.y = (game_height/2) - (paddle.h/2)
        player.speed = 0
        player.vi = 0.5
        player.vd = 0.25
        player.width = 10
        player.height = 65

    com = {}
        com.x = 730
        com.y = (game_height/2) - (paddle.h/2)
        com.speed = 10
        com.width = 10
        com.height = 65

    score = {}
        score.player = 0
        score.com = 0
    
    ball = {}
        ball.x = game_width/2
        ball.y = game_height/2
        ball.vx = 100
        ball.vy = 100
        ball.width = 10
        ball.height = 10

    --AABB Collision Function
    function isCollide(a, b)
        return a.x < b.x + b.width and
               a.x + a.width > b.x  and
               a.y < b.y + b.height and
               a.y + a.height > b.y
    end
end

function love.update(dt)
    --Com code
    --Need to fix 'speed match' bug
    if math.min(com.y + paddle.h / 2, ball.y) then
        com.y = math.min(com.y + com.speed, ball.y)
    end

    if math.min(com.y + paddle.h / 2, ball.y) then
        com.y = math.max(com.y - com.speed, ball.y)
    end


    --player controller
    if love.keyboard.isDown("up") then
        if player.speed > 0 then
            player.speed = 0
        end
        player.speed = player.speed - player.vi
        if player.speed < -5 then
            player.speed = -5
        end
    else
        if love.keyboard.isDown("down") then
            if player.speed < 0 then
                player.speed = 0
            end
        player.speed = player.speed + player.vi
            if player.speed > 5 then
                player.speed = 5
            end
        else
            if player.speed > 0 then
                player.speed = player.speed - player.vd
                if player.speed < 0 then
                    player.speed = 0
                end
            end

            if player.speed < 0 then
                player.speed = player.speed + player.vd
                if player.speed > 0 then
                    player.speed = 0
                end
            end
        end        
    end

    player.y = player.y + player.speed

    --player bounds
    if player.y < 0 then
        player.y = 0
    end

    if player.y > (game_height - paddle.h) then
        player.y = (game_height - paddle.h)
    end

    --com bounds
    if com.y < 0 then
        com.y = 0
    end

    if com.y > (game_height - paddle.h) then
        com.y = (game_height - paddle.h)
    end

    --ball math
    ball.x = ball.x + (ball.vx * dt)
    ball.y = ball.y + (ball.vy * dt)
    
    --ball bounds
    if ball.y <= 0 and ball.vy < 0 then
        ball.y = 0
        ball.vy = -ball.vy 
    elseif ball.y >= (game_height - ball.height) and ball.vy > 0 then
        ball.y = (game_height - ball.height)
        ball.vy = -ball.vy
    end


    --Fix top speed boundary break
    --com collision
    if isCollide(ball, com) then
        ball.x = ball.x - 1
        ball.vx = ball.vx + 50
        ball.vx = -ball.vx
    end

    --player collision
    if isCollide(ball, player) then
        ball.x = ball.x + 1
        ball.vx = ball.vx - 50
        ball.vx = -ball.vx
    end

    --score and reset system
    if ball.x < 0 then
        ball.x = game_width/2
        ball.y = game_height/2
        ball.vx = 100
        ball.vy = 100
        score.com = score.com + 1
    elseif ball.x > game_width then
        ball.x = game_width/2
        ball.y = game_height/2
        ball.vx = 100
        ball.vy = 100
        score.player = score.player + 1       
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

    --TEMP draw player.speed
    love.graphics.print(ball.vx, 20, 20, 0, 1, 1)
end