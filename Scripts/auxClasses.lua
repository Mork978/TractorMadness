timerClass = {

  new = function(self, maxTime) -- This function creates and returns a new timer object, as an instance of TimerClass

    local timerClass = {}

    -- Properties
    timerClass.currentTime = 0
    timerClass.maxTime = maxTime

    -- Methods 
    timerClass.reset = self.reset
    timerClass.update = self.update
    timerClass.check = self.check

    return timerClass
  end,

  reset = function(self) -- This function sets current time to 0

    self.currentTime = 0

  end,

  update = function(self, dt) -- This function updates current time adding dt lapse 

    self.currentTime = self.currentTime + dt

  end,

  check = function(self) -- This function updates checks if max time has been reached. If so, returns TRUE and resets current time

    if self.currentTime >= self.maxTime then
      self:reset()
      return true
    end 

  end
}

animationClass = {


  new  = function (self, imageFile, totalFrames, frameTime, frameW, frameH, x, y, rows, cols, playMode) -- This function creates a new animation object

    local animation = {}

    -- Properties
    animation.imageFile = love.graphics.newImage(imageFile)
    animation.frames = {}
    animation.totalFrames = totalFrames
    animation.frameCounter = 0
    for i = 0, rows - 1 do
      for j = 0, cols - 1 do
        animation.frames[animation.frameCounter] = love.graphics.newQuad(j * frameW, i * frameH, frameW, frameH, animation.imageFile:getDimensions())  
        animation.frameCounter = animation.frameCounter + 1
      end
    end
    animation.currentFrame = 0
    animation.activeFrame = animation.frames[animation.currentFrame]
    animation.timer = timerClass:new(frameTime)
    animation.state = 'running'
    animation.pos = {x = x, y = y}
    animation.offset = {x = frameW / 2, y = frameH / 2}
    animation.playMode = playMode

    -- Methods
    animation.play = self.play 
    animation.pause = self.pause
    animation.stop = self.stop

    return animation
  end, 


  play = function(self, dt) -- Plays animation 

    if self.state == 'running' then
      if self.playMode == 'loop' then -- Plays animation in loop mode
        self.timer:update(dt)
        if self.timer:check() then
          self.currentFrame = (self.currentFrame + 1) % (self.totalFrames)
        end
      end
      if self.playMode == 'once' then -- Plays animation only once
        self.currentFrame = (self.currentFrame + 1) % (self.totalFrames)  
        if self.currentFrame == 0 then
          self.state = 'idle'
        end
      end
    end
    
  end,


  pause = function(self)

    if self.state == 'running' then self.state = 'idle' 
    elseif self.state == 'idle' then self.state = 'running' end

  end,


  stop = function(self)

    self.timer:reset()
    self.currentFrame = 0
    self.state = 'idle'

  end
}
