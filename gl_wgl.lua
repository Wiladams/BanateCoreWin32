local ffi = require "ffi"
require "Win32Types"
require "win_gdi32"
local gl    = require( "gl" )


ffi.cdef[[

	//void (*glExtGetShadersQCOM)(unsigned *shaders, int maxShaders, int *numShaders);
	const char * (*wglGetExtensionsStringARB)(HDC hdc);
	typedef const char * (* PFNWGLGETEXTENSIONSSTRINGARBPROC) (HDC hdc);

]]

--[[
-- Function prototypes for wgl extension functions
ffi.cdef[[
// WGL_ARB_buffer_region
typedef HANDLE ( * PFNWGLCREATEBUFFERREGIONARBPROC) (HDC hDC, int iLayerPlane, UINT uType);
typedef void ( * PFNWGLDELETEBUFFERREGIONARBPROC) (HANDLE hRegion);
typedef BOOL ( * PFNWGLSAVEBUFFERREGIONARBPROC) (HANDLE hRegion, int x, int y, int width, int height);
typedef BOOL ( * PFNWGLRESTOREBUFFERREGIONARBPROC) (HANDLE hRegion, int x, int y, int width, int height, int xSrc, int ySrc);

// WGL_ARB_multisample

// WGL_ARB_extensions_string
const char * wglGetExtensionsStringARB (HDC);


// WGL_ARB_pixel_format
extern BOOL WINAPI wglGetPixelFormatAttribivARB (HDC, int, int, UINT, const int *, int *);
extern BOOL WINAPI wglGetPixelFormatAttribfvARB (HDC, int, int, UINT, const int *, FLOAT *);
extern BOOL WINAPI wglChoosePixelFormatARB (HDC, const int *, const FLOAT *, UINT, int *, UINT *);

typedef BOOL (WINAPI * PFNWGLGETPIXELFORMATATTRIBIVARBPROC) (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const int *piAttributes, int *piValues);
typedef BOOL (WINAPI * PFNWGLGETPIXELFORMATATTRIBFVARBPROC) (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const int *piAttributes, FLOAT *pfValues);
typedef BOOL (WINAPI * PFNWGLCHOOSEPIXELFORMATARBPROC) (HDC hdc, const int *piAttribIList, const FLOAT *pfAttribFList, UINT nMaxFormats, int *piFormats, UINT *nNumFormats);
]]

--]]
