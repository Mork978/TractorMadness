function clamp(x, min, max) -- This function forces the x value to be between min and max values

  if x > max then x = max end
  if x < min then x = min end
  return x

end

function getDistance(gameObject1, gameObject2) -- This function calculates and returns the distance between two game objects

  return math.sqrt((gameObject1.pos.x - gameObject2.pos.x)^2 + (gameObject1.pos.y - gameObject2.pos.y)^2)

end


function isColliding(gameObject1, gameObject2) -- This function detects a circular collision between gameObject1 and gameObject2

  if getDistance(gameObject1, gameObject2) < (gameObject1.colliderRadius + gameObject2.colliderRadius) then
    return true
  else 
    return false
  end

end

function checkCollisions(asteroidsCollection, spaceShip, explosionsCollection, powerupsCollection, bulletsCollection, game)

  for k, asteroid in pairs(asteroidsCollection) do
    if isColliding(spaceShip, asteroid) and spaceShip.activePower ~= 'shield' then
      local explosion = explosionClass:new(spaceShip.pos.x, spaceShip.pos.y, 'big')
      explosion.id = #explosionsCollection + 1
      explosionsCollection[explosion.id] = explosion
      for k, ast in pairs(asteroidsCollection) do
        ast:destroy(asteroidsCollection)
        local explosion = explosionClass:new(ast.pos.x, ast.pos.y, 'big')
        explosion.id = #explosionsCollection + 1
        explosionsCollection[explosion.id] = explosion
      end
      for k, pow in pairs(powerupsCollection) do
        pow:destroy(powerupsCollection)
      end
      game.activeState = game.states[3]
      return true
    end
    for k, bullet in pairs(bulletsCollection) do
      if isColliding(bullet, asteroid) then
        local explosion = explosionClass:new(bullet.pos.x, bullet.pos.y, 'small')
        explosion.id = #explosionsCollection + 1
        explosionsCollection[explosion.id] = explosion
        bullet:destroy(bulletsCollection)
        if bullet.type == 'rocket' then
          asteroid.lifes = 1
        end
        if asteroid:lifeLost(asteroidsCollection) then
          asteroid:destroy(asteroidsCollection)
          local explosion = explosionClass:new(asteroid.pos.x, asteroid.pos.y, 'big')
          explosion.id = #explosionsCollection + 1
          explosionsCollection[explosion.id] = explosion
        end
      end
    end
    for k, power in pairs(powerupsCollection) do
      if isColliding(spaceShip, power) and spaceShip.activePower == nil then
        if spaceShip.activePower == nil then
          spaceShip.activePower = power.type
        end
        if power.type == 'death' then
          local explosion = explosionClass:new(spaceShip.pos.x, spaceShip.pos.y, 'big')
          explosion.id = #explosionsCollection + 1
          explosionsCollection[explosion.id] = explosion
          for k, ast in pairs(asteroidsCollection) do
            ast:destroy(asteroidsCollection)
            local explosion = explosionClass:new(ast.pos.x, ast.pos.y, 'big')
            explosion.id = #explosionsCollection + 1
            explosionsCollection[explosion.id] = explosion
          end
          for k, pow in pairs(powerupsCollection) do
            pow:destroy(powerupsCollection)
          end
          game.activeState = game.states[3]
          return true
        end
        if power.type == 'nuke' then
          for k, ast in pairs(asteroidsCollection) do
            ast:destroy(asteroidsCollection)
            local explosion = explosionClass:new(ast.pos.x, ast.pos.y, 'big')
            explosion.id = #explosionsCollection + 1
            explosionsCollection[explosion.id] = explosion
          end
        end
        power:destroy(powerupsCollection)
      end
    end
  end
end

function resetGame(spaceShip, w, h, asteroidsCollection, powerupsCollection, bulletsCollection, explosionsCollection, nilSpaceShip, game, powerupLifeTimer)

  spaceShip.pos.x = w / 2
  spaceShip.pos.y = h / 2
  spaceShip.activePower = 'shield'
  powerupLifeTimer:reset()
  for k, asteroid in pairs(asteroidsCollection) do
    asteroid:destroy(asteroidsCollection)
  end
  for k, power in pairs(powerupsCollection) do
    power:destroy(powerupsCollection)
  end
  for k, bullet in pairs(bulletsCollection) do
    bullet:destroy(bulletsCollection)
  end
  for k, explosion in pairs(explosionsCollection) do
    explosion:destroy(explosionsCollection)
  end
  nilSpaceShip = false
  game.activeState = game.states[1]

end