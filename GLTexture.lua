local ffi   = require( "ffi" )
local gl    = require( "gl" )
local class = require "class"

local function checkGL( str )
	local r = gl.glGetError()

	str = str or""
	local err = string.format("%s  OpenGL Error: 0x%x", str, tonumber(r))

	assert( r == 0, err)
end


class.Texture()

Texture.Defaults = {
	UnpackAlignment = 1,
}

function Texture:_init(pixelaccessor)
print("Texture:_init - Args: ", pixelaccessor)
	self.glPixelSize = pixelaccessor.BytesPerElement
	self.Width = pixelaccessor.Width
	self.Height = pixelaccessor.Height

	-- Get a texture ID for this texture
	local tid = ffi.new( "GLuint[1]" )
	gl.glGenTextures( 1, tid )
	self.TextureID = tid[0]
	checkGL( "glBenTextures" )

	-- Enable Texture Mapping
	gl.glEnable(gl.GL_TEXTURE_2D)

	-- Bind to the texture so opengl knows which Texture object
	-- we are operating on
	gl.glBindTexture( gl.GL_TEXTURE_2D, self.TextureID )
	checkGL( "glBindTexture")


	-- Text filtering must be established
	-- if you just see white on the texture, then chances
	-- are the filters have not been setup
	-- Create Nearest Filtered Texture
	--gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)
	--gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)

	-- Create Linear Filtered Texture
	gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)
	checkGL("minfilter")
	gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)
	checkGL("magfilter")


	local incoming = gl.GL_BGRA
	if pixelaccessor.BitsPerElement == 24 then
		incoming = gl.GL_BGR
	end

--[[
	local incoming = gl.GL_RGBA
	if pixbuff.BitsPerElement == 24 then
		incoming = gl.GL_RGB
	end
--]]

--print("GLTexture:_init()")
--print(string.format("  incoming: 0x%x", incoming))
--print("Size: ", self.Width, self.Height)

	gl.glPixelStorei(gl.GL_UNPACK_ALIGNMENT, Texture.Defaults.UnpackAlignment)
	gl.glTexImage2D (gl.GL_TEXTURE_2D,
		0, 				-- texture level
		gl.GL_RGB, 	-- internal format
		self.Width, 	-- width
		self.Height, 	-- height
		0, 				-- border
		incoming, 		-- format of incoming data
		gl.GL_UNSIGNED_BYTE,	-- data type of incoming data
		pixelaccessor.Data)		-- pointer to incoming data

	checkGL("glTexImage2D")

end


function Texture.MakeCurrent(self)
--print("Texture.MakeCurrent() - ID: ", self.TextureID);
	gl.glBindTexture(gl.GL_TEXTURE_2D, self.TextureID)
	checkGL("glBindTexture")
end



function Texture.CopyPixelBuffer(self, pixelaccessor)
	local incoming = gl.GL_BGRA
	if pixelaccessor.BitsPerElement == 24 then
		incoming = gl.GL_BGR
	end

--print(string.format("  incoming: 0x%x", incoming))
--print("Texture.CopyPixelBuffer: Width/Height: ", pixbuff.Width, pixbuff.Height)
--print("Pixels: ", pixbuff.Pixels)
--print("Texture:CopyPixelBuffer BitesPerElement: ", pixbuff.BitsPerElement)

	gl.glEnable(gl.GL_TEXTURE_2D)            -- Enable Texture Mapping
	self:MakeCurrent()

	gl.glPixelStorei(gl.GL_UNPACK_ALIGNMENT,  Texture.Defaults.UnpackAlignment)

	gl.glTexSubImage2D (gl.GL_TEXTURE_2D,
		0,	-- level
		0, 	-- xoffset
		0, 	-- yoffset
		pixelaccessor.Width, 	-- width
		pixelaccessor.Height, -- height
		incoming,		-- format of incoming data
		gl.GL_UNSIGNED_BYTE,	-- data type of incoming data
		pixelaccessor.Data)		-- pointer to incoming data
end

function Texture.Render(self, x, y, awidth, aheight)
	x = x or 0
	y = y or 0
	awidth = awidth or self.Width
	aheight = aheight or self.Height

	--print("Textue:Render - x,y, width, height", x, y, awidth, aheight)

	--gl.glPixelStorei(gl.GL_UNPACK_ALIGNMENT, 1)

	gl.glEnable(gl.GL_TEXTURE_2D)

	self:MakeCurrent()


	gl.glBegin(gl.GL_QUADS)
		gl.glNormal3d( 0, 0, 1)                      -- Normal Pointing Towards Viewer

		gl.glTexCoord2d(0, 0)
		gl.glVertex3d(x, y+aheight,  0)  -- Point 1 (Front)



		gl.glTexCoord2d(1, 0)
		gl.glVertex3d( x+awidth, y+aheight,  0)  -- Point 2 (Front)


		gl.glTexCoord2d(1, 1)
		gl.glVertex3d( x+awidth,  y,  0)  -- Point 3 (Front)

		gl.glTexCoord2d(0, 1)
		gl.glVertex3d(x,  y,  0)  -- Point 4 (Front)
	gl.glEnd()

	-- Disable Texture Mapping
	gl.glDisable(gl.GL_TEXTURE_2D)
end

--[[

function Texture.CreatePixelArray(self)
	-- get a copy of the texture data into a pixel buffer

	self:MakeCurrent()
	gl.PixelStore(gl.PACK_ALIGNMENT, 1)

	-- Get the pixel array
	local pixelarray = ffi.new("unsigned char[?]", 1)
	local texels = gl.glGetTexImage (gl.GL_TEXTURE_2D, 0, gl.GL_RGB, gl.GL_UNSIGNED_BYTE, GLvoid *pixels);

	-- Convert to 2D array, or we can't feed it back to TexSubImage()
	local pixels = create2DPixelArray(self.width, self.height, self.glPixelSize, pixels1D)


	return pixels
end

--]]
