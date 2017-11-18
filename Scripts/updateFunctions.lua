function moveAsteroids(asteroidsCollection, h, spaceShip, dt) -- This function moves all asteroids on game window and destroys if is out of window

  for index, asteroid in pairs(asteroidsCollection) do
    asteroid:move(spaceShip, dt)
    if (asteroid.pos.y - asteroid.offset.y) > h then 
      asteroid:destroy(asteroidsCollection)
    end
  end

end

function movePowerups(powerupsCollection, h, spaceShip, dt) -- This function moves all powerups on game window and destroys if is out of window

  for index, powerup in pairs(powerupsCollection) do
    powerup:move(spaceShip, dt)
    if (powerup.pos.y - powerup.offset.y) > h then 
      powerup:destroy(powerupsCollection)
    end
  end

end

function moveBullets(bulletsCollection, h, dt) -- This function moves all bullets on game window and destroys if is out of window

  for index, bullet in pairs(bulletsCollection) do
    bullet:move(dt)
    if (bullet.pos.y - bullet.offset.y) > h then 
      bullet:destroy(bulletsCollection)
    end
  end

end

function updateExplosions(explosionsCollection, dt) -- This function updates all explosions on game window

  for index, exp in pairs(explosionsCollection) do
    exp:playAnimations(dt)
    if exp.animation.state == 'idle' then
      exp:destroy(explosionsCollection)
    end
  end

end

function updateAsteroids(asteroidsCollection, dt) -- This function updates all explosions on game window

  for index, asteroid in pairs(asteroidsCollection) do
    asteroid:playAnimations(dt)
    if asteroid.animation.state == 'idle' then
      asteroid:destroy(asteroidsCollection)
    end
  end

end

function updateShield(shield, spaceShip)

  shield.pos.x = spaceShip.pos.x
  shield.pos.y = spaceShip.pos.y

end