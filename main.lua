-- PONG Project

--  TO DO LIST:
--  - Improve the com player code
--  - Improve the ball physics (angle and speed velocity)
--  - Keep improving the wall bounce mechanic

function love.load()
    game_height = 500
    game_width = 450     
    
    love.window.setMode(game_width, game_height)
    love.graphics.setBackgroundColor(0.8, 0.45, 0.6)

    gameFont = love.graphics.newFont("font/gamefont.ttf", 10)

    paddle = {}
        paddle.w = 10
        paddle.h = 65    
    
    player = {}
        player.x = (game_width/16)
        player.y = (game_height/2 + 50) - (paddle.h/2)
        player.speed = 0
        player.cap = 5
        player.vi = 0.5
        player.vd = 0.30
        player.width = 10
        player.height = 65

    com = {}
        com.x = (game_width * 15/16) - paddle.w
        com.y = (game_height/2 + 50) - (paddle.h/2)
        com.speed = 0
        com.cap = 5
        com.vi = 0.5
        com.vd = 0.30
        com.width = 10
        com.height = 65

    score = {}
        score.player = 0
        score.com = 0
        score.stockplayer = 0
        score.stockcom = 0
        score.roundedplayer = 0
        score.roundedcom = 0
    
    ball = {}
        ball.x = game_width/2
        ball.y = game_height/2
        ball.vx = 100
        ball.vy = 100
        ball.width = 10
        ball.height = 10

    bonus = {}
        bonus.wbp1 = 0
        bonus.wbp2 = 0
        bonus.ballspeed = 1

    sound = {}
    sound.hit = love.audio.newSource("sfx/hit1.ogg", "static")
    sound.hit2 = love.audio.newSource("sfx/hit2.ogg", "static")

    --AABB Collision Function
    function isCollide(a, b)
        return a.x < b.x + b.width and
               a.x + a.width > b.x  and
               a.y < b.y + b.height and
               a.y + a.height > b.y
    end

    function round(n)
        return math.floor(n + 0.5)
    end
end

