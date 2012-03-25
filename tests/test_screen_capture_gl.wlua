-- Put this at the top of any test
--local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
local ppath = package.path..';..\\?.lua;'
package.path = ppath;


-- test_pixelbuffer_gl.lua
require "BanateCore"


local gl = require( "gl" )

local wgl = ffi.load("opengl32")

require "GLTexture"
require "win_gdi32"
require "win_user32"
require "win_opengl32"

require "GameWindow"

--[[
require "Pixel"
require "Array2DAccessor"
require "ArrayRenderer"
--]]
-- Create a normal DC and a memory DC for the entire screen. The
-- normal DC provides a "snapshot" of the screen contents. The
-- memory DC keeps a copy of this "snapshot" in the associated
-- bitmap.


local scrWidth = 320
local scrHeight = 240

local captureWidth = 1440
local captureHeight = 900

local hbmScreen = GDIDIBSection():Init(captureWidth, captureHeight, 32)
local hbmScreenAccessor = Array2DAccessor({
	TypeName = "Ppixel_BGRA_b",
	Width = captureWidth,
	Height = captureHeight,
	Data = hbmScreen.Pixels,
	BytesPerElement= 4,
	Alignment = 1,
	})

local screenTexture = nil

-- Create device context for screen
local hdcScreen = GDIContext():CreateDC("DISPLAY");


function captureScreen()
-- Copy some of the screen into a
-- bitmap that is selected into a compatible DC.

	C.BitBlt(hbmScreen.hDC.Handle,
		0,0,
		hbmScreen.Width,
		hbmScreen.Height,
		hdcScreen.Handle,
		0,
		0,
		C.SRCCOPY)

--	local graphPort = ArrayRenderer(hbmScreenAccessor)

--	local red = PixelBGRA(0,0,255,255)

--	graphPort:LineH(0, hbmScreen.Height/2, hbmScreen.Width-1, red)
end


function SetupCamera(sw, sh)
	gl.glMatrixMode(gl.GL_PROJECTION)
	gl.glLoadIdentity()

	gl.glMatrixMode( gl.GL_MODELVIEW )
	gl.glLoadIdentity()
	gl.glOrtho(0, sw, sh, 0, -1, 1 )
end


local screencolor = {0,0,1,1}

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
	captureScreen()

	if not screenTexture then
		-- Create texture object once the GL Context
		-- is attached
		screenTexture = Texture(hbmScreenAccessor)
	end

	screenTexture:CopyPixelBuffer(hbmScreenAccessor)

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

local function main()

	local appwin = GameWindow({
		OnTickDelegate = ontick,
		FrameRate = 15,
		Extent = {320,240},
		})

	assert(appwin, "unable to create game window")

	-- To ensure GLContext is active
	appwin:Show()
	appwin.GLContext:Attach()

	test_wgl(appwin.GLContext)

	-- setup blending mode
	gl.glEnable( gl.GL_BLEND )
	gl.glBlendFunc( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA )
	gl.glDisable( gl.GL_CULL_FACE)


	-- run the application
	appwin:Run()
end

main()




