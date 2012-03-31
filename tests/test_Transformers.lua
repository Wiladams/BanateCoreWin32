-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;


local BC = require "BanateCore"

local gl = require( "gl" )
local wgl = ffi.load("opengl32")

require "GLTexture"
require "win_gdi32"
require "win_user32"
require "win_opengl32"

require "GameWindow"

local captureWidth = 640
local captureHeight = 480

local windowWidth = 640
local windowHeight = 480
local screenTexture = nil

local window = Array2D(captureWidth, captureHeight,  "pixel_BGRA_b")
local graphPort = Array2DRenderer.Create(captureWidth, captureHeight, window, "pixel_BGRA_b")

local vpt0 = ViewportTransform(captureWidth, captureHeight)
local vpt1 = ViewportTransform(captureWidth/2, captureHeight/2, 0,0)
local vpt2 = ViewportTransform(captureWidth/2, captureHeight/2, captureWidth/2, 0)
local vpt3 = ViewportTransform(captureWidth/2, captureHeight/2, captureWidth/2, captureHeight/2)
local vpt4 = ViewportTransform(captureWidth/2, captureHeight/2, 0, captureHeight/2)


local sw = StopWatch()



function randomBGRA()
	return PixelBGRA(math.random(0,255), math.random(0,255), math.random(0,255), 255)
end

function drawTriangle(vpt, graphPort, v1, v2, v3, pixel)
	local v11 = vpt:Transform(v1)
	local v21 = vpt:Transform(v2)
	local v31 = vpt:Transform(v3)

	graphPort:FillTriangle(
		v11[0], v11[1],
		v21[0], v21[1],
		v31[0], v31[1],
		randomBGRA())

	graphPort:Line(v11[0], v11[1], v21[0],v21[1], pixel)
	graphPort:Line(v21[0], v21[1], v31[0],v31[1], pixel)
	graphPort:Line(v31[0], v31[1], v11[0],v11[1], pixel)

end

function drawLine(vpt, graphPort, v1, v2, pixel)
	local v11 = vpt:Transform(v1)
	local v21 = vpt:Transform(v2)

	graphPort:Line(v11[0], v11[1], v21[0],v21[1], pixel)
end

function drawImage(vpt, graphPort, tickCount)

	-- start with white background
	--if tickCount and (tickCount % appwin.FrameRate) == 0 then
	--	graphPort:FillRectangle(0,0,graphPort.Width,graphPort.Height, PixelBGRA(0,0,0,255))
	--end

	drawLine(vpt, graphPort, vec3(0,1,0), vec3(0,-1,0), PixelBGRA(255,255,255,255))
	drawLine(vpt, graphPort, vec3(-1,0,0), vec3(1,0,0), PixelBGRA(255,255,255,255))

	local v1 = vec3(0,0.75,0)
	local v2 = vec3(-0.75, -0.25, 0)
	local v3 = vec3(0.75, -0.25, 0)

	drawTriangle(vpt, graphPort, v1, v2, v3, randomBGRA())
end

function drawFrame(appwin, graphPort, tickCount)
	--drawImage(vpt0, graphPort, tickCount)

	drawImage(vpt1, graphPort, tickCount)
	drawImage(vpt2, graphPort, tickCount)
	drawImage(vpt3, graphPort, tickCount)
	drawImage(vpt4, graphPort, tickCount)
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
	drawFrame(win, graphPort, tickCount)

	screenTexture:CopyPixelData(captureWidth, captureHeight, window, gl.GL_BGRA)

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


	screenTexture = GLTexture.Create(captureWidth, captureHeight)


	local black = RGB(0,0,0)
	appwin.GDIContext:SetDCPenColor(black)

end

local function main()

	local appwin = GameWindow({
		Title = "Test Transformers",
		OnTickDelegate = ontick,
		FrameRate = 15,
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




