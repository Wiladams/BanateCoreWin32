-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\Kinect\\?.lua;'
package.path = ppath;


-- test_pixelbuffer_gl.lua
local BC = require "BanateCore"

local gl = require( "gl" )

require "GLTexture"
require "win_gdi32"
require "win_user32"
require "win_opengl32"

require "GameWindow"
require "Kinect"


local captureWidth = 640
local captureHeight = 480

local windowWidth = 640
local windowHeight = 480

local window = FixedArray2D(captureWidth, captureHeight, "pixel_BGRA_b")
local graphPort = ArrayRenderer(window)

local screenTexture = nil

local sw = StopWatch()


-- Create the Kinect sensor
local sensor0 = Kinect(0, NUI_INITIALIZE_FLAG_USES_COLOR)


function drawImage(appwin, graphPort, tickCount)
	-- Get the current video frame
	local success = sensor0:GetCurrentColorFrame()

	-- If we successfully got a frame, then copy
	-- the bits to our texture object
	if success then
--[[
		print("Locked Rect: ", sensor0.LockedRect)
		print("Pitch: ", sensor0.LockedRect.Pitch)
		print("Size: ", sensor0.LockedRect.size)
		print("Bits: ", sensor0.LockedRect.pBits)
--]]
---[[
		local colorAccessor = Array2DAccessor({
			TypeName = "Ppixel_BGRA_b",
			Width = captureWidth,
			Height = captureHeight,
			Data = sensor0.LockedRect.pBits,
			BytesPerElement= 4,
			Alignment = 1,
		})

		screenTexture:CopyPixelBuffer(colorAccessor)
--]]
	end

	sensor0:ReleaseCurrentColorFrame()
end

function SetupCamera(sw, sh)
	gl.glMatrixMode(gl.GL_PROJECTION)
	gl.glLoadIdentity()

	gl.glMatrixMode( gl.GL_MODELVIEW )
	gl.glLoadIdentity()
	gl.glOrtho(0, sw, sh, 0, -1, 1 )
end


local screencolor = {0.75,1,1,1}

function BeginRender(sw, sh)
	gl.glViewport(0, 0, sw, sh)
	local r = screencolor[1]
	local g = screencolor[2]
	local b = screencolor[3]
	local a = screencolor[4]

	gl.glClearColor(r, g, b, a)
	gl.glClear(gl.GL_COLOR_BUFFER_BIT)
end


function ontick(win, tickCount)
	drawImage(win, graphPort, tickCount)


	local winWidth, winHeight = win:GetClientSize()

	BeginRender(winWidth, winHeight)
	SetupCamera(winWidth, winHeight)

	screenTexture:Render(0,0,winWidth, winHeight)

	win:SwapBuffers()
end


local function setup(appwin)
	-- setup blending mode
	gl.glEnable( gl.GL_BLEND )
	gl.glBlendFunc( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA )
	gl.glDisable( gl.GL_CULL_FACE)

	screenTexture = Texture(window)
end

local function main()

	local appwin = GameWindow({
		Title = "Kinect Color Viewer",
		OnTickDelegate = ontick,
		FrameRate = 1,
		Extent = {windowWidth, windowHeight},
		})

	assert(appwin, "unable to create game window")

	-- To ensure GLContext is active
	appwin:Show()
	appwin.GLContext:Attach()

	setup(appwin)

	-- run the application
	appwin:Run()
end

main()




