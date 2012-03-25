local ffi = require"ffi"
local bit = require"bit"

local bnot = bit.bnot
local band = bit.band
local bor = bit.bor
local lshift = bit.lshift
local rshift = bit.rshift

ffi.cdef[[

// Basic Data types
typedef unsigned char	BYTE;
typedef int				BOOL;
typedef BYTE			BOOLEAN;
typedef char			CHAR;
typedef unsigned short	WORD;
typedef unsigned long	DWORD;
typedef unsigned int	DWORD32;
typedef int				INT;
typedef signed int		INT32;
typedef signed __int64	INT64;
typedef float 			FLOAT;
typedef long			LONG;
typedef signed int		LONG32;
typedef __int64			LONGLONG;

typedef unsigned char	BCHAR;
typedef unsigned char	UCHAR;
typedef unsigned int	UINT;
typedef unsigned int	UINT32;
typedef unsigned long	ULONG;
typedef unsigned int	ULONG32;
typedef unsigned short	USHORT;

// Some pointer types
typedef void *			PVOID;
typedef PVOID			HANDLE;
typedef HANDLE			LPHANDLE;
typedef DWORD *			DWORD_PTR;
typedef intptr_t		LONG_PTR;
typedef uintptr_t		UINT_PTR;
typedef uintptr_t		ULONG_PTR;


typedef DWORD *			LPCOLORREF;

typedef char *			LPSTR;
typedef LPSTR			LPTSTR;
typedef const char *	LPCSTR;
typedef LPCSTR			LPCTSTR;
typedef const void *	LPCVOID;

typedef void *			LPVOID;

typedef LONG_PTR		LRESULT;

typedef intptr_t		LPARAM;
typedef uintptr_t		WPARAM;

typedef unsigned char	*PUCHAR;
typedef unsigned int	*PUINT;
typedef unsigned int	*PUINT32;
typedef unsigned long	*PULONG;
typedef unsigned int	*PULONG32;
typedef unsigned short	*PUSHORT;

typedef unsigned char	TBYTE;
typedef char			TCHAR;

typedef USHORT			COLOR16;
typedef DWORD			COLORREF;

// Special types
typedef WORD			ATOM;
typedef DWORD			LCID;

// Various Handles
typedef HANDLE			HBITMAP;
typedef HANDLE			HBRUSH;
typedef HANDLE			HICON;
typedef HICON			HCURSOR;
typedef HANDLE			HDC;
typedef HANDLE			HDESK;
typedef HANDLE			HDROP;
typedef HANDLE			HDWP;
typedef HANDLE			HENHMETAFILE;
typedef int				HFILE;
typedef HANDLE			HFONT;
typedef HANDLE			HGDIOBJ;
typedef HANDLE			HGLOBAL;
typedef HANDLE 			HGLRC;
typedef HANDLE			HHOOK;
typedef HANDLE			HINSTANCE;
typedef HANDLE			HKEY;
typedef HANDLE			HLOCAL;
typedef HANDLE			HMENU;
typedef HANDLE			HMETAFILE;
typedef HINSTANCE		HMODULE;
typedef HANDLE			HMONITOR;
typedef HANDLE			HPALETTE;
typedef HANDLE			HPEN;
typedef LONG			HRESULT;
typedef HANDLE			HRGN;
typedef HANDLE			HRSRC;
typedef HANDLE			HSZ;
typedef HANDLE			HWINSTA;
typedef HANDLE			HWND;


typedef DWORD ACCESS_MASK;
typedef ACCESS_MASK* PACCESS_MASK;


typedef LONG FXPT16DOT16, *LPFXPT16DOT16;
typedef LONG FXPT2DOT30, *LPFXPT2DOT30;
]]

ffi.cdef[[
typedef union _LARGE_INTEGER {
	struct {
		DWORD LowPart;
		LONG HighPart;
	};
	struct {
		DWORD LowPart;
		LONG HighPart;
	} u;
	LONGLONG QuadPart;
} LARGE_INTEGER,  *PLARGE_INTEGER;

]]



ffi.cdef[[
typedef struct _GUID {
	DWORD Data1;
	WORD Data2;
	WORD Data3;
	BYTE Data4[8];
} GUID;
]]

ffi.cdef[[
enum {
	MAXSHORT = 32767,
	MINSHORT = -32768,

	MAXINT = 2147483647,
	MININT = -2147483648,

	MAXLONGLONG = 9223372036854775807,
	MINLONGLONG = -9223372036854775807,
	};

]]


ffi.cdef[[

typedef struct tagSIZE {
  LONG cx;
  LONG cy;
} SIZE, *PSIZE;

typedef struct tagPOINT {
  int32_t x;
  int32_t y;
} POINT, *PPOINT;

typedef struct _POINTL {
  LONG x;
  LONG y;
} POINTL, *PPOINTL;

typedef struct tagRECT {
	int32_t left;
	int32_t top;
	int32_t right;
	int32_t bottom;
} RECT, *PRECT;
]]

RECT = nil
RECT_mt = {
	__tostring = function(self)
		local str = string.format("%d %d %d %d", self.left, self.top, self.right, self.bottom)
		return str
	end,

	__index = {
	}
}
RECT = ffi.metatype("RECT", RECT_mt)

