
dofile('Scripts/tractor.lua')
dofile('Scripts/auxFunctions.lua')
dofile('Scripts/auxClasses.lua')
dofile('Scripts/updateFunctions.lua')
dofile('Scripts/drawFunctions.lua')

local gameIniParameters = dofile('tractor.ini') -- Load game ini parameters from ini file
local tractor
local w, h -- Global (local chunk) variables for window dimensions


local game = {} -- Empty table for Game object
game.states = { 'moving', 'paused', 'over' } -- Game state possible values
game.activeState = 'moving' -- Default game state

local gameEvent -- Game events variable


function updateGameStates(gameEvent)


end

function love.load()
  w, h = love.graphics.getDimensions() -- Sets w,h to window dimensions
  tractor = tractorClass:new(w/2, h/2)


end



function love.update(dt)
  tractor:move(w, h,dt)
end


function love.draw()
  tractor:draw()

end
