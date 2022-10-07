local Unit = require "lib/Unit"
local Horse = Unit:extend()

function Horse.new(self)
	Horse.super.new(self)
	self.speed = 1
	self.width = 32
	self.height = 32
end

function Horse.toText(self)
	return "Horse"
end

function Horse.draw(self, x, y)
	if self.status == 'move' then
		love.graphics.rectangle("fill", 
		self.move_vars.y + self.height, self.move_vars.x + self.width, self.width, self.height)
	elseif self.status == 'none' then
		love.graphics.rectangle("fill", 
		x + self.width, y + self.height, self.width, self.height)
	end
end

return Horse