ffi.cdef[[
typedef struct _TRIVERTEX {
  LONG        x;
  LONG        y;
  COLOR16     Red;
  COLOR16     Green;
  COLOR16     Blue;
  COLOR16     Alpha;
}TRIVERTEX, *PTRIVERTEX;

typedef struct _GRADIENT_TRIANGLE {
  ULONG    Vertex1;
  ULONG    Vertex2;
  ULONG    Vertex3;
}GRADIENT_TRIANGLE, *PGRADIENT_TRIANGLE;

typedef struct _GRADIENT_RECT {
  ULONG    UpperLeft;
  ULONG    LowerRight;
}GRADIENT_RECT, *PGRADIENT_RECT;





typedef struct tagRGBQUAD {
  BYTE    rgbBlue;
  BYTE    rgbGreen;
  BYTE    rgbRed;
  BYTE    rgbReserved;
} RGBQUAD;

typedef struct tagRGBTRIPLE {
  BYTE rgbtBlue;
  BYTE rgbtGreen;
  BYTE rgbtRed;
} RGBTRIPLE;




typedef struct tagBITMAP {
  LONG   bmType;
  LONG   bmWidth;
  LONG   bmHeight;
  LONG   bmWidthBytes;
  WORD   bmPlanes;
  WORD   bmBitsPixel;
  LPVOID bmBits;
} BITMAP, *PBITMAP;

typedef struct tagBITMAPCOREHEADER {
  DWORD   bcSize;
  WORD    bcWidth;
  WORD    bcHeight;
  WORD    bcPlanes;
  WORD    bcBitCount;
} BITMAPCOREHEADER, *PBITMAPCOREHEADER;

typedef struct tagBITMAPINFOHEADER{
  DWORD  biSize;
  LONG   biWidth;
  LONG   biHeight;
  WORD   biPlanes;
  WORD   biBitCount;
  DWORD  biCompression;
  DWORD  biSizeImage;
  LONG   biXPelsPerMeter;
  LONG   biYPelsPerMeter;
  DWORD  biClrUsed;
  DWORD  biClrImportant;
} BITMAPINFOHEADER, *PBITMAPINFOHEADER;


typedef struct tagBITMAPINFO {
  BITMAPINFOHEADER bmiHeader;
  RGBQUAD          bmiColors[1];
} BITMAPINFO, *PBITMAPINFO;


typedef struct tagCIEXYZ {
  FXPT2DOT30 ciexyzX;
  FXPT2DOT30 ciexyzY;
  FXPT2DOT30 ciexyzZ;
} CIEXYZ, * PCIEXYZ;


typedef struct tagCIEXYZTRIPLE {
  CIEXYZ  ciexyzRed;
  CIEXYZ  ciexyzGreen;
  CIEXYZ  ciexyzBlue;
} CIEXYZTRIPLE, *PCIEXYZTRIPLE;



typedef struct {
  DWORD        bV4Size;
  LONG         bV4Width;
  LONG         bV4Height;
  WORD         bV4Planes;
  WORD         bV4BitCount;
  DWORD        bV4V4Compression;
  DWORD        bV4SizeImage;
  LONG         bV4XPelsPerMeter;
  LONG         bV4YPelsPerMeter;
  DWORD        bV4ClrUsed;
  DWORD        bV4ClrImportant;
  DWORD        bV4RedMask;
  DWORD        bV4GreenMask;
  DWORD        bV4BlueMask;
  DWORD        bV4AlphaMask;
  DWORD        bV4CSType;
  CIEXYZTRIPLE bV4Endpoints;
  DWORD        bV4GammaRed;
  DWORD        bV4GammaGreen;
  DWORD        bV4GammaBlue;
} BITMAPV4HEADER, *PBITMAPV4HEADER;

typedef struct {
  DWORD        bV5Size;
  LONG         bV5Width;
  LONG         bV5Height;
  WORD         bV5Planes;
  WORD         bV5BitCount;
  DWORD        bV5Compression;
  DWORD        bV5SizeImage;
  LONG         bV5XPelsPerMeter;
  LONG         bV5YPelsPerMeter;
  DWORD        bV5ClrUsed;
  DWORD        bV5ClrImportant;
  DWORD        bV5RedMask;
  DWORD        bV5GreenMask;
  DWORD        bV5BlueMask;
  DWORD        bV5AlphaMask;
  DWORD        bV5CSType;
  CIEXYZTRIPLE bV5Endpoints;
  DWORD        bV5GammaRed;
  DWORD        bV5GammaGreen;
  DWORD        bV5GammaBlue;
  DWORD        bV5Intent;
  DWORD        bV5ProfileData;
  DWORD        bV5ProfileSize;
  DWORD        bV5Reserved;
} BITMAPV5HEADER, *PBITMAPV5HEADER;

]]


BITMAPINFOHEADER = nil
BITMAPINFOHEADER_mt = {
	__index = {
		Init = function(self)
			self.biSize = ffi.sizeof("BITMAPINFOHEADER")
		end,
	}
}
BITMAPINFOHEADER = ffi.metatype("BITMAPINFOHEADER", BITMAPINFOHEADER_mt)


BITMAPINFO = nil
BITMAPINFO_mt = {
	__index = {
		Init = function(self)
			self.bmiHeader:Init()
		end,
	}
}
BITMAPINFO = ffi.metatype("BITMAPINFO", BITMAPINFO_mt)




--[[
local C = ffi.C


print("POINT size: ", ffi.sizeof("POINT"))

print("INT64: ", ffi.sizeof("INT64"))

local cref1 = RGB(32, 64, 128)
print(GetRValue(cref1), GetGValue(cref1), GetBValue(cref1))



--]]
