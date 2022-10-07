local Pawn = require "lib/Pawn"
local Horse = require "lib/Horse"
local Map = require "lib/Map"
local MapView = require "lib/MapView"

local n = 8
local m = 8
local CELL_XY = 64
local map = Map(n, m, CELL_XY)
local map_view = MapView(map)

local infowidth = CELL_XY*2
local queue_height = CELL_XY*2
local active_cell = {1, 1}
local queue = {} 
local queue_index = 1
local current_action_key = nil
local color = {
	green = {100, 255, 100, 255},
	cursor = {100, 100, 255},
}

local IDLE = 1111
local PROCESS = 2222

local state = IDLE

function love.load()
	love.graphics.setBackgroundColor(30, 30, 30, 255)
	loadObjects()
	installQueue()
end

function love.update(dt)
	map_view:update(dt)
end

function love.draw()
	local current_object = queue[queue_index]
	map_view:draw()
	love.graphics.rectangle("line", 
				m*CELL_XY, 0, infowidth, n*CELL_XY)
	love.graphics.rectangle("line", 
				0, n*CELL_XY, m*CELL_XY + infowidth, queue_height)	
	-- current unit frame
	love.graphics.setColor(color.green)
	love.graphics.rectangle("line", 
				(current_object.tile_y-1)*CELL_XY,
				(current_object.tile_x-1)*CELL_XY, 
				CELL_XY, CELL_XY)
	-- cursor frame
	love.graphics.setColor(color.cursor)
	love.graphics.rectangle("line", 
				(active_cell[2]-1)*CELL_XY, (active_cell[1]-1)*CELL_XY, 
				CELL_XY, CELL_XY)

	for i=1,#queue do
		love.graphics.setColor(150, 100, 100, 255)
		if i == queue_index then
			love.graphics.setColor(color.green)
		end
		love.graphics.print(queue[i]:toText(), (i-1)*CELL_XY, n*CELL_XY)
	end

	if queue_index <= #queue then
		
		local i = 1
		for k, v in pairs(queue[queue_index].actions) do
			love.graphics.setColor(150, 100, 100, 255)
			if k == current_action_key then
				love.graphics.setColor(color.green)
			end

			love.graphics.print(k, n*CELL_XY, (i-1)*CELL_XY)
			i = i + 1
		end
	end
	
end

function love.keypressed(key)
	if key == "up" and active_cell[1] > 1 then
		active_cell[1] = active_cell[1] - 1
	elseif key == "left" and active_cell[2] > 1 then
		active_cell[2] = active_cell[2] - 1
	elseif key == "right" and active_cell[2] < m then
		active_cell[2] = active_cell[2] + 1
	elseif key == "down" and active_cell[1] < n then
		active_cell[1] = active_cell[1] + 1
	
	elseif key == "return" then
		action()
	elseif key == "tab" then
		changeCurrentAction()

	elseif key == "escape" then	
		love.event.quit()
	end
end

function action()	
	local current_object = queue[queue_index]
	local current_action = current_object.actions[current_action_key]
	local goal_x = active_cell[1]
	local goal_y = active_cell[2]

	if current_action_key == 'move' then
		print('goal_x, goal_y: ' .. goal_x .. ' ' .. goal_y)

		map_view:moveUnit(current_object, goal_x, goal_y)		
		current_action(current_object, goal_x, goal_y)
	end

	queue_next()
end

function changeCurrentAction()
	local check = false
	for k, v in pairs(queue[queue_index].actions) do
		if check == true then
			current_action_key = k
			check = false
			break
		end

		if current_action_key == k then
			check = true
		end		
	end	

	if check == true then
		for k, v in pairs(queue[queue_index].actions) do
			current_action_key = k
			break
		end
	end
end

function queue_next()
	queue_index = queue_index + 1
	if queue_index <= #queue then
	else
		queue_index = 1
	end
	for k, v in pairs(queue[queue_index].actions) do
		current_action_key = k
		break
	end
end


function loadObjects()
	map.addUnit(map, Pawn(), 2, 2)
	map.addUnit(map, Pawn(), 3, 5)
	map.addUnit(map, Horse(), 5, 5)
end

function installQueue()
	local objects = {}
	for i = 1,n do
		for j = 1,m do
			if map.tiles[i][j]["on_ground"] ~= nil then
				table.insert(objects, map.tiles[i][j]["on_ground"])
			end
		end
	end
	table.sort(objects, compareSpeed)
	queue = objects
	for k, v in pairs(queue[queue_index].actions) do
		current_action_key = k
		break
	end
end

function compareSpeed(a, b)
	if a.speed < b.speed then
		return true
	end
	return false
end

