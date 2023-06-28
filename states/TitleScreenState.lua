TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    -- nothing
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
	love.graphics.setColor(love.math.colorFromBytes(128, 234, 255))

    love.graphics.setFont(largeFont)
    love.graphics.printf('Whac A Mole!', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Press Enter', 0, 200, VIRTUAL_WIDTH, 'center')
end
