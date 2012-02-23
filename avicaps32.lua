-- avicaps32.lua

require "Win32Types"

local ffi = require "ffi"
local C = ffi.C

ffi.cdef[[
typedef struct mmtime_tag {
    UINT wType;
    union {
        DWORD ms;
        DWORD sample;
        DWORD cb;
        DWORD ticks;
        struct {
            BYTE hour;
            BYTE min;
            BYTE sec;
            BYTE frame;
            BYTE fps;
            BYTE dummy;
            BYTE pad[2]
        } smpte;
        struct {
            DWORD songptrpos;
        } midi;
    } u;
} MMTIME;

typedef struct {
    UINT wPeriodMin;
    UINT wPeriodMax;
} TIMECAPS;

typedef struct videohdr_tag {
  LPBYTE    lpData;
  DWORD     dwBufferLength;
  DWORD     dwBytesUsed;
  DWORD     dwTimeCaptured;
  DWORD_PTR dwUser;
  DWORD     dwFlags;
  DWORD_PTR dwReserved[4];
} VIDEOHDR, *PVIDEOHDR, *LPVIDEOHDR;
]]

ffi.cdef[[
	BOOL capGetDriverDescriptionA(WORD wDriverIndex,
		LPSTR lpszName,
		INT cbName,
		LPSTR lpszVer,
		INT cbVer);



	HWND capCreateCaptureWindowA(LPCSTR lpszWindowName,
		DWORD dwStyle,
		int x,
		int y,
		int nWidth,
		int nHeight,
		HWND hWnd,
		int nID);

]]

avicaps32 = ffi.load("avicaps32")

return avicaps32
