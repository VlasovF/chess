local Object = require "lib/classic"
local Map = Object:extend()

local function tiles_init(n, m)
	local tiles = {}
	for i = 1,n do
		tiles[i] = {}
		for j = 1,m do
			tiles[i][j] = {}
			tiles[i][j]["ground"] = "default"
			tiles[i][j]["on_ground"] = nil
		end
	end
	return tiles
end

function Map.new(self, n, m, cell_xy)
	self.tiles = tiles_init(n, m)
	self.n = n
	self.m = m
	self.cell_xy = cell_xy
end

function Map.addUnit(self, unit, x, y)
   if self.tiles[x][y]["on_ground"] == nil then
   		unit.map = self
   		unit.tile_x = x
   		unit.tile_y = y
   		self.tiles[x][y]["on_ground"] = unit
   		return true
   end
   return false
end

function Map.isOnGround(self, tile_x, tile_y)
	if self.tiles[tile_x][tile_y]["on_ground"] ~= nil then
		return true
	end
	return false
end


function Map.moveUnit(self, unit, x, y)
	if not self.tiles[x][y]["on_ground"] then
		self.tiles[x][y]["on_ground"] = unit
		self.tiles[unit.tile_x][unit.tile_y]["on_ground"] = nil
		unit.tile_x = x
   		unit.tile_y = y   		
   		return true
	end
	return false	
end

return Map