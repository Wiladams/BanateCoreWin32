-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;

--[[
	References on Mandelbrot
	http://jakebakermaths.org.uk/maths/mandelbrot/canvasmandelbrotv12.html

--]]

local BC = require "BanateCore"

local gl = require( "gl" )
local wgl = ffi.load("opengl32")

require "GLTexture"
require "win_gdi32"
require "win_user32"
require "win_opengl32"

require "GameWindow"
require "Color"

local captureWidth = 640
local captureHeight = 480

local windowWidth = 640
local windowHeight = 480
local screenTexture = nil


local window = Array2D(captureWidth, captureHeight, "pixel_BGRA_b")

local sw = StopWatch()

class.complex()

function complex:_init(x,y)
	self.x = x
	self.y = y
end

function complex:square()
	return complex(self.x*self.x - self.y*self.y, 2*self.x*self.y)
end

function createPalette()
	local colors = {}
	for i=1,256 do
		local R,G,B = getColorFromWaveLength(380.0 + (400 * (i / 256)), 0.8)
		local p = PixelBGRA(R,G,B, 255)

		table.insert(colors, p)
	end

	return colors
end

local palette = createPalette()

function iterate(zinit, maxiter)
	local z = complex(zinit.x, zinit.y)
	local cnt = 0

	while ((z.x*z.x + z.y*z.y <= 4.0) and (cnt < maxiter)) do
		z = z.square(z)
		z.x = z.x + zinit.x;
		z.y = z.y + zinit.y;
		cnt = cnt + 1
	end
	return cnt
end

function mandelbrot(xwmin, ywmin, nx, ny, maxiter, realmin, realmax, imagmin, imagmax)
	local realinc = (realmax - realmin)/nx
	local imaginc = (imagmax - imagmin) / ny
	local z = complex()
	local x=0;
	local ywmin=0
	local clr=0
	local cnt=0

	z.x = realmin
	for x=0,nx-1 do
		z.y = imagmin
		for y=0,ny-1 do
			cnt = iterate(z, maxiter)
			if cnt == maxiter then
				clr = 0;
			else
				clr = cnt
			end
			local pixel = palette[clr+1]
			window[ywmin+y][xwmin+x] =  pixel
			z.y = z.y + imaginc
		end
		z.x = z.x + realinc
	end
end

function drawImage(appwin, graphPort, tickCount)
	local nx = 0
	local ny = 0
	local maxiter = 256		-- Number of iterations

	--local realmin = -2.25; realmax = 0.75	-- Major portion of fractal
	--local imagmin = -1.25; imagmax = 1.25	-- Real and imaginary part

	--local realmin = -0.811717; realmax = -0.725850	-- Major portion of fractal
	--local imagmin = -0.084586; imagmax = 0.159774	-- Real and imaginary part

	local realmin = -0.776080; realmax = -0.771164	-- Major portion of fractal
	local imagmin = 0.122275; imagmax = 0.126609	-- Real and imaginary part

	--local realmin = -0.782403; realmax = -0.781972	-- Major portion of fractal
	--local imagmin = 0.148035; imagmax = 0.148446	-- Real and imaginary part

	local xwmin =0; ywmin = 0;
	local xwmax = captureWidth - xwmin; ywmax = captureHeight-ywmin;

	local nx = xwmax - xwmin; ny = ywmax-ywmin;

	mandelbrot(xwmin, ywmin, nx, ny, maxiter, realmin, realmax, imagmin, imagmax);
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
	gl.glClear(gl.GL_COLOR_BUFFER_BIT)
end


function ontick(win, tickCount)

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

	local r = screencolor[1]
	local g = screencolor[2]
	local b = screencolor[3]
	local a = screencolor[4]

	gl.glClearColor(r, g, b, a)

	screenTexture = GLTexture.Create(captureWidth, captureHeight)

	local black = RGB(0,0,0)
	appwin.GDIContext:SetDCPenColor(black)

	-- These can go into ontick()
	-- if the render speed is fast enough
	drawImage(win, graphPort, tickCount)
	screenTexture:CopyPixelData(captureWidth, captureHeight, window, gl.GL_BGRA)
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




