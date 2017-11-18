spaceShipClass = {

  new = function(self, x, y) -- This function returns a new instance of spaceship object

    local spaceShip = {}

    -- Properties
    spaceShip.imageFiles = {
      "Textures/Ships/DKO-api-X1.png",
      "Textures/Ships/DKO-api-X2.png",
      "Textures/Ships/DKO-api-X3.png"
    }
    spaceShip.imageFile = love.graphics.newImage(spaceShip.imageFiles[1])
    spaceShip.flameImageFile = love.graphics.newImage("Textures/Ships/spaceship_flame.png")
    spaceShip.offset = {x = spaceShip.imageFile:getWidth() / 2, y = spaceShip.imageFile:getHeight() / 2 }
    spaceShip.pos = { x = x, y = y} 
    spaceShip.forwardVec = { x = 0, y = -1}
    spaceShip.speed = 300
    spaceShip.colliderRadius = spaceShip.imageFile:getWidth() / 2
    spaceShip.flameAnimation = animationClass:new("Textures/Ships/spaceship_flame.png", 7, 0.04, spaceShip.flameImageFile:getWidth() / 7, spaceShip.flameImageFile:getHeight(), -spaceShip.offset.x * 0.09, spaceShip.offset.y * 0.94, 1, 7, 'loop')
    spaceShip.activePower = 'shield'

    -- Methods
    spaceShip.new = self.new
    spaceShip.draw = self.draw
    spaceShip.move = self.move
    spaceShip.playAnimations = self.playAnimations

    return spaceShip

  end,  

  draw = function(self)

    love.graphics.draw(self.imageFile, self.pos.x - self.offset.x, self.pos.y - self.offset.y)
    love.graphics.draw(self.flameAnimation.imageFile, self.flameAnimation.frames[self.flameAnimation.currentFrame], self.pos.x + self.flameAnimation.pos.x, self.pos.y + self.flameAnimation.pos.y)

  end,


  move = function(self, w, h, dt) -- This function moves spaceShip object in window, by its position (x, y)

    local moveDirections = {
      right = {x = 1, y = 0},
      left = {x = -1, y = 0},
      up = {x = 0, y = -1},
      down = {x = 0, y = 1}
    }
    for direction, forwardVec in pairs (moveDirections) do
      if love.keyboard.isDown(direction) then
        self.forwardVec = moveDirections[direction]
        self.pos.x = self.pos.x + self.forwardVec.x * self.speed * dt
        self.pos.y = self.pos.y + self.forwardVec.y * self.speed * dt

        self.pos.x = clamp(self.pos.x, self.offset.x, w - self.offset.x) -- We clamp x values according to window dimensions
        self.pos.y = clamp(self.pos.y, self.offset.y, h - self.offset.y) -- We clamp y values according to window dimensions
      end
    end
  end,

  playAnimations = function(self, dt) -- This function plays animations

    self.flameAnimation:play(dt)

  end
}


