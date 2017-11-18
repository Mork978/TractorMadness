tractor = {

  new = function(self, x, y) -- This function creates and returns a new tractor object, as an instance of tractor

    local tractor = {}

    -- Properties
    tractor.imageFilename = "Textures/placeholder.jpg"
    tractor.imageFile = love.graphics.newImage(tractor.imageFilename)
    tractor.x = x
    tractor.y = y
    tractor.offset = {x = tractor.imageFile:getWidth() / 2, y = tractor.imageFile:getHeight() / 2}

    -- Methods
    tractor.draw = self.draw
    return tractor
  end,

  draw = function(self)
    love.graphics.draw(self.imageFile, self.pos.x - self.offset.x, self.pos.y - self.offset.y)
  end
}