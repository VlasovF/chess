local Unit = require "lib/Unit"
local Pawn = Unit:extend()

function Pawn.new(self)
	Pawn.super.new(self)
	self.speed = 2
	self.width = 32
	self.height = 32
end

function Pawn.toText(self)
	return "Pawn"
end

function Pawn.draw(self, x, y)	
	if self.status == 'move' then
		love.graphics.polygon("fill", 
		self.move_vars.y + self.width/2, self.move_vars.x,
		self.move_vars.y + self.width, self.move_vars.x + self.height,
		self.move_vars.y, self.move_vars.x + self.height)	
	elseif self.status == 'none' then
		love.graphics.polygon("fill", 
		x + self.width/2, y,
		x + self.width, y + self.height,
		x, y + self.height)
	end
end

return Pawn