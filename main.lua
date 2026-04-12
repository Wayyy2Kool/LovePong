-- PONG Project

--  TO DO LIST:
--  - Improve the com player code
--  - Improve the ball physics (angle and speed velocity)
--  - Keep improving the wall bounce mechanic

function love.load()
    game_height = 450
    game_width = 450     
    
    love.window.setMode(game_width, game_height)
    love.graphics.setBackgroundColor(0.9, 0.55, 0.7)

    gameFont = love.graphics.newFont("font/gamefont.ttf", 10)

    paddle = {}
        paddle.w = 10
        paddle.h = 65    
    
    player = {}
        player.x = (game_width/16)
        player.y = (game_height/2) - (paddle.h/2)
        player.speed = 0
        player.cap = 7
        player.vi = 0.5
        player.vd = 0.30
        player.width = 10
        player.height = 65

    com = {}
        com.x = (game_width * 15/16) - paddle.w
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

    function shadowDraw(a)
        return 
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
    --Clean this shit up later
    if love.keyboard.isDown("space") then
        player.vd = 1
    end

    if love.keyboard.isDown("up") then
        if player.speed > 0 then
            player.speed = 0
        end
        player.speed = player.speed - player.vi
        if player.speed < -player.cap then
            player.speed = -player.cap
        end
    else
        if love.keyboard.isDown("down") then
            if player.speed < 0 then
                player.speed = 0
            end
        player.speed = player.speed + player.vi
            if player.speed > player.cap then
                player.speed = player.cap
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
        player.cap = player.cap + 0.5
        player.vd = 0.2
        player.speed = -player.speed
    end

    if player.y > (game_height - paddle.h) then
        player.y = (game_height - paddle.h)
        player.cap = player.cap + 0.5
        player.vd = 0.2
        player.speed = -player.speed
    end

    --Friction control cap
    if player.cap > 6 then
        player.vd = 0.25
    end

    --Total player cap
    if player.cap >= 9 then
        player.cap = 9
        player.vd = 0.15
    end
   
    --Anti broken wall bounce
    if player.speed == 0 then
        player.vd = 0.30
        player.cap = 6
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
    love.graphics.setDefaultFilter("nearest", "nearest")

    --ball shadow
    love.graphics.setColor(0,0,0,0.2)
    love.graphics.rectangle("fill", ball.x+3, ball.y+3, ball.width, ball.height)
    love.graphics.rectangle("fill", player.x+3, player.y+3, player.width, player.height)
    love.graphics.rectangle("fill", com.x+3, com.y+3, com.width, com.height)

    --draw ball
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
    
    --draw player
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    --draw computer
    love.graphics.rectangle("fill", com.x, com.y, com.width, com.height)

    --Set font
    love.graphics.setFont(gameFont)
    
    --draw scores
    love.graphics.print(score.player, (112.5 - 10), 40, 0, 3, 3)
    love.graphics.print(score.com, (317.5), 40, 0, 3, 3)

    --TEMP draw player.speed
    love.graphics.print(player.speed, 20, 20, 0, 1, 1)
    --TEMP draw player.vd
    love.graphics.print(player.vd, 20, 50, 0, 1, 1)

    gameFont:setFilter("nearest", "nearest")
end