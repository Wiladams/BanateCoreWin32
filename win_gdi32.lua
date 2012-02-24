local ffi = require "ffi"
local C = ffi.C
require "bit"

local band = bit.band	-- &
local bor = bit.xbor	-- |
local bnot = bit.bnot	-- ~

require "Win32Types"
require "Pixel"

-- GDI32
ffi.cdef[[
typedef struct {
	void *	Handle;
} DeviceContext;

typedef struct {
	void * Handle;
	BITMAP	Bitmap;
	unsigned char * Pixels;
} GDIBitmap;

typedef struct {
	void	*Handle;
	DeviceContext	hDC;
	int		Width;
	int		Height;
	int		BitsPerPixel;
	Ppixel_BGR_b Pixels;
	BITMAPINFO	Info;
} GDIDIBSection;

typedef struct _POINTFLOAT {
  FLOAT  x;
  FLOAT  y;
} POINTFLOAT;

typedef struct _GLYPHMETRICSFLOAT {
  FLOAT      gmfBlackBoxX;
  FLOAT      gmfBlackBoxY;
  POINTFLOAT gmfptGlyphOrigin;
  FLOAT      gmfCellIncX;
  FLOAT      gmfCellIncY;
} GLYPHMETRICSFLOAT, *LPGLYPHMETRICSFLOAT;

]]


ffi.cdef[[


enum {
	SRCCOPY = 0x00CC0020
};

HDC CreateDCA(LPCSTR lpszDriver,LPCSTR lpszDevice,LPCSTR lpszOutput,const void * lpInitData);
HDC CreateCompatibleDC(HDC hdc);

int SaveDC(void *hdc);
bool RestoreDC(void *hdc, int nSavedDC);


HGDIOBJ SelectObject(HDC hdc, HGDIOBJ hgdiobj);
int GetObjectA(HGDIOBJ hgdiobj, int cbBuffer, LPVOID lpvObject);

bool GdiFlush();

uint32_t SetPixel(HDC hdc, int x, int y, uint32_t color);
BOOL SetPixelV(HDC hdc, int X, int Y, uint32_t crColor);

int MoveToEx(HDC hdc, int X, int Y, void *lpPoint);

int LineTo(HDC hdc, int nXEnd, int nYEnd);

bool Rectangle(HDC hdc, int left, int top, int right, int bottom);

bool RoundRect(HDC hdc, int left, int top, int right, int bottom,
            int width, int height);


BOOL Ellipse(HDC hdc,
  int nLeftRect,
  int nTopRect,
  int nRightRect,
  int nBottomRect);
]]

ffi.cdef[[
int GetDIBits(HDC hdc,
	HBITMAP hbmp,
	UINT uStartScan,
	UINT cScanLines,
	LPVOID lpvBits,
	PBITMAPINFO lpbi,
	UINT uUsage);

BOOL BitBlt(  HDC hdcDest,
  int nXDest,
  int nYDest,
  int nWidth,
  int nHeight,
  HDC hdcSrc,
  int nXSrc,
  int nYSrc,
  DWORD dwRop);

int StretchDIBits(HDC hdc,
  int XDest,
  int YDest,
  int nDestWidth,
  int nDestHeight,
  int XSrc,
  int YSrc,
  int nSrcWidth,
  int nSrcHeight,
  const void *lpBits,
  const BITMAPINFO *lpBitsInfo,
  UINT iUsage,
  DWORD dwRop);

HBITMAP CreateCompatibleBitmap(HDC hdc,
  int nWidth,
  int nHeight);

HBITMAP CreateDIBSection(HDC hdc,
  const BITMAPINFO *pbmi,
  UINT iUsage,
  void **ppvBits,
  HANDLE hSection,
  DWORD dwOffset);
]]



--
-- This function answers the question:
-- Given:
--		We know the size of the byte boundary we want
--		to align to.
-- Question:
--		How many bytes need to be allocated to ensure we
--		will align to that boundary.
-- Discussion:
--		This comes up in cases where you're allocating a bitmap image
--		for example.  It may be a 24-bit image, but you need to ensure
--		that each row can align to a 32-bit boundary.  So, we need to
--		essentially scale up the number of bits to match the alignment.
--
local function GetAlignedByteCount(width, bitsperpixel, alignment)

	local bytesperpixel = bitsperpixel / 8;
	local stride = band((width * bytesperpixel + (alignment - 1)), bnot(alignment - 1));

	return stride;
end




GDIContext = nil
GDIContext_mt = {
	__tostring = function(self) return string.format("GDIContext(0x%s)", tostring(self.Handle)) end,
	__index = {
		TypeName = "DeviceContext",
		Size = ffi.sizeof("DeviceContext"),

		CreateDC = function(self, driver) return GDIContext(C.CreateDCA(driver, nil, nil, nil)) end,

		CreateCompatibleDC = function(self) return GDIContext(C.CreateCompatibleDC(self.Handle)) end,

		CreateForDefaultDisplay = function(self)
			self.Handle = C.CreateDCA("DISPLAY", nil, nil, nil)

            return self;
			end,

		CreateForMemory = function(self)
			local displayDC = C.CreateDCA("DISPLAY", nil, nil, nil)
			self.Handle = C.CreateCompatibleDC(displayDC)
			return self
			end,

		CreateCompatibleBitmap = function(self, width, height)
				local bm = GDIBitmap(C.CreateCompatibleBitmap(self.Handle,width,height));
				bm:Init(self.Handle)

				return bm
			end,

		SelectObject = function(self, gdiobj)
				C.SelectObject(self.Handle, gdiobj.Handle)
			end,

	}
}
GDIContext = ffi.metatype("DeviceContext", GDIContext_mt)



