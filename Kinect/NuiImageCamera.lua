-- NuiImageCamera.HRESULT

local ffi = require "ffi"
local bit = require "bit"
local band = bit.band
local bor = bit.bor
local lshift = bit.lshift
local rshift = bit.rshift

ffi.cdef[[
typedef enum _NUI_IMAGE_DIGITALZOOM
{
    NUI_IMAGE_DIGITAL_ZOOM_1X = 0,
} NUI_IMAGE_DIGITALZOOM;

]]



ffi.cdef[[
HRESULT  NuiImageStreamSetImageFrameFlags(HANDLE hStream, DWORD dwImageFrameFlags);

HRESULT  NuiImageStreamGetImageFrameFlags(HANDLE hStream, DWORD *pdwImageFrameFlags);

HRESULT  NuiSetFrameEndEvent(HANDLE hEvent, DWORD dwFrameEventFlag);

HRESULT  NuiImageStreamOpen(NUI_IMAGE_TYPE eImageType,
     NUI_IMAGE_RESOLUTION eResolution,DWORD dwImageFrameFlags, DWORD dwFrameLimit,
    HANDLE hNextFrameEvent,HANDLE *phStreamHandle);

HRESULT  NuiImageStreamGetNextFrame(HANDLE hStream, DWORD dwMillisecondsToWait, const NUI_IMAGE_FRAME **ppcImageFrame);

HRESULT  NuiImageStreamReleaseFrame(HANDLE hStream, const NUI_IMAGE_FRAME *pImageFrame);

HRESULT  NuiImageGetColorPixelCoordinatesFromDepthPixel(NUI_IMAGE_RESOLUTION eColorResolution,
	const NUI_IMAGE_VIEW_AREA *pcViewArea,
	LONG   lDepthX, LONG   lDepthY, USHORT usDepthValue,
    LONG *plColorX, LONG *plColorY);

HRESULT  NuiImageGetColorPixelCoordinatesFromDepthPixelAtResolution(
	NUI_IMAGE_RESOLUTION eColorResolution,
	NUI_IMAGE_RESOLUTION eDepthResolution,
    const NUI_IMAGE_VIEW_AREA *pcViewArea,
	LONG   lDepthX,
	LONG   lDepthY,
	USHORT usDepthValue,
    LONG *plColorX,
    LONG *plColorY);

HRESULT  NuiCameraElevationGetAngle(LONG * plAngleDegrees);

HRESULT  NuiCameraElevationSetAngle(LONG lAngleDegrees);
]]

NUI_IMAGE_PLAYER_INDEX_SHIFT          =3
NUI_IMAGE_PLAYER_INDEX_MASK           =((lshift(1, NUI_IMAGE_PLAYER_INDEX_SHIFT))-1)
NUI_IMAGE_DEPTH_MAXIMUM               =(bor((lshift(4000, NUI_IMAGE_PLAYER_INDEX_SHIFT)), NUI_IMAGE_PLAYER_INDEX_MASK))
NUI_IMAGE_DEPTH_MINIMUM               =(lshift(800, NUI_IMAGE_PLAYER_INDEX_SHIFT))
NUI_IMAGE_DEPTH_MAXIMUM_NEAR_MODE     =(bor((lshift(3000, NUI_IMAGE_PLAYER_INDEX_SHIFT)), NUI_IMAGE_PLAYER_INDEX_MASK))
NUI_IMAGE_DEPTH_MINIMUM_NEAR_MODE     =(lshift(400, NUI_IMAGE_PLAYER_INDEX_SHIFT))
NUI_IMAGE_DEPTH_NO_VALUE              =0
NUI_IMAGE_DEPTH_TOO_FAR_VALUE         =(lshift(0x0fff, NUI_IMAGE_PLAYER_INDEX_SHIFT))
NUI_DEPTH_DEPTH_UNKNOWN_VALUE         =(lshift(0x1fff, NUI_IMAGE_PLAYER_INDEX_SHIFT))

NUI_CAMERA_DEPTH_NOMINAL_FOCAL_LENGTH_IN_PIXELS         =(285.63)   -- Based on 320x240 pixel size.
NUI_CAMERA_DEPTH_NOMINAL_INVERSE_FOCAL_LENGTH_IN_PIXELS =(3.501e-3) -- (1/NUI_CAMERA_DEPTH_NOMINAL_FOCAL_LENGTH_IN_PIXELS)
NUI_CAMERA_DEPTH_NOMINAL_DIAGONAL_FOV                   =(70.0)
NUI_CAMERA_DEPTH_NOMINAL_HORIZONTAL_FOV                 =(58.5)
NUI_CAMERA_DEPTH_NOMINAL_VERTICAL_FOV                   =(45.6)

NUI_CAMERA_COLOR_NOMINAL_FOCAL_LENGTH_IN_PIXELS         =(531.15)   -- Based on 640x480 pixel size.
NUI_CAMERA_COLOR_NOMINAL_INVERSE_FOCAL_LENGTH_IN_PIXELS =(1.83e-3)  -- (1/NUI_CAMERA_COLOR_NOMINAL_FOCAL_LENGTH_IN_PIXELS)
NUI_CAMERA_COLOR_NOMINAL_DIAGONAL_FOV                   =( 73.9)
NUI_CAMERA_COLOR_NOMINAL_HORIZONTAL_FOV                 =( 62.0)
NUI_CAMERA_COLOR_NOMINAL_VERTICAL_FOV                   =( 48.6)

NUI_IMAGE_FRAME_FLAG_NONE              = 0x00000000
NUI_IMAGE_FRAME_FLAG_VIEW_AREA_UNKNOWN = 0x00000001

-- return S_FALSE instead of E_NUI_FRAME_NO_DATA if NuiImageStreamGetNextFrame( ) doesn't have a frame ready and a timeout != INFINITE is used
NUI_IMAGE_STREAM_FLAG_SUPPRESS_NO_FRAME_DATA              = 0x00010000
-- Set the depth stream to near mode
NUI_IMAGE_STREAM_FLAG_ENABLE_NEAR_MODE                    = 0x00020000
-- Use distinct values for depth values that are either too close, too far or unknown
NUI_IMAGE_STREAM_FLAG_DISTINCT_OVERFLOW_DEPTH_VALUES      = 0x00040000

-- the max # of NUI output frames you can hold w/o releasing
NUI_IMAGE_STREAM_FRAME_LIMIT_MAXIMUM = 4


NUI_CAMERA_ELEVATION_MAXIMUM  = 27
NUI_CAMERA_ELEVATION_MINIMUM = (-27)


function NuiImageResolutionToSize(res)

    if res == C.NUI_IMAGE_RESOLUTION_80x60 then
        return 80, 60;
	end

	if res == C.NUI_IMAGE_RESOLUTION_320x240 then
        return 320,240;
	end

    if res == C.NUI_IMAGE_RESOLUTION_640x480 then
        return 640, 480;
	end

    if res == C.NUI_IMAGE_RESOLUTION_1280x960 then
        return 1280, 960;
	end

    return 0,0
end


--
-- Unpacks the depth value from the packed pixel format
--
function NuiDepthPixelToDepth(packedPixel)
    return rshift(packedPixel, NUI_IMAGE_PLAYER_INDEX_SHIFT);
end

--
-- Unpacks the player index value from the packed pixel format
--
function NuiDepthPixelToPlayerIndex(packedPixel)
    return band(packedPixel, NUI_IMAGE_PLAYER_INDEX_MASK);
end
