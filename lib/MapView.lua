local Object = require "lib/classic"
local MapView = Object:extend()

function MapView.new(self, map)
	self.map = map
	self.cell_xy = map.cell_xy
end

function MapView.update(self, dt)
	local n = self.map.n
	local m = self.map.m	
	local map = self.map
	for i = 1,n do
		for j = 1,m do			
			if map.tiles[i][j]["on_ground"] ~= nil then
				map.tiles[i][j]["on_ground"]:update(dt)
			end
		end
	end	
end

function MapView.draw(self)
	local n = self.map.n
	local m = self.map.m
	local cell_xy = self.cell_xy
	local map = self.map

	love.graphics.setColor(150, 100, 100, 255)

	for i = 1,n do
		for j = 1,m do
			love.graphics.setColor(150, 100, 100, 255)
			love.graphics.rectangle("line", 
				(j-1)*cell_xy, (i-1)*cell_xy, cell_xy, cell_xy)
			if map.tiles[i][j]["on_ground"] ~= nil then				
				map.tiles[i][j]["on_ground"]:draw((j-1)*cell_xy, (i-1)*cell_xy)
			end
		end
	end

end

function MapView.moveUnit(self, unit, goal_x, goal_y)
end

return MapView