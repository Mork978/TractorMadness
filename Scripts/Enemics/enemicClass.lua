
dofile('Scripts/Enemics/vacaClass.lua')

enemicClass = {
  new = function(self, x, y,name)

    local enemic = {}

    if name == "vaca" then
      enemic = vacaClass:new(x, y)
      --[[
    elseif
      enemic =
      ]]
    end

    enemic.speed = 150
    enemic.colider = rectangleClass:new(x, y, enemic.imageFile:getWidth(), enemic.imageFile:getHeight())
    return enemic;
  end
}
