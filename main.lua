
dofile('Scripts/gameActors.lua')
dofile('Scripts/auxFunctions.lua')
dofile('Scripts/auxClasses.lua')
dofile('Scripts/updateFunctions.lua')
dofile('Scripts/drawFunctions.lua')

local gameIniParameters = dofile('asteroids2017.ini') -- Load game ini parameters from ini file

local w, h -- Global (local chunk) variables for window dimensions

local spaceShip -- Global (local chunk) TABLE for spaceship object
local shield -- Global (local chunk) TABLE for shield object

local astMinSpeed = gameIniParameters.asteroidMinSpeed
local astMaxSpeed = gameIniParameters.asteroidMaxSpeed

local asteroidTimer = {} -- Global (local chunk) TABLE for asteroid timer object
local powerupTimer = {} -- Global (local chunk) TABLE for powerup object

local powerupLifeTimer = {} -- Global (local chunk) TABLE for powerup life span object
local regularBulletTimer = {} -- Global (local chunk) TABLE for regular bullet object
local bigRocketTimer = {} -- Global (local chunk) TABLE for big rocket object
local fastRocketTimer = {} -- Global (local chunk) TABLE for fast rocket object

local asteroidsCollection = {} -- Global (local chunk) TABLE for asteroids collection
local powerupsCollection = {} -- Global (local chunk) TABLE for powerups collection
local bulletsCollection = {} -- Global (local chunk) TABLE for bullets collection
local explosionsCollection = {} -- Global (local chunk) TABLE for explosions collection

local nilSpaceShip = false -- Bool variable to know if spaceship is nil

local game = {} -- Empty table for Game object
game.states = { 'moving', 'paused', 'over' } -- Game state possible values
game.activeState = 'moving' -- Default game state

local gameEvent -- Game events variable


function updateGameStates(gameEvent)

  if game.activeState == 'moving' and gameEvent == 'pPressed' then
    game.activeState = game.states[2]
  elseif game.activeState == 'paused' and gameEvent == 'pPressed' then
    game.activeState = game.states[1]
  end
  if gameEvent == 'rPressed' then
    resetGame(spaceShip, w, h, asteroidsCollection, powerupsCollection, bulletsCollection, explosionsCollection, nilSpaceShip, game, powerupLifeTimer)
    astMinSpeed = gameIniParameters.asteroidMinSpeed
    astMaxSpeed = gameIniParameters.asteroidMaxSpeed
    nilSpaceShip = false
  end
  if gameEvent == 'escPressed' then
    os.exit()
  end

end

function love.load() 

  backgroundImageFile = love.graphics.newImage("Textures/Backgrounds/background.jpg") -- Loads background image file

  w, h = love.graphics.getDimensions() -- Sets w,h to window dimensions

  spaceShip = spaceShipClass:new(w / 2, h / 2) -- Spawns a new spaceShip, centered on the game window

  shield = shieldClass:new(spaceShip.pos.x, spaceShip.pos.y) -- Spawns a new shield, centered on the game window

  asteroidTimer = timerClass:new(gameIniParameters.asteroidTime) -- Creates asteroid timer object as an instance of timerClass

  powerupTimer = timerClass:new(gameIniParameters.powerupTime) -- Create powerup timer object as an instance of timerClass

  powerupLifeTimer = timerClass:new(gameIniParameters.powerupLife) -- Create powerup life span timer object as an instance of timerClass

  regularBulletTimer = timerClass:new(gameIniParameters.regularBulletTime) -- Create regular bullet timer object as an instance of timerClass

  bigRocketTimer = timerClass:new(gameIniParameters.bigRocketTime) -- Create big rocket timer object as an instance of timerClass

  fastRocketTimer = timerClass:new(gameIniParameters.fastRocketTime) -- Create fast rocket timer object as an instance of timerClass

end



