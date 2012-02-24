local ffi = require "ffi"
require "Win32Types"
require "win_gdi32"

ffi.cdef[[
typedef struct tagLAYERPLANEDESCRIPTOR {
  WORD  nSize;
  WORD  nVersion;
  DWORD dwFlags;
  BYTE  iPixelType;
  BYTE  cColorBits;
  BYTE  cRedBits;
  BYTE  cRedShift;
  BYTE  cGreenBits;
  BYTE  cGreenShift;
  BYTE  cBlueBits;
  BYTE  cBlueShift;
  BYTE  cAlphaBits;
  BYTE  cAlphaShift;
  BYTE  cAccumBits;
  BYTE  cAccumRedBits;
  BYTE  cAccumGreenBits;
  BYTE  cAccumBlueBits;
  BYTE  cAccumAlphaBits;
  BYTE  cDepthBits;
  BYTE  cStencilBits;
  BYTE  cAuxBuffers;
  BYTE  iLayerPlane;
  BYTE  bReserved;
  COLORREF crTransparent;
} LAYERPLANEDESCRIPTOR, *LPLAYERPLANEDESCRIPTOR;
]]

ffi.cdef[[
typedef HANDLE HGLRC;

	void (*glExtGetShadersQCOM)(unsigned *shaders, int maxShaders, int *numShaders);

	// Callback functions
	typedef int (__attribute__((__stdcall__)) *PROC)();


	BOOL wglCopyContext(HGLRC hglrcSrc, HGLRC hglrcDst, UINT  mask);

	HGLRC wglCreateContext(HDC hdc);

	HGLRC wglCreateLayerContext(HDC hdc, int  iLayerPlane);

	BOOL wglDeleteContext(HGLRC  hglrc);

	BOOL wglDescribeLayerPlane(HDC hdc,int  iPixelFormat, int  iLayerPlane, UINT  nBytes, LPLAYERPLANEDESCRIPTOR plpd);

	HGLRC wglGetCurrentContext(void);

	HDC wglGetCurrentDC(void);

	int wglGetLayerPaletteEntries(HDC  hdc, int  iLayerPlane, int  iStart,int  cEntries, const COLORREF *pcr);

	PROC wglGetProcAddress(LPCSTR lpszProc);

	BOOL wglMakeCurrent(HDC hdc, HGLRC  hglrc);

	BOOL wglRealizeLayerPalette(HDC hdc, int iLayerPlane, BOOL bRealize);

	int wglSetLayerPaletteEntries(HDC  hdc, int iLayerPlane,int  iStart,int  cEntries, const COLORREF *pcr);

	BOOL wglShareLists(HGLRC  hglrc1, HGLRC  hglrc2);

	BOOL wglSwapLayerBuffers(HDC hdc, UINT  fuPlanes);

	BOOL wglUseFontBitmapsA(HDC  hdc, DWORD  first, DWORD  count, DWORD listBase);
	BOOL wglUseFontBitmapsW(HDC  hdc, DWORD  first, DWORD  count, DWORD listBase);

	BOOL wglUseFontOutlinesA(HDC  hdc,DWORD  first, DWORD  count, DWORD  listBase,  FLOAT  deviation, FLOAT  extrusion,int  format, LPGLYPHMETRICSFLOAT  lpgmf);
	BOOL wglUseFontOutlinesW(HDC  hdc,DWORD  first, DWORD  count, DWORD  listBase,  FLOAT  deviation, FLOAT  extrusion,int  format, LPGLYPHMETRICSFLOAT  lpgmf);

]]
