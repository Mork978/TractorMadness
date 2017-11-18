function drawAsteroids(asteroidsCollection) -- This function draws all asteroids on game window

  for _, asteroid in pairs(asteroidsCollection) do
    asteroid:draw()
  end

end

function drawPowerups(powerupsCollection) -- This function draws all powerups on game window

  for _, powerup in pairs(powerupsCollection) do
    powerup:draw()
  end

end

function drawExplosions(explosionsCollection) -- This function draws all explosions on game window

  for _, explosion in pairs(explosionsCollection) do
    explosion:draw()
  end

end

function drawBullets(bulletsCollection) -- This function draws all bullets on game window

  for _, bullet in pairs(bulletsCollection) do
    bullet:draw()
  end

end

function drawColliderRadius(spaceShip, asteroidsCollection, powerupsCollection, bulletsCollection)

  love.graphics.circle('line', spaceShip.pos.x, spaceShip.pos.y, spaceShip.colliderRadius)

  for _, asteroid in pairs(asteroidsCollection) do
    love.graphics.circle('line', asteroid.pos.x, asteroid.pos.y, asteroid.colliderRadius)
  end

  for _, power in pairs(powerupsCollection) do
    love.graphics.circle('line', power.pos.x, power.pos.y, power.colliderRadius)
  end

  for _, bullet in pairs(bulletsCollection) do
    love.graphics.circle('line', bullet.pos.x, bullet.pos.y, bullet.colliderRadius)
  end

end
