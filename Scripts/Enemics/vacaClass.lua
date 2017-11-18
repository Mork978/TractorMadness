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

    --Methods
    enemic.draw = self.draw()
    enemic.move = self.move()
    return enemic;
  end,
  draw = function(self)
    love.graphics.draw(self.imageFile,
                        self.pos.x - self.offset.x,
                        self.pos.y - self.ofset.y)
  end,
  move = function(self)

  end
}
