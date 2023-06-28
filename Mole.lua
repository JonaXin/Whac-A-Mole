Mole = Class{}

MOLE_WIDTH = 50
MOLE_HEIGHT = 40

local holes = {

		 {212, 246}, {448, 246}, {686, 246},  --222, 220    458, 220	  696, 220

		 {65, 326}, {326, 326}, {588, 326}, {828, 326},  --75, 300    336, 300	 598, 300    838, 300

		 {116, 416}, {440, 416}, {758, 416}  --126, 390	   450, 390    768, 390

		}

function Mole:init()
	self.image = love.graphics.newImage('mole.png')
	self.x = -999  --999: a hacky way to make the mole disappeared
    self.y = -999
    self.timer = 0

	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

end

--function that determines if the mole is hit or not
function Mole:banged(cursor_x, cursor_y)
	if (cursor_x - 25 < self.x and self.x < cursor_x + 25 and
		cursor_y - 20 < self.y and self.y < cursor_y + 20) then
		sounds['explosion']:play()
		return true
	end
end

--return true if the mole is currently on the screen
function Mole:popped()
	return (not(self.x == -999) and not(self.y == -999))
end

function Mole:update(dt, disappear)

    self.timer = self.timer + dt
	if not(disappear) then
		sounds['emerge']:play()
		randomHole = (love.math.random(17, 100) * 17) % 10 + 1
		self.x = holes[randomHole][1]
		self.y = holes[randomHole][2]
	else
		self.x = -999
		self.y = -999
	end
end


function Mole:render()
    love.graphics.draw(self.image, self.x, self.y)
end
