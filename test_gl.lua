-- test_pixelbuffer_gl.lua
local ffi   = require( "ffi" )

local gl    = require( "gl" )
local glu   = require( "ffi/glu" )
local glfw  = require( "ffi/glfw" )
local class = require"class"

require "win_gdi32"
require "win_user32"
require "gl_wgl"

local gllib = ffi.load("opengl32")

local C = ffi.C

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








class.GL()

function GL:_init()
	self.Vendor = getGLString(gl.GL_VENDOR)
	self.Renderer = getGLString(gl.GL_RENDERER)
	self.Version = getGLString(gl.GL_VERSION)
	self.ExtensionString = getGLString(gl.GL_EXTENSIONS)
	self.Extensions = split(self.ExtensionString)
end


local function test_gl()
	local glf = GL()

	print("Vendor: ",glf.Vendor)
	print("Renderer: ", glf.Renderer)
	print("Version: ", glf.Version)
	print("Extensions: ", glf.ExtensionString)
	for _,extension in ipairs(glf.Extensions) do
		print(extension)
	end

	local createProgram = gl.wglGetProcAddress("glCreateProgram")
	print("createProgram: ", createProgram)
end


local function main()
	local px, py = 0, 0
	assert( glfw.glfwInit() )


	local window = glfw.glfwOpenWindow( scrWidth, scrHeight, glfw.GLFW_WINDOWED, "OpenGL Test", nil)
	assert( window )


	glfw.glfwSetInputMode(window, glfw.GLFW_STICKY_KEYS, 1)
	glfw.glfwSwapInterval(1)

	gl.glEnable( gl.GL_BLEND )
	gl.glBlendFunc( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA )
	gl.glDisable( gl.GL_CULL_FACE)

	local mx, my = ffi.new( "int[1]" ), ffi.new( "int[1]" )
	local sw, sh = ffi.new( "int[1]" ), ffi.new( "int[1]" )
	local dx, dy

	--test_gl();
	test_wgl();


	while glfw.glfwIsWindow(window) and glfw.glfwGetKey(window, glfw.GLFW_KEY_ESCAPE) ~= glfw.GLFW_PRESS
	do
		local t = glfw.glfwGetTime()

		glfw.glfwGetMousePos(window, mx, my)
		local mx, my = mx[0], my[0]

		glfw.glfwGetWindowSize(window, sw, sh)
		local sw, sh = sw[0], sh[0]

		dx = dx or sw / 2
		dy = dy or sh / 2

		glfw.glfwSwapBuffers()
		glfw.glfwPollEvents()
   end

	glfw.glfwTerminate()
end

main()



