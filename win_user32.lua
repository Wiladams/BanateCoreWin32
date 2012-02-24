local ffi = require "ffi"
require "Win32Types"

local C = ffi.C

-- Windows Messages
ffi.cdef[[
enum {
	CW_USEDEFAULT = 0x80000000,
};

enum {
	CS_VREDRAW			= 0x0001,
	CS_HREDRAW			= 0x0002,
	CS_DBLCLKS			= 0x0008,
	CS_OWNDC			= 0x0020,
	CS_CLASSDC			= 0x0040,
	CS_NOCLOSE			= 0x0200,
	CS_SAVEBITS			= 0x0800,
	CS_BYTEALIGNCLIENT	= 0x1000,
	CS_BYTEALIGNWINDOW	= 0x2000,
	CS_GLOBALCLASS		= 0x4000,
	CS_DROPSHADOW		= 0x00020000,
};

enum {
	WS_POPUP			= 0xFFFFFFFF80000000LL,
	WS_MAXIMIZEBOX 		= 0x00010000,
	WS_SIZEBOX 			= 0x00040000,
	WS_SYSMENU 			= 0x00080000,
	WS_HSCROLL 			= 0x00100000,
	WS_VSCROLL 			= 0x00200000,
	WS_OVERLAPPEDWINDOW = 0x00CF0000,
	WS_MAXIMIZE 		= 0x01000000,
	WS_VISIBLE 			= 0x10000000,
	WS_MINIMIZE 		= 0x20000000,
};

enum {
	WS_EX_APPWINDOW = 262144,
	WS_EX_WINDOWEDGE = 256,
};

enum {
	WM_CREATE 			= 0x0001,
	WM_DESTROY 			= 0x0002,
	WM_ACTIVATE = 0x0006,
	WM_SETFOCUS			= 0x0007,
	WM_KILLFOCUS		= 0x0008,
	WM_ENABLE			= 0x000A,
	WM_SETTEXT 			= 0x000C,
	WM_GETTEXT 			= 0x000D,
	WM_PAINT			= 0x000F,
	WM_CLOSE 			= 0x0010,
	WM_QUIT 			= 0x0012,
	WM_ACTIVATEAPP = 0x001C,

	WM_SETCURSOR 		= 0x0020,
	WM_GETMINMAXINFO 	= 0x0024,
	WM_WINDOWPOSCHANGING = 0x0046,
	WM_WINDOWPOSCHANGED = 0x0047,
	WM_NCCREATE 		= 0x0081,
	WM_NCDESTROY 		= 0x0082,
	WM_NCCALCSIZE 		= 0x0083,
	WM_NCHITTEST 		= 0x0084,
	WM_NCPAINT 			= 0x0085,
	WM_NCACTIVATE 		= 0x0086,

	// Non Client (NC) mouse activity
	WM_NCMOUSEMOVE 		= 0x00A0,
	WM_NCLBUTTONDOWN 	= 0x00A1,
	WM_NCLBUTTONUP 		= 0x00A2,
	WM_NCLBUTTONDBLCLK 	= 0x00A3,
	WM_NCRBUTTONDOWN 	= 0x00A4,
	WM_NCRBUTTONUP 		= 0x00A5,
	WM_NCRBUTTONDBLCLK 	= 0x00A6,
	WM_NCMBUTTONDOWN 	= 0x00A7,
	WM_NCMBUTTONUP 		= 0x00A8,
	WM_NCMBUTTONDBLCLK 	= 0x00A9,

	WM_INPUT_DEVICE_CHANGE = 0x00FE,
	WM_INPUT = 0x00FF,

	// Keyboard Activity
	WM_KEYDOWN = 0x0100,
	WM_KEYUP = 0x0101,
	WM_CHAR = 0x0102,
	WM_DEADCHAR = 0x0103,
	WM_SYSKEYDOWN = 0x0104,
	WM_SYSKEYUP = 0x0105,
	WM_SYSCHAR = 0x0106,
	WM_SYSDEADCHAR = 0x0107,
	WM_COMMAND = 0x0111,
	WM_SYSCOMMAND = 0x0112,


	WM_TIMER = 0x0113,

	// client area mouse activity
	WM_MOUSEFIRST		= 0x0200,
	WM_MOUSEMOVE		= 0x0200,
	WM_LBUTTONDOWN		= 0x0201,
	WM_LBUTTONUP		= 0x0202,
	WM_LBUTTONDBLCLK	= 0x0203,
	WM_RBUTTONDOWN		= 0x0204,
	WM_RBUTTONUP		= 0x0205,
	WM_RBUTTONDBLCLK	= 0x0206,
	WM_MBUTTONDOWN		= 0x0207,
	WM_MBUTTONUP		= 0x0208,
	WM_MBUTTONDBLCLK	= 0x0209,
	WM_NCMOUSEHOVER		= 0x02A0,
	WM_NCMOUSELEAVE		= 0x02A2,
	WM_MOUSEWHEEL		= 0x020A,
	WM_XBUTTONDOWN		= 0x020B,
	WM_XBUTTONUP		= 0x020C,
	WM_XBUTTONDBLCLK	= 0x020D,
	WM_MOUSELAST		= 0x020D,

	WM_SIZING = 0x0214,
	WM_CAPTURECHANGED = 0x0215,
	WM_MOVING = 0x0216,
	WM_DEVICECHANGE = 0x0219,

	WM_ENTERSIZEMOVE = 0x0231,
	WM_EXITSIZEMOVE = 0x0232,
	WM_DROPFILES = 0x0233,

	WM_IME_SETCONTEXT = 0x0281,
	WM_IME_NOTIFY = 0x0282,

	WM_MOUSEHOVER = 0x02A1,
	WM_MOUSELEAVE = 0x02A3,

	WM_PRINT = 0x0317,
};

enum {
	SW_SHOW = 5,
}

enum {
	PM_REMOVE = 0x0001,
	PM_NOYIELD = 0x0002,
}

// dwWakeMask of MsgWaitForMultipleObjectsEx()
enum {
	QS_KEY				= 0x0001,
	QS_MOUSEMOVE		= 0x0002,
	QS_MOUSEBUTTON		= 0x0004,
	QS_MOUSE			= 0x0006,
	QS_POSTMESSAGE		= 0x0008,
	QS_TIMER			= 0x0010,
	QS_PAINT			= 0x0020,
	QS_SENDMESSAGE		= 0x0040,
	QS_HOTKEY			= 0x0080,
	QS_ALLPOSTMESSAGE	= 0x0100,
	QS_RAWINPUT			= 0x0400,
	QS_INPUT			= 0x0407,
	QS_ALLEVENTS		= 0x04BF,
	QS_ALLINPUT			= 0x04FF,
}

// dwFlags of MsgWaitForMultipleObjectsEx()
enum {
	MWMO_WAITALL		= 0x0001,
	MWMO_ALERTABLE		= 0x0002
	,
	MWMO_INPUTAVAILABLE	= 0x0004,
}


enum {
      WAIT_OBJECT_0 = 0x00000000,
      INFINITE =  0xFFFFFFFF,
};

enum {
	HWND_DESKTOP    = 0x0000,
	HWND_BROADCAST  = 0xffff,
	HWND_TOP        = (0),
	HWND_BOTTOM     = (1),
	HWND_TOPMOST    = (-1),
	HWND_NOTOPMOST  = (-2),
	HWND_MESSAGE = (-3),
};
]]

