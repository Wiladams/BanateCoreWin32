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
require "Pixel"
require "Array2DAccessor"
require "ArrayRenderer"
require "FixedArray2D"


local captureWidth = 640
local captureHeight = 480

local window = FixedArray2D(captureWidth, captureHeight, "pixel_BGRA_b")
--[[
local hbmScreenAccessor = Array2DAccessor({
	TypeName = "Ppixel_BGRA_b",
	Width = captureWidth,
	Height = captureHeight,
	Data = hbmScreen.Pixels,
	BytesPerElement= 4,
	Alignment = 1,
	})
--]]

local screenTexture = nil

function randomColor()
		local r = math.random(0,255)
		local g = math.random(0,255)
		local b = math.random(0,255)
		local color = RGB(r,g,b)
		
	return r,g,b
end

function swap(a,b)
	return b,a
end

function randomline(graphPort)
	local x1 = math.random(0,graphPort.Width-1)
	local y1 = math.random(0, graphPort.Height-1)
	
	local x2 = math.random(0,graphPort.Width-1)
	local y2 = math.random(0, graphPort.Height-1)

	--if x2<x1 then
	--	x1,x2 = swap(x1,x2)
	--	y1,y2 = swap(y1,y2)
	--end
	
	--print(x1,y1,x2,y2)
	
	local r,g,b = randomColor()
	local value = PixelBGRA(b,g,r,255)

	graphPort:Line(x1, y1, x2, y2, value)
end

function randomrect(graphPort)
	local width = math.random(2,40)
	local height = math.random(2,40)
	local x = math.random(0,graphPort.Width-1-width)
	local y = math.random(0, graphPort.Height-1-height)
	local right = x + width
	local bottom = y + height

	local r,g,b = randomColor()
	local color = PixelBGRA(b,g,r,255)

	graphPort:FillRectangle(x,y,width, height, color)
end

function drawImage(appwin, view)
	local graphPort = ArrayRenderer(view)
	
	-- start with white background
	--graphPort:FillRectangle(0,0,graphPort.Width,graphPort.Height, PixelBGRA(255,255,255,255))
	
	for i=1,appwin.FrameRate do
		randomrect(graphPort)
	end
	
	--local black = PixelBGRA(0,0,0,255)
	--graphPort:Line(10, 10, graphPort.Width-1-10, 20, black)

	-- draw some random lines
	for i=1,appwin.FrameRate do
	--for i=1,1 do
		randomline(graphPort)
	end
end


function SetupCamera(sw, sh)
	gl.glMatrixMode(gl.GL_PROJECTION)
	gl.glLoadIdentity()

	gl.glMatrixMode( gl.GL_MODELVIEW )
	gl.glLoadIdentity()
	gl.glOrtho(0, sw, sh, 0, -1, 1 )
end


local screencolor = {1,1,1,1}

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
	drawImage(win, window)

	screenTexture:CopyPixelBuffer(window)

	local winWidth, winHeight = win:GetClientSize()

	BeginRender(winWidth, winHeight)
	SetupCamera(winWidth, winHeight)

	screenTexture:Render(0,0,winWidth, winHeight)

	win:SwapBuffers()
end

local function test_wgl(glctxt)
	local vendor = glctxt:Vendor()
	print("GL Vendor: ", vendor)

	local version= glctxt:Version()
	print("GL Version: ", version)

	local procaddr = wgl.wglGetProcAddress("wglGetExtensionsStringARB")

	print("wglGetExtensionsStringARB address: ", procaddr)

	local formats = C.DescribePixelFormat(glctxt.GDIHandle, 0, 0, nil);
	print("Pixel Formats: ", formats)
end

local function setup(appwin)
	-- setup blending mode
	gl.glEnable( gl.GL_BLEND )
	gl.glBlendFunc( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA )
	gl.glDisable( gl.GL_CULL_FACE)
	
	drawImage(appwin, window)

	if not screenTexture then
		-- Create texture object once the GL Context
		-- is attached
		screenTexture = Texture(window)
	end
end

local function main()

	local appwin = GameWindow({
		OnTickDelegate = ontick,
		FrameRate = 20,
		Extent = {640,480},
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




