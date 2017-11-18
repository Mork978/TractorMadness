tractorClass = {

  new = function(self, x, y) -- This function creates and returns a new tractor object, as an instance of tractor

    local tractor = {}

    -- Properties
    tractor.imageFilename = "Textures/placeholder.jpg"
    tractor.imageFile = love.graphics.newImage(tractor.imageFilename)
    tractor.pos = {x = x, y = y}
    tractor.offset = {x = tractor.imageFile:getWidth() / 2, y = tractor.imageFile:getHeight() / 2}
    tractor.forwardVec = {x = 0, y = 1}
    -- Methods
    tractor.draw = self.draw
    tractor.move = self.move
    return tractor
  end,

  draw = function(self)
    love.graphics.draw(self.imageFile, self.pos.x - self.offset.x, self.pos.y - self.offset.y)
  end,

  move = function(self, w, h, dt) -- This function moves tractor object in window, by its position (x, y)

    local moveDirections = {
      right = {x = 1, y = 0},
      left = {x = -1, y = 0},
      up = {x = 0, y = -1},
      down = {x = 0, y = 1}
    }
    for direction, forwardVec in pairs (moveDirections) do
      if love.keyboard.isDown(direction) then
        self.forwardVec = forwardVec
        self.pos.x = self.pos.x + self.forwardVec.x *300* dt
        self.pos.y = self.pos.y + self.forwardVec.y *300* dt

        self.pos.x = clamp(self.pos.x, self.offset.x, w - self.offset.x) -- We clamp x values according to window dimensions
        self.pos.y = clamp(self.pos.y, self.offset.y, h - self.offset.y) -- We clamp y values according to window dimensions
      end
    end
  end


}