asteroidClass = {

  new = function(self, w, minSpeed, maxSpeed) -- This function creates and returns a new asteorid object

    local asteroid = {}

    -- Properties
    asteroid.id = 0
    asteroid.AllImageFiles = {
      "Textures/Asteroids/asteroid_01_with_cracks.png", 
      "Textures/Asteroids/asteroid_02_with_cracks.png", 
      "Textures/Asteroids/asteroid_04_with_cracks.png", 
      "Textures/Asteroids/asteroid_07_with_cracks.png", 
      "Textures/Asteroids/asteroid_08_with_cracks.png", 
      "Textures/Asteroids/asteroid_09_with_cracks.png", 
      "Textures/Asteroids/asteroid_10_with_cracks.png", 
      "Textures/Asteroids/asteroid_12_with_cracks.png", 
      "Textures/Asteroids/asteroid_13_with_cracks.png", 
      "Textures/Asteroids/asteroid_14_with_cracks.png", 
      "Textures/Asteroids/asteroid_15_with_cracks.png"
    }
    math.randomseed(os.time())
    asteroid.imageFileName = asteroid.AllImageFiles[math.random(1, #asteroid.AllImageFiles)]
    asteroid.imageFiles = love.graphics.newImage(asteroid.imageFileName)
    asteroid.offset = {x = asteroid.imageFiles:getWidth() / 2, y = asteroid.imageFiles:getHeight() / 2}
    asteroid.pos = { x = math.random(0, w), y = -400}
    asteroid.forwardVec = { x = 0, y = 1}
    asteroid.speed = math.random(minSpeed, maxSpeed)

    if asteroid.imageFileName == "Textures/Asteroids/asteroid_01_with_cracks.png" then
      asteroid.lifes = 12
      asteroid.colliderRadius = asteroid.imageFiles:getHeight() / 4
      asteroid.animation = animationClass:new(asteroid.imageFileName, 6, 1, asteroid.imageFiles:getWidth() / 3, asteroid.imageFiles:getHeight() / 2, -asteroid.offset.x / 3, -asteroid.offset.y / 2, 2, 3, 'static')
    elseif asteroid.imageFileName == "Textures/Asteroids/asteroid_02_with_cracks.png" or
    asteroid.imageFileName == "Textures/Asteroids/asteroid_04_with_cracks.png" then
      asteroid.lifes = 8
      asteroid.colliderRadius = asteroid.imageFiles:getHeight() / 4
      asteroid.animation = animationClass:new(asteroid.imageFileName, 4, 1, asteroid.imageFiles:getWidth() / 2, asteroid.imageFiles:getHeight() / 2, -asteroid.offset.x / 2, -asteroid.offset.y / 2, 2, 2, 'static')
    elseif asteroid.imageFileName == "Textures/Asteroids/asteroid_14_with_cracks.png" or
    asteroid.imageFileName == "Textures/Asteroids/asteroid_15_with_cracks.png" then
      asteroid.lifes = 4
      asteroid.colliderRadius = asteroid.imageFiles:getWidth() / 4
      asteroid.animation = animationClass:new(asteroid.imageFileName, 2, 1, asteroid.imageFiles:getWidth() / 2, asteroid.imageFiles:getHeight(), -asteroid.offset.x / 2, -asteroid.offset.y, 1, 2, 'static')
    else 
      asteroid.lifes = 6
      asteroid.colliderRadius = asteroid.imageFiles:getHeight() / 2
      asteroid.animation = animationClass:new(asteroid.imageFileName, 3, 1, asteroid.imageFiles:getWidth() / 3, asteroid.imageFiles:getHeight(), -asteroid.offset.x / 3, -asteroid.offset.y, 1, 3, 'static')
    end

    -- Methods
    asteroid.move = self.move
    asteroid.draw = self.draw
    asteroid.destroy = self.destroy
    asteroid.playAnimations = self.playAnimations
    asteroid.lifeLost = self.lifeLost

    return asteroid
  end,

  move = function(self, spaceShip, dt) -- This functions moves asteroid in game window (if time powerup is active, reduces speed)

    if spaceShip.activePower == 'time' then
      self.pos.y = self.pos.y + (self.speed / 4) * self.forwardVec.y * dt
    else self.pos.y = self.pos.y + self.speed * self.forwardVec.y * dt
    end

  end,

  draw = function(self) -- This function draws asteroid on game window

    love.graphics.draw(self.animation.imageFile, self.animation.frames[self.animation.currentFrame], self.pos.x + self.animation.pos.x, self.pos.y + self.animation.pos.y)

  end, 

  destroy = function(self, asteroidsCollection) -- This function deletes asteroid object from game

    asteroidsCollection[self.id] = nil

  end, 

  playAnimations = function(self, dt) -- This function plays animations

    self.animation:play(dt)

  end, 

  lifeLost = function(self, asteroidsCollection)

    self.lifes = self.lifes - 1
    if self.lifes % 2 == 0 then
      self.animation.currentFrame = self.animation.currentFrame + 1
      if self.lifes == 0 then
        --self:destroy(asteroidsCollection)
        return true
      end
    end

  end
}

powerUpClass = {

  new = function(self, x, y, speed) -- This function creates and returns a new powerup object

    local powerUp = {}

    -- Properties
    powerUp.types = { 'shield', 'rocketBig', 'rocketFast', 'time', 'star', 'nuke', 'death' }
    math.randomseed(os.time())
    powerUp.type = powerUp.types[math.random(1, 7)]
    if powerUp.type == 'shield' then
      powerUp.imageFileName = 'Textures/Powerups/powerup_04.png'
    elseif powerUp.type == 'rocketBig' then
      powerUp.imageFileName = 'Textures/Powerups/powerup_05.png'
    elseif powerUp.type == 'rocketFast' then
      powerUp.imageFileName = 'Textures/Powerups/powerup_06.png'
    elseif powerUp.type == 'time' then
      powerUp.imageFileName = 'Textures/Powerups/powerup_12.png'
    elseif powerUp.type == 'star' then
      powerUp.imageFileName = 'Textures/Powerups/powerup_13.png'
    elseif powerUp.type == 'nuke' then
      powerUp.imageFileName = 'Textures/Powerups/powerup_02.png'
      elseif powerUp.type == 'death' then
      powerUp.imageFileName = 'Textures/Powerups/powerup_11.png'
    end
    powerUp.id = 0 
    powerUp.imageFile = love.graphics.newImage(powerUp.imageFileName)
    powerUp.offset = {x = powerUp.imageFile:getWidth() / 2, y = powerUp.imageFile:getHeight() / 2}
    powerUp.pos = {x = x, y = y}
    powerUp.forwardVec = {x = 0, y = 1}
    powerUp.speed = speed
    powerUp.colliderRadius = powerUp.imageFile:getHeight() / 2
    powerUp.animation = animationClass:new(powerUp.imageFileName, 2, 0.25, powerUp.imageFile:getWidth() / 2, powerUp.imageFile:getHeight(), -powerUp.offset.x / 2, -powerUp.offset.y, 1, 2, 'loop')

    -- Methods
    powerUp.move = self.move
    powerUp.draw = self.draw
    powerUp.destroy = self.destroy
    powerUp.playAnimations = self.playAnimations

    return powerUp

  end, 

  move = function(self, spaceShip, dt) -- This functions moves powerups in game window (if time powerup is active, reduces speed)

    if spaceShip.activePower == 'time' then
      self.pos.y = self.pos.y + (self.speed / 4) * self.forwardVec.y * dt
    else self.pos.y = self.pos.y + self.speed * self.forwardVec.y * dt
    end

  end,

  draw = function(self) -- This function draws powerup on game window

    love.graphics.draw(self.animation.imageFile, self.animation.frames[self.animation.currentFrame], self.pos.x + self.animation.pos.x, self.pos.y + self.animation.pos.y)

  end, 

  destroy = function(self, powerupsCollection) -- This function deletes powerup object from game

    powerupsCollection[self.id] = nil

  end,

  playAnimations = function(self, dt) -- This function plays animations

    self.animation:play(dt)

  end
}
explosionClass = {

  new = function(self, x, y, explosionType) -- This function returns a new instance of explosion object

    local explosion = {}

    -- Properties
    if explosionType == 'big' then
      explosion.imageFileName = "Textures/Explosions/explosion_big.png"
      explosion.imageFile = love.graphics.newImage("Textures/Explosions/explosion_big.png")
    elseif explosionType == 'small' then
      explosion.imageFileName = "Textures/Explosions/explosion.png"
      explosion.imageFile = love.graphics.newImage("Textures/Explosions/explosion.png")
    end
    explosion.offset = {x = explosion.imageFile:getHeight() / 2, y = explosion.imageFile:getHeight() / 2}
    explosion.pos = { x = x, y = y} 
    explosion.colliderRadius = explosion.imageFile:getWidth() / 2
    explosion.animation = nil
    explosion.animation = animationClass:new(explosion.imageFileName, 9, 0.04, explosion.imageFile:getWidth() / 9, explosion.imageFile:getHeight(), - explosion.offset.x, - explosion.offset.y, 1, 9, 'once')

    -- Methods
    explosion.new = self.new
    explosion.draw = self.draw
    explosion.playAnimations = self.playAnimations
    explosion.destroy = self.destroy

    return explosion

  end,

  draw = function(self) -- This function draws explosion on game window

    love.graphics.draw(self.animation.imageFile, self.animation.frames[self.animation.currentFrame], self.pos.x + self.animation.pos.x, self.pos.y + self.animation.pos.y)

  end,

  drawColliderRadius = function(self) -- This function draws explosion collider radius on game window

    love.graphics.circle('line', self.pos.x, self.pos.y, self.colliderRadius)

  end, 

  playAnimations = function(self, dt) -- This function plays animations

    self.animation:play(dt)

  end, 

  destroy = function(self, explosionsCollection) -- This function deletes explosion object from game

    explosionsCollection[self.id] = nil

  end
}

bulletClass = {

  new = function(self, x, y, bulletType) -- This function creates and returns a new bullet object

    local bullet = {}

    -- Properties
    bullet.id = 0
    bullet.AllImageFiles = {
      regular = "Textures/Weapons/bullet_short_single.png", 
      rocket = "Textures/Weapons/rocket_bx_single.png"
    }
    bullet.type = bulletType
    bullet.imageFileName = bullet.AllImageFiles[bullet.type]
    bullet.imageFile = love.graphics.newImage(bullet.imageFileName)
    bullet.offset = {x = bullet.imageFile:getWidth() / 2, y = bullet.imageFile:getHeight()}
    bullet.pos = { x = x, y = y}
    bullet.forwardVec = { x = 0, y = -1}
    bullet.speed = 400
    bullet.colliderRadius = bullet.imageFile:getWidth() / 2
    bullet.colliderOffset = {x = bullet.imageFile:getWidth() / 2, y = 0}


    -- Methods
    bullet.move = self.move
    bullet.draw = self.draw
    bullet.destroy = self.destroy

    return bullet
  end,

  move = function(self, dt) -- This functions moves asteroid in game window

    self.pos.y = self.pos.y + self.speed * self.forwardVec.y * dt

  end,

  draw = function(self) -- This function draws asteroid on game window

    love.graphics.draw(self.imageFile, self.pos.x - self.colliderOffset.x, self.pos.y - self.colliderOffset.y)

  end, 

  destroy = function(self, bulletsCollection) -- This function deletes asteroid object from game

    bulletsCollection[self.id] = nil

  end
}

shieldClass = {

  new = function(self, x, y) -- This function creates and returns a new shield object

    local shield = {}

    -- Properties
    shield.imageFileName = "Textures/Weapons/shield_frames.png"
    shield.imageFile = love.graphics.newImage(shield.imageFileName)
    shield.offset = {x = shield.imageFile:getWidth() / 2, y = shield.imageFile:getHeight() / 2}
    shield.pos = { x = x, y = y}
    shield.animation = animationClass:new(shield.imageFileName, 6, 0.04, shield.imageFile:getWidth() / 3, shield.imageFile:getHeight() / 2, -shield.offset.x / 3, -shield.offset.y / 2, 2, 3, 'loop')

    -- Methods
    shield.draw = self.draw
    shield.playAnimations = self.playAnimations

    return shield
  end,

  draw = function(self) -- This function draws shield on game window

    love.graphics.draw(self.animation.imageFile, self.animation.frames[self.animation.currentFrame], self.pos.x + self.animation.pos.x, self.pos.y + self.animation.pos.y)

  end,

  playAnimations = function(self, dt) -- This function plays animations

    self.animation:play(dt)

  end, 
}