-- Do not require this file directly
-- use NuiSensor

local ffi = require "ffi"

-- 13ea17f5-ff2e-4670-9ee5-1297a6e880d1
IID_INuiFrameTexture = DEFINE_UUID("IID_INuiFrameTexture",0x13ea17f5,0xff2e,0x4670,0x9e,0xe5,0x12,0x97,0xa6,0xe8,0x80,0xd1);

ffi.cdef[[
typedef struct _NUI_SURFACE_DESC
{
    uint32_t Width;
    uint32_t Height;
} 	NUI_SURFACE_DESC;
]]

ffi.cdef[[
typedef struct INuiFrameTexture INuiFrameTexture;

typedef struct INuiFrameTextureVtbl
{
	// IUnknown
	HRESULT (*QueryInterface )(
		INuiFrameTexture * This,
		REFIID riid,
		void **ppvObject);

	ULONG (*AddRef)(INuiFrameTexture * This);

	ULONG (*Release )(INuiFrameTexture * This);


	// INuiFrameTexture Specific
	int (*BufferLen )(INuiFrameTexture * This);

	int (*Pitch )(INuiFrameTexture * This);

	HRESULT (*LockRect )(INuiFrameTexture * This,
		UINT Level,
		NUI_LOCKED_RECT *pLockedRect,
        RECT *pRect,
		DWORD Flags);

	HRESULT (*GetLevelDesc )(INuiFrameTexture * This,
		UINT Level,
		NUI_SURFACE_DESC *pDesc);

	HRESULT (*UnlockRect )(INuiFrameTexture * This,
		UINT Level);

} INuiFrameTextureVtbl;

typedef struct INuiFrameTexture
{
	struct INuiFrameTextureVtbl *lpVtbl;
} INuiFrameTexture;
]]

ffi.cdef[[
typedef struct _NUI_IMAGE_FRAME
{
	LARGE_INTEGER liTimeStamp;
    DWORD dwFrameNumber;
    NUI_IMAGE_TYPE eImageType;
    NUI_IMAGE_RESOLUTION eResolution;
    INuiFrameTexture *pFrameTexture;
    DWORD dwFrameFlags;
    NUI_IMAGE_VIEW_AREA ViewArea;
} NUI_IMAGE_FRAME, *PNUI_IMAGE_FRAME;
]]


INuiFrameTexture = nil
INuiFrameTexture_mt = {
	__index = {
		GetBufferLength = function(self)
			local len = self.lpVtbl.BufferLen(self);
			return len
		end,

		GetPitch = function(self)
			local pitch = self.lpVtbl.Pitch(self);
			return pitch
		end,

		LockRect = function(self, Level, Flags)
			Level = Level or 0
			Flags = Flags or 0

			local lockedrect = ffi.new("NUI_LOCKED_RECT[1]")
			local frame = ffi.new("RECT[1]")

			local hr = self.lpVtbl.LockRect(self, Level, lockedrect, frame, Flags)
			local severity, facility, code = HRESULT_PARTS(hr)
--print("Lock Rect: ", severity, facility, code)
			return lockedrect[0], frame[0]
		end,

		UnlockRect = function(self, Level)
			Level = Level or 0
			local hr = self.lpVtbl.UnlockRect(self,Level)
			return hr
		end,
	},
}
INuiFrameTexture = ffi.metatype("INuiFrameTexture", INuiFrameTexture_mt)
