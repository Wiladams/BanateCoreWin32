-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

-- test_pixelbuffer_gl.lua
local ffi   = require( "ffi" )
local C = ffi.C

local gl    = require( "gl" )
local class = require"class"

require "win_gdi32"
require "win_user32"
require "win_opengl32"
require "GameWindow"

local gllib = ffi.load("opengl32")


local error, getmetatable, io, pairs, rawget, rawset, setmetatable, tostring, type =
    _G.error, _G.getmetatable, _G.io, _G.pairs, _G.rawget, _G.rawset, _G.setmetatable, _G.tostring, _G.type



-- Create a compatible bitmap for hdcScreen.
local scrWidth = 320
local scrHeight = 240


function getGLString(which)
	local bytes = gl.glGetString(which)
	local str = ffi.string(bytes)

	return str
end

function split(str)
	local ret = {}
	for w in string.gmatch(str, "[%w,._]+") do
		table.insert(ret, w)
	end
	return ret
end


local function test_gl(ctxt)

	local Vendor = ctxt.Vendor()
	local Renderer = ctxt.Renderer()
	local Version = ctxt.Version()

	local ExtensionString = getGLString(gl.GL_EXTENSIONS)
	local Extensions = split(ExtensionString)

	print("Vendor: ",Vendor)
	print("Renderer: ", Renderer)
	print("Version: ", Version)
	print("Extensions: ", ExtensionString)
	for _,extension in ipairs(Extensions) do
		print(extension)
	end

	local createProgram = gllib.wglGetProcAddress("glCreateProgram")
	print("createProgram: ", createProgram)
end



local function main()

	local appwin = GameWindow({
		Title = "OpenGL Test",
		--OnTickDelegate = ontick,
		FrameRate = 30,
		Extent = {320,240},
		})

	assert(appwin, "unable to create game window")

	-- To ensure GLContext is active
	appwin:Show()

	test_gl(appwin.GLContext)

	-- run the application
	appwin:Run()
end

main()




