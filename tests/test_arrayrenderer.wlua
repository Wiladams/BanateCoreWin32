-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;


-- test_pixelbuffer_gl.lua
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

local window = FixedArray2D(captureWidth, captureHeight, "pixel_BGRA_b")
local graphPort = ArrayRenderer(window)


local sw = StopWatch()


function bitnum(value)
	if value then return 1 else return 0 end
end

function createCheckerboard(width, height, pixeltype)
	pixeltype = pixeltype or "pixel_BGRA_b"

	local pattern = FixedArray2D(width, height, pixeltype)
	for i=0,height-1 do
		for j=0,width-1 do
			local c = (bitnum((band(i,0x8)==0))^bitnum((band(j,0x8)==0)))*255;
			local color = PixelBGRA(c,c,c,255)
			pattern:SetElement(j, i, color)
		end
	end

	return pattern
end

local checker = createCheckerboard(64,64)

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

function getRandomPoint(graphPort, x, y, size)
	local x1 = math.random(x-size/2, x+size/2)
	local y1 = math.random(y-size/2, y+size/2)

	if x1 < 0 then x1 = 0 end
	if y1 < 0 then y1 = 0 end

	if x1>graphPort.Width-1 then x1 = graphPort.Width-1 end
	if y1 > graphPort.Height-1 then y1 = graphPort.Height-1 end

	return x1, y1
end

function randomlineH(graphPort, size)
	size = size or 16
	local x1 = math.random(0,graphPort.Width-1)
	local y1 = math.random(0, graphPort.Height-1)

	local remaining = graphPort.Width-x1
	local len = math.random(1,size)
	len = math.min(remaining, len)

	local r,g,b = randomColor()
	local pixel = PixelBGRA(b,g,r,255)

	graphPort:LineH(x1, y1, len, pixel)
end

function randomlineV(graphPort)
	size = size or 16
	local x1 = math.random(0,graphPort.Width-1)
	local y1 = math.random(0, graphPort.Height-1)

	local remaining = graphPort.Height-y1
	local len = math.random(1,size)
	len = math.min(remaining, len)

	local r,g,b = randomColor()
	local pixel = PixelBGRA(b,g,r,255)

	graphPort:LineV(x1, y1, len, pixel)
end

function randomline(graphPort)
	local x1 = math.random(0,graphPort.Width-1)
	local y1 = math.random(0, graphPort.Height-1)

	local x2 = math.random(0,graphPort.Width-1)
	local y2 = math.random(0, graphPort.Height-1)

	local r,g,b = randomColor()
	local value = PixelBGRA(b,g,r,255)

	graphPort:Line(x1, y1, x2, y2, value)
end

function randomrect(graphPort, size)
	size = size or 16
	local width = math.random(2,size)
	local height = math.random(2,size)
	local x = math.random(0,graphPort.Width-1-width)
	local y = math.random(0, graphPort.Height-1-height)
	local right = x + width
	local bottom = y + height

	local r,g,b = randomColor()
	local color = PixelBGRA(b,g,r,255)

	graphPort:FillRectangle(x,y,width, height, color)
end


function randomtriangle(graphPort, size)
	size = size or 16

	local x = math.random(0, graphPort.Width-1)
	local y = math.random(0, graphPort.Height-1)

	local x1, y1 = getRandomPoint(graphPort, x, y, size)
	local x2, y2 = getRandomPoint(graphPort, x, y, size)
	local x3, y3 = getRandomPoint(graphPort, x, y, size)

	local r,g,b = randomColor()
	local color = PixelBGRA(b,g,r,255)

	graphPort:FillTriangle(x1, y1, x2, y2, x3, y3, color)
end

function randomquad(graphPort)
	local size = 100
	local x = math.random(0, graphPort.Width-1)
	local y = math.random(0, graphPort.Height-1)

	local x1, y1 = getRandomPoint(graphPort, x, y, size)
	local x2, y2 = getRandomPoint(graphPort, x, y, size)
	local x3, y3 = getRandomPoint(graphPort, x, y, size)
	local x4, y4 = getRandomPoint(graphPort, x, y, size)

	local r,g,b = randomColor()
	local color = PixelBGRA(b,g,r,255)

--print(x1,y1, x2,y2, x3,y3, x4,y4)
	graphPort:FillQuad(x1,y1, x2,y2, x3,y3, x4,y4, color)
end

function drawImage(appwin, graphPort, tickCount)

	-- start with white background
	if tickCount and (tickCount % appwin.FrameRate) == 0 then
		graphPort:FillRectangle(0,0,graphPort.Width,graphPort.Height, PixelBGRA(255,255,255,255))
	end

--	for i=1,appwin.FrameRate do
	for i=1,1024 do
		randomtriangle(graphPort, 16)
		randomrect(graphPort, 16)
--		randomquad(graphPort)
		randomlineH(graphPort, 16)
--		randomlineV(graphPort, 9)
--		randomline(graphPort)
	end


	graphPort:BitBlt(checker,  10, 10)

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

	screenTexture:CopyPixelBuffer(window)

	local winWidth, winHeight = win:GetClientSize()

	BeginRender(winWidth, winHeight)
	SetupCamera(winWidth, winHeight)

	screenTexture:Render(0,0,winWidth, winHeight)

	win:SwapBuffers()

	-- Display Frames Per Second
	--local stats = string.format("Seconds: %f  Frame: %d  FPS: %f", sw:Seconds(), tickCount, tickCount/sw:Seconds())
	--win.GDIContext:Text(stats)
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

	drawImage(appwin, graphPort, 0)

	if not screenTexture then
		-- Create texture object once the GL Context
		-- is attached
		screenTexture = Texture(window)
	end

	local black = RGB(0,0,0)
	appwin.GDIContext:SetDCPenColor(black)

end

local function main()

	local appwin = GameWindow({
		OnTickDelegate = ontick,
		FrameRate = 30,
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




