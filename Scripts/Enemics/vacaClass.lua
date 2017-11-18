vacaClass = {
  new = function(self, x, y)

    local enemic = {}

    --Properties
    enemic.imageFilename = "Textures/placeholder.jpg"
    enemic.imageFile = love.graphics.newImage(enemic.imageFilename)
    enemic.pos = {x = x, y = y}
    enemic.offset = {
      x = enemic.imageFile:getWidth() / 2,
      y = enemic.imageFile:getHeight() / 2
    }
    enemic.forwardVec = {x = 0, y = -1}
    enemic.speed = 0
    --Methods
    enemic.draw = self.draw
    enemic.move = self.move
    return enemic;
  end,
  draw = function(self)
    love.graphics.draw(self.imageFile,
                        self.pos.x - self.offset.x,
                        self.pos.y - self.offset.y)
  end,
  move = function(self, pos, w, h, dt)
    vector2 = {
      x = pos.x - self.pos.x,
      y = pos.y - self.pos.y
    }
    module = math.sqrt(math.pow(vector2.x, 2) + math.pow(vector2.y, 2))
    vector2.x = vector2.x / module
    vector2.y = vector2.y / module
    self.forwardVec = vector2
    self.pos.x = self.pos.x + self.forwardVec.x * self.speed * dt
    self.pos.y = self.pos.y + self.forwardVec.y * self.speed * dt

    self.pos.x = clamp(self.pos.x, self.offset.x, w - self.offset.x) -- We clamp x values according to window dimensions
    self.pos.y = clamp(self.pos.y, self.offset.y, h - self.offset.y) -- We clamp y values according to window dimensions
  end
}
