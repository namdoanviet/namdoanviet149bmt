ball=Class{}
function ball:init(x,y,width,height)
    self.x=x
    self.y=y
    self.width=width
    self.height=height
    --self.dx=math.random(2)==1 and -100 or 100
    --self.dy=math.random(2)==1 and -math.random(80,100) or math.random(80,100)
end
function ball:collide(paddle)
    if self.x>paddle.x+paddle.width or self.x+self.width<paddle.x then
        return false
    end
    if self.y>paddle.y+paddle.height or self.y+self.height<paddle.y then
        return false 
    end
    return true
end
function ball:update(dt)
    self.x=self.x+self.dx*dt
    self.y=self.y+self.dy*dt
end
function ball:reset()
    self.x=virtual_width/2-2
    self.y=virtual_height/2-2
    --self.dx=math.random(2)==1 and -100 or 100
    --self.dy=math.random(2)==1 and -math.random(80,100) or math.random(80,100)
end
function ball:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end