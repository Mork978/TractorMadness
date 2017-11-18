
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

    return enemic;
  end
}
