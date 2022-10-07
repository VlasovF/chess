local Object = require "lib/classic"
local Unit = Object:extend()

function Unit.new(self)
	self.speed = 9999
	self.actions = {}
	self.actions["move"] = self.move
	self.actions["attack"]	= self.attack
	self.map = nil
	self.tile_x = 0
	self.tile_y = 0
	self.width = 0
	self.height = 0
	self.status = 'none'
	self.move_vars = {}
end

function Unit.move(self, goal_tile_x, goal_tile_y)
	if self.map:isOnGround(goal_tile_x, goal_tile_y) then
		return false
	end

	self.status = 'move'
	local SPEED = 200

    self.move_vars.goal_x = (goal_tile_x-1) * self.map.cell_xy
    self.move_vars.goal_y = (goal_tile_y-1) * self.map.cell_xy

	self.move_vars.start_x = (self.tile_x-1) * self.map.cell_xy
	self.move_vars.start_y = (self.tile_y-1) * self.map.cell_xy

	self.move_vars.x = self.move_vars.start_x
	self.move_vars.y = self.move_vars.start_y

	self.move_vars.goal_tile_x = goal_tile_x
	self.move_vars.goal_tile_y = goal_tile_y


	local dx = self.move_vars.goal_x - self.move_vars.start_x
	local dy = self.move_vars.goal_y - self.move_vars.start_y

	self.move_vars.r2 = dx^2 + dy^2
	-- print('r2: ' .. self.move_vars.r2)
	if self.move_vars.r2 == 0 then 
		self.status = 'none'
		return false 
	end
	self.move_vars.vx = dx/math.sqrt(self.move_vars.r2) * SPEED
	self.move_vars.vy = dy/math.sqrt(self.move_vars.r2) * SPEED
	return true
end

function Unit.attack(self)
	print("attack")
end

function Unit.update(self, dt)
	if self.status == 'move' then
		if not self.moveUpdate(self, dt) then
			self.map:moveUnit(self, self.move_vars.goal_tile_x, self.move_vars.goal_tile_y)
			self.status = 'none'
		end
	end
end

function Unit.draw(self, x, y)
	if self.status == 'move' then	
	end	
end

function Unit.moveUpdate(self, dt)
	self.move_vars.x = self.move_vars.x + self.move_vars.vx*dt
	self.move_vars.y = self.move_vars.y + self.move_vars.vy*dt
	-- stop condition
	local current_r2 = (self.move_vars.x - self.move_vars.start_x)^2 + 
		(self.move_vars.y - self.move_vars.start_y)^2
	if current_r2 > self.move_vars.r2 then
		return false
	end
	return true
end

return Unit