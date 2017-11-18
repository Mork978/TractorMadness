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

function getDistanceVector(gameObject1, gameObject2)

  return math.abs(gameObject1.pos.x - gameObject2.pos.x), math.abs(gameObject1.pos.y - gameObject2.pos.y)
  
end

function isCollidingRectangle(rectangle1, rectangle2) 
    local distancex, distancey = getDistanceVector(rectangle2, rectangle1)
    if not(rectangle1 == rectangle2) then
      if distancex <= (rectangle2.w + rectangle1.w) * 0.5 and distancey <= (rectangle2.h + rectangle1.h) * 0.5 then return true end
    end
end

function checkCollisions(rectangle, rectanglesCollection)
  
  for k, v in pairs(rectanglesCollection) do
    if isCollidingRectangle(rectangle, v) then return true end
  end
end