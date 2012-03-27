-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

-- test_pixelbuffer_gl.lua
local ffi   = require( "ffi" )
local C = ffi.C
local gl = require( "gl" )

local wgl = ffi.load("opengl32")

require "GLTexture"
require "win_gdi32"
require "win_user32"
require "win_opengl32"

require "GameWindow"

require "BanateCore"




local captureWidth = 512
local captureHeight = 256


local pixelBuffer = FixedArray2D(captureWidth, captureHeight, "pixel_RGBA_b")

local pixelAccessor = Array2DAccessor({
	TypeName = "Ppixel_RGBA_b",
	Width = captureWidth,
	Height = captureHeight,
	Data = pixelBuffer.Data,
	BytesPerElement= 4,
	})

local graphPort = ArrayRenderer(pixelBuffer)



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

	for i=0,graphPort.Height-1,8 do
		graphPort:LineH(0, i, graphPort.Width-1, randomcolor())
	end

	---[[
	for i=0,10000 do
		local rcolor = randomcolor()
		local x = math.random(0,pixelAccessor.Width-1)
		local y = math.random(0,pixelAccessor.Height-1)

		graphPort:SetPixel(x,y,rcolor)
	end
	--]]
end

function createTexture(pixelAccessor)
	graphPort = ArrayRenderer(pixelAccessor)
	local red = PixelRGBA(255,0,0,255)


	-- Vertical lines
	for i=0,pixelAccessor.Width-1,8 do
		graphPort:LineV(i, 0, pixelAccessor.Height-1, randomcolor())
	end

	for i=0,pixelAccessor.Height-1,8 do
		graphPort:LineH(0, i, pixelAccessor.Width-1, randomcolor())
	end

	for i=0,10000 do
		local rcolor = randomcolor()
		local x = math.random(0,pixelAccessor.Width-1)
		local y = math.random(0,pixelAccessor.Height-1)

		graphPort:SetPixel(x,y,rcolor)
	end

	screenTexture = Texture(pixelAccessor)
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
	screenTexture:CopyPixelBuffer(pixelAccessor)

	local winWidth, winHeight = win:GetClientSize()

	BeginRender(winWidth, winHeight)
	SetupCamera(winWidth, winHeight)

	screenTexture:Render()

	--gl.glRasterPos2i (10, 10)
	--gl.glDrawPixels (captureWidth, captureHeight, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, pixelAccessor.Data);

	--StretchBlt(win.GDIContext.Handle, pixelAccessor)

	win:SwapBuffers()
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


	-- setup blending mode
	gl.glEnable( gl.GL_BLEND )
	gl.glBlendFunc( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA )
	gl.glDisable( gl.GL_CULL_FACE)


	createTexture(pixelAccessor);

	-- run the application
	appwin:Run()
end

main()