function love.update(dt)

    --com controller
    --Clean this shit up later

    if love.keyboard.isDown("up") then
        if com.speed > 0 then
            com.speed = 0
        end
        com.speed = com.speed - com.vi
        if com.speed < -com.cap then
            com.speed = -com.cap
        end
    else
        if love.keyboard.isDown("down") then
            if com.speed < 0 then
                com.speed = 0
            end
        com.speed = com.speed + com.vi
            if com.speed > com.cap then
                com.speed = com.cap
            end
        else
            if com.speed > 0 then
                com.speed = com.speed - com.vd
                if com.speed < 0 then
                    com.speed = 0
                end
            end

            if com.speed < 0 then
                com.speed = com.speed + com.vd
                if com.speed > 0 then
                    com.speed = 0
                end
            end
        end        
    end

    com.y = com.y + com.speed

    --player controller
    --Clean this shit up later

    if love.keyboard.isDown("w") then
        if player.speed > 0 then
            player.speed = 0
        end
        player.speed = player.speed - player.vi
        if player.speed < -player.cap then
            player.speed = -player.cap
        end
    else
        if love.keyboard.isDown("s") then
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
    if player.y < 100 then
        player.y = 100
        player.cap = player.cap + 0.5
        player.vd = 0.25
        player.speed = -player.speed
        bonus.wbp1 = bonus.wbp1 + 5
    end

    if player.y > (game_height - paddle.h) then
        player.y = (game_height - paddle.h)
        player.cap = player.cap + 0.5
        player.vd = 0.25
        player.speed = -player.speed
        bonus.wbp1 = bonus.wbp1 + 5
    end

    --Friction control cap
    if player.cap > 6 then
        player.vd = 0.2
    end

    --Total player cap
    if player.cap >= 9 then
        player.cap = 9
        player.vd = 0.15
    end
   
    --Anti broken wall bounce
    if player.speed == 0 then
        player.vd = 0.30
        player.cap = 5
        bonus.wbp1 = 0
    end

    --com bounds
    if com.y < 100 then
        com.y = 100
        com.cap = com.cap + 0.5
        com.vd = 0.25
        com.speed = -com.speed
        bonus.wbp2 = bonus.wbp2 + 5
    end

    if com.y > (game_height - paddle.h) then
        com.y = (game_height - paddle.h)
        com.cap = com.cap + 0.5
        com.vd = 0.25
        com.speed = -com.speed
        bonus.wbp2 = bonus.wbp2 + 5
    end

    --Friction control cap
    if com.cap > 6 then
        com.vd = 0.2
    end

    --Total com cap
    if com.cap >= 9 then
        com.cap = 9
        com.vd = 0.15
    end
   
    --Anti broken wall bounce
    if com.speed == 0 then
        com.vd = 0.30
        com.cap = 5
        bonus.wbp2 = 0
    end


    --ball math
    ball.x = ball.x + (ball.vx * dt)
    ball.y = ball.y + (ball.vy * dt)
    
    --ball bounds
    if ball.y <= 100 and ball.vy < 0 then
        ball.y = 100
        ball.vy = -ball.vy 
    elseif ball.y >= (game_height - ball.height) and ball.vy > 0 then
        ball.y = (game_height - ball.height)
        ball.vy = -ball.vy
    end

    --Bonus caps
    if bonus.wbp1 > 50 then
        bonus.wbp1 = 50
    end

    if bonus.wbp2 > 50 then
        bonus.wbp2 = 50
    end

    if bonus.ballspeed > 5 then
        bonus.ballspeed = 5
    end


    --Fix top speed boundary break (IMPORTANT)
    --com collision
    if isCollide(ball, com) then
        sound.hit:play()
        ball.x = com.x - ball.width
        if ball.vx > 500 then
            bonus.ballspeed = bonus.ballspeed + 0.1
            sound.hit2:play()
        end         
        ball.vx = ball.vx + 50
        ball.vx = -ball.vx
        score.com = score.com + 10 + bonus.wbp2
    end

    --player collision
    if isCollide(ball, player) then
        sound.hit:play()    
        ball.x = player.x + ball.width
        if ball.vx < -500 then
            bonus.ballspeed = bonus.ballspeed + 0.1
            sound.hit2:play()
        end        
        ball.vx = ball.vx - 50
        ball.vx = -ball.vx
        score.player = score.player + 10 + bonus.wbp2
    end

    --ball speed cap
    if ball.vx > 1000 then
        ball.vx = 1000
    end

    if ball.vx < -1000 then
        ball.vx = -1000
    end

    score.roundedplayer = math.floor(score.player + 0.5)
    score.roundedcom = math.floor(score.com + 0.5)

    --score and reset system
    if ball.x < 0 then
        ball.x = game_width/2
        ball.y = game_height/2
        ball.vx = 100
        ball.vy = 100
        score.stockcom = (score.stockcom + 100) * bonus.ballspeed
        score.com = score.com + score.stockcom
        bonus.ballspeed = 1
        bonus.wbp1 = 0
        bonus.wbp2 = 0
        score.stockcom = 0
        score.stockplayer = 0
    elseif ball.x > game_width then
        ball.x = game_width/2
        ball.y = game_height/2
        ball.vx = 100
        ball.vy = 100
        score.stockplayer = (score.stockplayer + 100 + bonus.wbp1) * bonus.ballspeed
        score.player = score.player + score.stockplayer
        bonus.ballspeed = 1
        bonus.wbp1 = 0
        bonus.wbp2 = 0
        score.stockcom = 0
        score.stockplayer = 0
    end
end

function love.draw()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", 0, 0, 600, 100)

    love.graphics.setColor(1,1,1,1)
    --Set font
    love.graphics.setFont(gameFont)
    
    --draw scores
    love.graphics.print("PLAYER 1", 112.5 - 30, 20, 0, 1, 1)
    love.graphics.print("PLAYER 2", (317.5-10), 20, 0, 1, 1)
    love.graphics.print(score.roundedplayer, (112.5 - 30), 30, 0, 2, 2)
    love.graphics.print(score.roundedcom, (317.5-10), 30, 0, 2, 2)

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

    gameFont:setFilter("nearest", "nearest")
end