BITMAP = ffi.typeof("BITMAP")

GDIBitmap = nil
GDIBitmap_mt = {
	__tostring = function(self) return string.format("GDIBitmap(0x%s)", tostring(self.Handle)) end,
	__index = {
		TypeName = "BITMAP",
		Size = ffi.sizeof("GDIBitmap"),
		Init = function(self, hdc)
			local bmap = ffi.new("BITMAP[1]")
			local bmapsize = ffi.sizeof("BITMAP");
			C.GetObjectA(self.Handle, bmapsize, bmap)
			self.Bitmap = bmap[0]

			end,

		Print = function(self)
			print(string.format("Bitmap"))
			print(string.format("        type: %d", self.Bitmap.bmType))
			print(string.format("       width: %d", self.Bitmap.bmWidth))
			print(string.format("      height: %d", self.Bitmap.bmHeight))
			print(string.format(" Width Bytes: %d", self.Bitmap.bmWidthBytes))
			print(string.format("      Planes: %d", self.Bitmap.bmPlanes))
			print(string.format("BitsPerPixel: %d", self.Bitmap.bmBitsPixel));

			end,
	}
}
GDIBitmap = ffi.metatype("GDIBitmap", GDIBitmap_mt)

--
-- GDIDIBSection_mt
--
GDIDIBSection = nil
GDIDIBSection_mt = {
	__index = {
		TypeName = "GDIDIBSection",
		Size = ffi.sizeof("GDIDIBSection"),
		Init = function(self, width, height, bitsperpixel, alignment)
			alignment = alignment or 2
			bitsperpixel = bitsperpixel or 32

			self.Width = width
			self.Height = height
			self.BitsPerPixel = bitsperpixel


			-- Need to construct a BITMAPINFO structure
			-- to describe the image we'll be creating
			local bytesPerRow = GetAlignedByteCount(width, bitsperpixel, alignment)
			local info = ffi.new("BITMAPINFO")
			info:Init()
			info.bmiHeader.biWidth = width
			info.bmiHeader.biHeight = height
			info.bmiHeader.biPlanes = 1
			info.bmiHeader.biBitCount = bitsperpixel
			info.bmiHeader.biSizeImage = bytesPerRow * height
			info.bmiHeader.biClrImportant = 0
			info.bmiHeader.biClrUsed = 0
			info.bmiHeader.biCompression = 0	-- GDI32.BI_RGB
			self.Info = info

			-- Create the DIBSection, using the screen as
			-- the source DC
			local ddc = GDIContext():CreateForDefaultDisplay().Handle
			local DIB_RGB_COLORS = 0
			local pixelP = ffi.new("void *[1]")
			self.Handle = C.CreateDIBSection(ddc,
                info,
				DIB_RGB_COLORS,
				pixelP,
				nil,
				0);
print("GDIDIBSection Handle: ", self.Handle)
			--self.Pixels = ffi.cast("Ppixel_BGRA_b", pixelP[0])
			self.Pixels = pixelP[0]

			-- Create a memory device context
			self.hDC = GDIContext():CreateForMemory()
			local selected = C.SelectObject(self.hDC.Handle, self.Handle)
print("Selected: ", selected)
			--print("self.Pixels after cast: ", self.Pixels)

			return self
		end,

		Print = function(self)
			print("Bits Per Pixel: ", self.BitsPerPixel)
			print("Size: ", self.Width, self.Height)
			print("Pixels: ", self.Pixels)
		end,
		}
}
GDIDIBSection = ffi.metatype("GDIDIBSection", GDIDIBSection_mt)

--[[
print("win_gdi_32.lua - TEST")
local sec = GDIDIBSection():Init(320,240)
sec:Print()


--]]




function StretchBlt(winDC, img, XDest, YDest,DestWidth,DestHeight)
	local SRCCOPY = 0x00CC0020

	XDest = XDest or 0
	YDest = YDest or 0
	DestWidth = DestWidth or img.Width
	DestHeight = DestHeight or img.Height

	-- Draw a pixel buffer
	local bmInfo = BITMAPINFO();
	bmInfo:Init();
	bmInfo.bmiHeader.biWidth = img.Width;
    bmInfo.bmiHeader.biHeight = img.Height;
    bmInfo.bmiHeader.biPlanes = 1;
    bmInfo.bmiHeader.biBitCount = img.BitsPerPixel;
    bmInfo.bmiHeader.biClrImportant = 0;
    bmInfo.bmiHeader.biClrUsed = 0;
    bmInfo.bmiHeader.biCompression = 0;

	ffi.C.StretchDIBits(winDC,
		XDest,YDest,DestWidth,DestHeight,
		0,0,img.Width, img.Height,
		img.Pixels,
		bmInfo,
		0,
		SRCCOPY);
end


--[[
print("win_gdi32.lua - TEST")


local dc = GDIContext()
print(dc)
--]]
