local ffi = require"ffi"
local C = ffi.C
local bit = require"bit"
local bor = bit.bor

local gl = require"gl"

require "win_gdi32"
local gdi32 = ffi.load("gdi32")

GLContext = nil
GLContext_mt = {
	__tostring = function(self)
		return string.format("GLContext(GID: 0x%s GL: 0x%s)",
			tostring(self.GDIHandle),
			tostring(self.GLHandle))
	end,

	__index = {
		TypeName = "GLContext",

		Size = ffi.sizeof("GLContext"),

		new = function(self, hdc)
			self.GDIHandle = hdc

			-- Now create a pixel format descriptor that is appropriate
			-- for GL.  Mainly it's in the flags passed in.
			local flags = 0
			local ColorBits = 32
			local DepthBits = 16

			local pfd = ffi.new("PIXELFORMATDESCRIPTOR");
			pfd.nSize = ffi.sizeof("PIXELFORMATDESCRIPTOR")
			pfd.nVersion = 1
			pfd.dwFlags = bor(flags,C.SupportOpenGL,C.DrawToWindow);   -- Put in 'SupportOpenGL' so at least there is OpenGL support
			pfd.iPixelType = C.RGBA;
			pfd.cColorBits = ColorBits;                        			-- How many bits used for color
			pfd.cRedBits = 0;
			pfd.cRedShift = 0;
			pfd.cGreenBits = 0;
			pfd.cGreenShift = 0;
			pfd.cBlueBits = 0;
			pfd.cBlueShift = 0;
			pfd.cAlphaBits = 0;
			pfd.cAlphaShift = 0;
			pfd.cAccumBits = 0;
			pfd.cAccumRedBits = 0;
			pfd.cAccumGreenBits = 0;
			pfd.cAccumBlueBits = 0;
			pfd.cAccumAlphaBits = 0;
			pfd.cDepthBits = DepthBits;					-- How many bits used for depth buffer
			pfd.cStencilBits = 0;
			pfd.cAuxBuffers = 0;
			pfd.iLayerType = C.Main;
			pfd.bReserved = 0;
			pfd.dwLayerMask = 0;
			pfd.dwVisibleMask = 0;
			pfd.dwDamageMask = 0;

			-- Choose Pixel Format
			-- Get format that matches closest
			local pixelFormat = gdi32.ChoosePixelFormat(self.GDIHandle, pfd);
			if (0 == pixelFormat) then
				-- throw an appropriate exception
				error("GameWindow:OnCreate - ChoosePixelFormat returned '0'")
			end

			local result = gdi32.SetPixelFormat(self.GDIHandle, pixelFormat, pfd);    -- Set this as the actual format
			if (result == 0) then
				error("GameWindow:OnCreate - SetPixelFormat returned false");
			end

			-- Create OpenGL Rendering Context (RC)
			self.GLHandle = gl.wglCreateContext(self.GDIHandle);	--  Create a GLContext
			print("GLContext:new - GL Device Context: ", self.GLHandle)

			return self
		end,

		Attach = function(self)
			local result = gl.wglMakeCurrent(self.GDIHandle, self.GLHandle);
			return result
		end,

		Detach = function(self)
			local result = gl.wglMakeCurrent(self.GDIHandle, nil);
			return result
		end,
	}
}
GLContext = ffi.metatype("GLContext", GLContext_mt)

return GLContext