-- WINDOW CONSTRUCTION
ffi.cdef[[
typedef LRESULT (__stdcall *WNDPROC) (HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
typedef LRESULT (__stdcall *MsgProc) (HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

typedef struct {
    HWND hwnd;
    UINT message;
    WPARAM wParam;
    LPARAM lParam;
    DWORD time;
    POINT pt;
} MSG, *PMSG;

typedef struct {
    UINT style;
    WNDPROC lpfnWndProc;
    int cbClsExtra;
    int cbWndExtra;
    HINSTANCE hInstance;
    HICON hIcon;
    HCURSOR hCursor;
    HBRUSH hbrBackground;
    LPCSTR lpszMenuName;
    LPCSTR lpszClassName;
} WNDCLASSA, *PWNDCLASSA;

typedef struct {
    UINT cbSize;
    UINT style;
    WNDPROC lpfnWndProc;
    int cbClsExtra;
    int cbWndExtra;
    HINSTANCE hInstance;
    HICON hIcon;
    HCURSOR hCursor;
    HBRUSH hbrBackground;
    const LPCSTR lpszMenuName;
    const LPCSTR lpszClassName;
    HICON hIconSm;
} WNDCLASSEXA, *PWNDCLASSEXA;

typedef struct tagCREATESTRUCT {
    LPVOID lpCreateParams;
    HINSTANCE hInstance;
    HMENU hMenu;
    HWND hwndParent;
    int cy;
    int cx;
    int y;
    int x;
    LONG style;
    LPCSTR lpszName;
    LPCSTR lpszClass;
    DWORD dwExStyle;
} CREATESTRUCTA, *LPCREATESTRUCTA;

typedef struct {
    POINT ptReserved;
    POINT ptMaxSize;
    POINT ptMaxPosition;
    POINT ptMinTrackSize;
    POINT ptMaxTrackSize;
} MINMAXINFO, *PMINMAXINFO;


]]



WNDCLASSA = ffi.typeof("WNDCLASSA")
WNDCLASSEXA = ffi.typeof("WNDCLASSEXA")

-- Windows functions
ffi.cdef[[


DWORD MsgWaitForMultipleObjects(
	DWORD nCount,
	const HANDLE* pHandles,
	BOOL bWaitAll,
	DWORD dwMilliseconds,
	DWORD dwWakeMask
);

DWORD MsgWaitForMultipleObjectsEx(
	DWORD nCount,
	const HANDLE* pHandles,
	DWORD dwMilliseconds,
	DWORD dwWakeMask,
	DWORD dwFlags
);


LRESULT CallWindowProc(WNDPROC lpPrevWndFunc, HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

LRESULT DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);


ATOM RegisterClassExA(const WNDCLASSEXA *lpwcx);
ATOM RegisterClassA(const WNDCLASSA *lpWndClass);

HWND CreateWindow(
		LPCSTR lpClassName,
		LPCSTR lpWindowName,
		DWORD dwStyle,
		int x,
		int y,
		int nWidth,
		int nHeight,
		HWND hWndParent,
		HMENU hMenu,
		HINSTANCE hInstance,
		LPVOID lpParam);

HWND CreateWindowExA(
	DWORD dwExStyle,
	const LPCSTR lpClassName,
	const LPCSTR lpWindowName,
	DWORD dwStyle,
	int x,
	int y,
	int nWidth,
	int nHeight,
	HWND hWndParent,
	HMENU hMenu,
	HINSTANCE hInstance,
	LPVOID lpParam
	);



BOOL ShowWindow(HWND hWnd, int nCmdShow);

BOOL UpdateWindow(HWND hWnd);

HICON LoadIconA(HINSTANCE hInstance, LPCSTR lpIconName);

HCURSOR LoadCursorA(HINSTANCE hInstance, LPCSTR lpCursorName);


// PostMessage
BOOL PostMessage(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

// PostQuitMessage
void PostQuitMessage(int nExitCode);

// PostThreadMessage
BOOL PostThreadMessage(DWORD idThread, UINT Msg, WPARAM wParam, LPARAM lParam);

// SendMessage
int SendMessageA(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);

//int SendMessageW([In] IntPtr hWnd, int Msg, IntPtr wParam, IntPtr lParam);

// TranslateMessage
BOOL TranslateMessage(const MSG *lpMsg);

// DispatchMessage
LRESULT DispatchMessageA(const MSG *lpmsg);

// GetMessage
BOOL GetMessageA(PMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);

// GetMessageExtraInfo
LPARAM GetMessageExtraInfo(void);

// PeekMessage
BOOL PeekMessageA(PMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);

// WaitMessage
BOOL WaitMessage(void);
]]



-- WINDOW DRAWING
ffi.cdef[[
HDC GetWindowDC(HWND hWnd);
BOOL InvalidateRect(HWND hWnd, const RECT* lpRect, BOOL bErase);


// WINDOW UTILITIES

uint32_t GetLastError();

typedef BOOL (__stdcall *WNDENUMPROC)(HWND hwnd, LPARAM l);
int EnumWindows(WNDENUMPROC func, LPARAM l);

HWND GetForegroundWindow(void);

BOOL MessageBeep(UINT type);

int MessageBoxA(HWND hWnd,
		LPCTSTR lpText,
		LPCTSTR lpCaption,
		UINT uType
	);
]]




--[[


void* CreateEventA(SECURITY_ATTRIBUTES*, bool32 manualReset, bool32 initialState, const char* name);
uint32_t MsgWaitForMultipleObjects(uint32_t count, void** handles, bool32 waitAll, uint32_t ms, uint32_t wakeMask);

--]]



--[[
-- Implicit conversion to a callback via function pointer argument.
local count = 0

function WindowCounter(hwnd, l)
  count = count + 1
  return true
end

while ffi.C.EnumWindows(WindowCounter, 0) do
	print(count);
end

local cb = ffi.cast("WNDENUMPROC", WindowCounter)


--local cb = ffi.cast("WNDENUMPROC", function(hwnd, l)
--	count = count + 1
--	return true
--	end)

ffi.C.EnumWindows(cb,0)

print(count);

cb:free()

--]]
