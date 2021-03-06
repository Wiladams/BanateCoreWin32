-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;


require "BanateCore"


local gl = require( "gl" )

local wgl = ffi.load("opengl32")

require "GLTexture"
require "win_gdi32"
require "win_user32"
require "win_opengl32"

require "GameWindow"



local captureWidth = 512
local captureHeight = 256


local pixelBuffer = Array2D(captureWidth, captureHeight, "pixel_RGBA_b")
local graphPort = Array2DRenderer.Create(captureWidth, captureHeight, pixelBuffer, "pixel_BGRA_b")

local red = PixelRGBA(255,0,0,255)


local screenTexture = nil

function randomcolor()
	r = math.random(0,255)
	g = math.random(0,255)
	b = math.random(0,255)

	return PixelRGBA(r,g,b,255)
end

function updatepixbuff()
	local red = PixelRGBA(255,0,0,255)


	-- Vertical lines
	for i=0,graphPort.Width-1,8 do
		graphPort:LineV(i, 0, graphPort.Height-1, randomcolor())
	end

	for i=0,graphPort.Height-1,4 do
		graphPort:LineH(0, i, graphPort.Width-1, randomcolor())
	end

	---[[
	for i=0,1000 do
		local rcolor = randomcolor()
		local x = math.random(0,graphPort.Width-1)
		local y = math.random(0,graphPort.Height-1)

		graphPort:SetPixel(x,y,rcolor)
	end
	--]]
end




function SetupCamera(sw, sh)
	gl.glMatrixMode(gl.GL_PROJECTION)
	gl.glLoadIdentity()

	gl.glMatrixMode( gl.GL_MODELVIEW )
	gl.glLoadIdentity()
	gl.glOrtho(0, sw, sh, 0, -1, 1 )
--void glOrtho (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
end


local screencolor = {0,0,0,0}

function BeginRender(sw, sh)
	gl.glViewport(0, 0, sw, sh)
	local r = screencolor[1]
	local g = screencolor[2]
	local b = screencolor[3]
	local a = screencolor[4]

	gl.glClearColor(r, g, b, a)
	gl.glClear(gl.GL_COLOR_BUFFER_BIT)
	gl.glClear(gl.GL_DEPTH_BUFFER_BIT)
end


function ontick(win, tickCount)
	updatepixbuff()

	screenTexture:CopyPixelData(captureWidth, captureHeight, pixelBuffer, gl.GL_BGRA)

	local winWidth, winHeight = win:GetClientSize()

	BeginRender(winWidth, winHeight)
	SetupCamera(winWidth, winHeight)

	screenTexture:Render()

	win:SwapBuffers()
end


local function setup()
	-- setup blending mode
	gl.glEnable( gl.GL_BLEND )
	gl.glBlendFunc( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA )
	gl.glDisable( gl.GL_CULL_FACE)

	screenTexture = GLTexture.Create(captureWidth, captureHeight)
end

local function main()

	local appwin = GameWindow({
		OnTickDelegate = ontick,
		FrameRate = 30,
		Extent = {512,256},
		})

	assert(appwin, "unable to create game window")

	-- To ensure GLContext is active
	appwin:Show()

	setup()

	-- run the application
	appwin:Run()
end

main()




