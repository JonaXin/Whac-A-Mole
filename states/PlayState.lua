PlayState = Class{__includes = BaseState}

local cursor_image = love.graphics.newImage('mallet.png')
local bang_image = love.graphics.newImage('bang.png')

function PlayState:init()
	love.mouse.setVisible(false)
    self.mole = Mole()
    self.timer = 0
    self.score = 0
	self.elapsed = 0
	self.bang = false
end

function PlayState:update(dt)
    -- update timer
    self.timer = self.timer + dt

	if (self.bang and self.timer > 0.3) then
		self.bang = false
	end

	--game over
	if self.elapsed >= 5 then
		gStateMachine:change('score', { score = self.score })
	end

	--check if cursor's current postion can knock the mole
	if love.mouse.isDown(1) then

		love.graphics.draw(cursor_image, love.mouse.getX(), love.mouse.getY(),
			math.rad(320), 1, 1, cursor_image:getWidth(), cursor_image:getHeight())

		if (self.mole:banged(love.mouse.getX()-10, love.mouse.getY()+26)) then
			self.score = self.score + 1
			sounds['score']:play()
			self.timer = 0
			self.bang = true
			self.mole:update(dt, true)
		end
	end

	--if the mole elapsed, increment the count
	if self.timer > 1 then
		if(self.mole:popped()) then
			sounds['hurt']:play()
			self.elapsed = self.elapsed + 1
			self.mole:update(dt, true)
		else
			self.mole:update(dt, false)
		end
		self.timer = 0
	end

end

function PlayState:render()

	self.mole:render()

	if love.mouse.isDown(1) then
		love.graphics.draw(cursor_image, love.mouse.getX() + 64, love.mouse.getY() + 85,
			math.rad(-40), 1, 1, cursor_image:getWidth(), cursor_image:getHeight())

		if self.bang then
			love.graphics.draw(bang_image, love.mouse.getX() - 25, love.mouse.getY() + 75)
		end

	else
		love.graphics.draw(cursor_image, love.mouse.getX(), love.mouse.getY())
	end

    love.graphics.setFont(smallFont)
	love.graphics.setColor(love.math.colorFromBytes(245, 245, 0))
    love.graphics.print(tostring(self.elapsed), 70, 49)
	love.graphics.print(tostring(self.score), 840, 51)

end
