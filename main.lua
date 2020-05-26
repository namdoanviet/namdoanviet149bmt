push=require 'push'
Class=require'class'
require'ball'
require'paddle'
window_width=1280
window_height=720
virtual_width=432
virtual_height=243
paddle_speed=200  
--qwrqwrqwrqwrqw
function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle('pong')
    smallword=love.graphics.newFont('font.ttf',8)
    scorepoint=love.graphics.newFont('font.ttf',32)
    vicfont=love.graphics.newFont('font.ttf',16)
    love.graphics.setFont(smallword)
    push:setupScreen(virtual_width,virtual_height,window_width,window_height,{
    fullscreen=false,
    resizable=true,
    vysnc=true
 })
    math.randomseed(os.time())
    sounds={
        ['paddlehit']=love.audio.newSource('sounds/chamnguoichoi.wav','static'),
        ['getpoint']=love.audio.newSource('sounds/ghidiem.wav','static'),
        ['wallhit']=love.audio.newSource('sounds/chamtuong.wav','static'),
        ['victory']=love.audio.newSource('sounds/victory.wav','static')
    }
    p1score=0
    p2score=0
    servingplayer=1
    p1=paddle(10,30,5,20)
    p2=paddle(virtual_width-15,virtual_height-40,5,20)
    ball=ball(virtual_width/2-2,virtual_height/2-2,4,4)
    gamestate='start'
end

function love.resize(w,h)
    push:resize(w,h)
end
function love.update(dt)
    if gamestate =='play' then
        if ball:collide(p1) then
            ball.dx=-ball.dx*1.05
            ball.x=p1.x+5
            if ball.dy<0 then
                ball.dy=-math.random(20,80)
            else ball.dy=math.random(20,80)
            end
            sounds['paddlehit']:play()
        end
        if ball:collide(p2) then
            ball.dx=-ball.dx*1.05
            ball.x=p2.x-4
            if ball.dy<0 then
                ball.dy=-math.random(20,80)
            else ball.dy=math.random(20,80)
            end
            sounds['paddlehit']:play()
        end
    
         if ball.y<=0 then
            ball.y=0
            ball.dy=-ball.dy
            sounds['wallhit']:play()
        end
        if ball.y>=virtual_height-4 then
        ball.y=virtual_height-4
        ball.dy=-ball.dy
        sounds['wallhit']:play()
        end
        ball:update(dt)
        if ball.x+4<=0 then
            servingplayer=1
            p2score=p2score+1
            if p2score==10 then
                pwinning=2
                gamestate='finish'
                p1score=0
                p2score=0
                sounds['victory']:play()
                ball:reset()
            else
                gamestate='serve'
                ball:reset()

            end
            sounds['getpoint']:play()
        end
        if ball.x>=virtual_width then
            p1score=p1score+1
            servingplayer=2
            if p1score==10 then
                pwinning=1
                gamestate='finish'
                p1score=0
                p2score=0
                sounds['victory']:play()
                ball:reset()
            else 
                gamestate='serve'
                ball:reset()
            end
            sounds['getpoint']:play()
        end

    elseif gamestate=='serve' then
        if servingplayer==1 then
            ball.dy=math.random(2)==1 and -100 or 100
            ball.dx=math.random(100,120)
        elseif servingplayer==2 then
            ball.dy=math.random(2)==1 and -100 or 100
            ball.dx=-math.random(100,120)
        end
    end       
    if love.keyboard.isDown('w')then
        p1.dy=-paddle_speed
    elseif love.keyboard.isDown('s')then
        p1.dy=paddle_speed
    else p1.dy=0
    end
    if love.keyboard.isDown('up')then
        p2.dy=-paddle_speed
    elseif love.keyboard.isDown('down')then
        p2.dy=paddle_speed
    else p2.dy=0
    end
    p1:update(dt)
    p2:update(dt)
end


function love.keypressed(key)
    if key=='escape'then
        love.event.quit()
    elseif key=='enter'or key=='return' then
        if gamestate=='start'then
            gamestate='serve' 
        elseif gamestate=='serve' then
            gamestate='play'
        elseif gamestate=='finish' then
            gamestate='serve'
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40,42,52,55)
    love.graphics.setFont(scorepoint)
    love.graphics.print(tostring(p1score),virtual_width/2-50,virtual_height/3)
    love.graphics.print(tostring(p2score),virtual_width/2+20,virtual_height/3)
    love.graphics.setFont(smallword)
    if gamestate=='start'then
        love.graphics.printf('Welcome to game',0,virtual_height/7,virtual_width,'center')
        love.graphics.printf('Press enter to play',0,virtual_height/7+20,virtual_width,'center')
    elseif gamestate=='serve' then
        love.graphics.printf('Serving Player'..tostring(servingplayer),0,virtual_height/7,virtual_width,'center')
        love.graphics.printf('Press enter to play',0,virtual_height/7+20,virtual_width,'center')
    elseif gamestate=='finish' then
        love.graphics.setFont(vicfont)
        love.graphics.printf('Player '..tostring(pwinning)..' win',0,virtual_height/8,virtual_width,'center')
        love.graphics.printf('Press enter to play again',0,virtual_height/8+20,virtual_width,'center')
    end
    p1:render()
    p2:render()
    ball:render()
    displayFPS()
    --displayscore()
    push:apply('end')
end
function displayFPS()
    love.graphics.setFont(smallword)
    love.graphics.setColor(0,255,0,255)
    love.graphics.print('FPS:'..tostring(love.timer.getFPS()),10,10)
end


    