function love.update(dt)

  if love.keyboard.isDown('r') then -- Changes game event if R is pressed
    gameEvent = 'rPressed' 
  end
  if love.keyboard.isDown('escape') then -- Changes game event if ESC is pressed
    gameEvent = 'escPressed'
  end
  if love.keyboard.isDown('p') then -- Changes game event if P is pressed
    gameEvent = 'pPressed'
  end
  if love.keyboard.isDown('space') and game.activeState ~= game.states[3] then -- Changes game event if SPACE is pressed
    if spaceShip.activePower == 'rocketBig' and bigRocketTimer:check() then
      local bullet = bulletClass:new(spaceShip.pos.x, spaceShip.pos.y - spaceShip.offset.y - 46, 'rocket')
      bullet.id = #bulletsCollection + 1
      bulletsCollection[#bulletsCollection + 1] = bullet
    elseif spaceShip.activePower == 'rocketFast' and fastRocketTimer:check() then
      local bullet = bulletClass:new(spaceShip.pos.x, spaceShip.pos.y - spaceShip.offset.y - 46, 'regular')
      bullet.id = #bulletsCollection + 1
      bulletsCollection[#bulletsCollection + 1] = bullet
    elseif spaceShip.activePower ~= 'rocketBig' and spaceShip.activePower ~= 'rocketFast' and regularBulletTimer:check() then
      local bullet = bulletClass:new(spaceShip.pos.x, spaceShip.pos.y - spaceShip.offset.y - 46, 'regular')
      bullet.id = #bulletsCollection + 1
      bulletsCollection[#bulletsCollection + 1] = bullet
    end
  end

  regularBulletTimer:update(dt) -- Update regular bullet timer

  bigRocketTimer:update(dt) -- Update big rocket timer

  fastRocketTimer:update(dt) -- Update fast rocket timer

  if spaceShip.activePower ~= nil and spaceShip.activePower ~= 'star' and spaceShip.activePower ~= 'death' and spaceShip.activePower ~= 'nuke' then -- Update power up timer only if there's an active power that needs a countdown
    powerupLifeTimer:update(dt)
  end

  if powerupLifeTimer:check() then -- Removes power up if timer is over
    spaceShip.activePower = nil
  end

  updateGameStates(gameEvent) -- Update FSM

  if not(nilSpaceShip) then
    spaceShip:move(w, h, dt) -- Move spaceship
  end

  if not(nilSpaceShip) then
    spaceShip:playAnimations(dt) -- Play spaceship animations
  end

  if not(nilSpaceShip) then
    shield:playAnimations(dt) -- Play shield animations
  end

  for k, power in pairs(powerupsCollection) do
    power:playAnimations(dt)
  end

  asteroidTimer:update(dt) -- Update asteroid timer

  powerupTimer:update(dt) -- Update powerup timer

  if game.activeState ~= game.states[3] then

    if asteroidTimer:check() then -- Checks if it's time to spawn another asteroid
      local asteroid = asteroidClass:new(w, astMinSpeed, astMaxSpeed) -- Spawns new asteroid
      asteroid.id = #asteroidsCollection + 1 -- Updates asteroid id
      asteroidsCollection[#asteroidsCollection + 1] = asteroid -- Adds asteroid to collection

      if powerupTimer:check() then -- Checks if it's time to spawn another powerUp
        local powerup = powerUpClass:new(asteroid.pos.x, asteroid.pos.y, asteroid.speed) -- Spawns new powerUp
        powerup.id = #powerupsCollection + 1 -- Updates powerUp id
        powerupsCollection[#powerupsCollection + 1] = powerup -- Adds powerUp to collection
      end    
    end

  end

  moveAsteroids(asteroidsCollection, h, spaceShip, dt) -- Move asteroids

  movePowerups(powerupsCollection, h, spaceShip, dt) -- Move powerups

  moveBullets(bulletsCollection, h, dt) -- Move bullets

  updateExplosions(explosionsCollection, dt) -- Update explosions

  updateAsteroids(asteroidsCollection, dt) -- Update asteroids

  astMinSpeed = astMinSpeed + dt / 4 -- asteroids min speed rises by 1 every 4 seconds
  astMaxSpeed = astMaxSpeed + dt / 4 -- asteroids max speed rises by 1 every 4 seconds

  updateShield(shield, spaceShip) -- Update shield

  if checkCollisions(asteroidsCollection, spaceShip, explosionsCollection, powerupsCollection, bulletsCollection, game) then -- Check collisions
    nilSpaceShip = true
  end

  if spaceShip.activePower == 'star' or spaceShip.activePower == 'death' or spaceShip.activePower == 'nuke' then
    spaceShip.activePower = nil
  end

  gameEvent = ' ' -- Resets game event

end


function love.draw()

  love.graphics.draw(backgroundImageFile) -- Draw background

  drawAsteroids(asteroidsCollection) -- Draw asteroids

  drawPowerups(powerupsCollection) -- Draw powerups

  drawExplosions(explosionsCollection) -- Draw explosions

  drawBullets(bulletsCollection) -- Draw bullets

  if love.keyboard.isDown('c') then
    drawColliderRadius(spaceShip, asteroidsCollection, powerupsCollection, bulletsCollection) -- Draw collider radius of all objects
  end

  if not(nilSpaceShip) then
    spaceShip:draw() -- Draw spaceShip
  end

  if spaceShip.activePower == 'shield' then
    if not(nilSpaceShip) then
      shield:draw() -- Draw spaceShip
    end
  end
end
