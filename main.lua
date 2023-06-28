-- virtual resolution handling library
push = require 'push'
Class = require 'class'
require 'Mole'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

-- physical screen dimensions
WINDOW_WIDTH = 920
WINDOW_HEIGHT = 518

-- virtual resolution dimensions
VIRTUAL_WIDTH = 920
VIRTUAL_HEIGHT = 518

-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('background.png')
local audio_paused = false

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

	math.randomseed(os.time())
	cursor = love.mouse.newCursor('mallet.png', 0, 0)
    -- app window title
    love.window.setTitle('Whac-A-Mole')

	smallFont = love.graphics.newFont('flappy.ttf', 26)
	flappyFont = love.graphics.newFont('flappy.ttf', 40)
	largeFont = love.graphics.newFont('flappy.ttf', 56)
	love.graphics.setFont(flappyFont)

    sounds = {
        ['emerge'] = love.audio.newSource('emerge.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('bgm.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()
	love.audio.setVolume(0.15)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title') --title

	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

	if key == 'p' then
		if audio_paused then
			love.audio.setVolume(0.15)
			audio_paused = false
		else
			love.audio.setVolume(0.0)
			audio_paused = true
		end
	end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, 0, 0)
    gStateMachine:render()

    push:finish()
end
