ffi = require "ffi"
local C = ffi.C
local bit = require "bit"
local band = bit.band
local bor = bit.bor
local lshift = bit.lshift
local rshift = bit.rshift

require "guiddef"


NUI_SKELETON_COUNT = 6
MICARRAY_ADAPTIVE_BEAM = 0x1100


ffi.cdef[[
typedef struct _Vector4
{
    FLOAT x;
    FLOAT y;
    FLOAT z;
    FLOAT w;
} 	Vector4;
]]
Vector4 = ffi.typeof("Vector4")


ffi.cdef[[
typedef enum _NUI_SKELETON_POSITION_INDEX
    {	NUI_SKELETON_POSITION_HIP_CENTER	= 0,
	NUI_SKELETON_POSITION_SPINE	= ( NUI_SKELETON_POSITION_HIP_CENTER + 1 ) ,
	NUI_SKELETON_POSITION_SHOULDER_CENTER	= ( NUI_SKELETON_POSITION_SPINE + 1 ) ,
	NUI_SKELETON_POSITION_HEAD	= ( NUI_SKELETON_POSITION_SHOULDER_CENTER + 1 ) ,
	NUI_SKELETON_POSITION_SHOULDER_LEFT	= ( NUI_SKELETON_POSITION_HEAD + 1 ) ,
	NUI_SKELETON_POSITION_ELBOW_LEFT	= ( NUI_SKELETON_POSITION_SHOULDER_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_WRIST_LEFT	= ( NUI_SKELETON_POSITION_ELBOW_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_HAND_LEFT	= ( NUI_SKELETON_POSITION_WRIST_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_SHOULDER_RIGHT	= ( NUI_SKELETON_POSITION_HAND_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_ELBOW_RIGHT	= ( NUI_SKELETON_POSITION_SHOULDER_RIGHT + 1 ) ,
	NUI_SKELETON_POSITION_WRIST_RIGHT	= ( NUI_SKELETON_POSITION_ELBOW_RIGHT + 1 ) ,
	NUI_SKELETON_POSITION_HAND_RIGHT	= ( NUI_SKELETON_POSITION_WRIST_RIGHT + 1 ) ,
	NUI_SKELETON_POSITION_HIP_LEFT	= ( NUI_SKELETON_POSITION_HAND_RIGHT + 1 ) ,
	NUI_SKELETON_POSITION_KNEE_LEFT	= ( NUI_SKELETON_POSITION_HIP_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_ANKLE_LEFT	= ( NUI_SKELETON_POSITION_KNEE_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_FOOT_LEFT	= ( NUI_SKELETON_POSITION_ANKLE_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_HIP_RIGHT	= ( NUI_SKELETON_POSITION_FOOT_LEFT + 1 ) ,
	NUI_SKELETON_POSITION_KNEE_RIGHT	= ( NUI_SKELETON_POSITION_HIP_RIGHT + 1 ) ,
	NUI_SKELETON_POSITION_ANKLE_RIGHT	= ( NUI_SKELETON_POSITION_KNEE_RIGHT + 1 ) ,
	NUI_SKELETON_POSITION_FOOT_RIGHT	= ( NUI_SKELETON_POSITION_ANKLE_RIGHT + 1 ) ,
	NUI_SKELETON_POSITION_COUNT	= ( NUI_SKELETON_POSITION_FOOT_RIGHT + 1 )
    } 	NUI_SKELETON_POSITION_INDEX;

typedef enum _NUI_IMAGE_TYPE
{
  NUI_IMAGE_TYPE_DEPTH_AND_PLAYER_INDEX = 0,            // USHORT
  NUI_IMAGE_TYPE_COLOR,                                 // RGB32 data
  NUI_IMAGE_TYPE_COLOR_YUV,                             // YUY2 stream from camera h/w, but converted to RGB32 before user getting it.
  NUI_IMAGE_TYPE_COLOR_RAW_YUV,                         // YUY2 stream from camera h/w.
  NUI_IMAGE_TYPE_DEPTH,                                 // USHORT
} NUI_IMAGE_TYPE;

typedef enum _NUI_IMAGE_RESOLUTION
{
  NUI_IMAGE_RESOLUTION_INVALID = -1,
  NUI_IMAGE_RESOLUTION_80x60 = 0,
  NUI_IMAGE_RESOLUTION_320x240,
  NUI_IMAGE_RESOLUTION_640x480,
  NUI_IMAGE_RESOLUTION_1280x960                         // for hires color only
} NUI_IMAGE_RESOLUTION;
]]

ffi.cdef[[
typedef struct _NUI_IMAGE_VIEW_AREA
{
    int eDigitalZoom;
    LONG lCenterX;
    LONG lCenterY;
} 	NUI_IMAGE_VIEW_AREA;

typedef struct _NUI_TRANSFORM_SMOOTH_PARAMETERS
{
    FLOAT fSmoothing;
    FLOAT fCorrection;
    FLOAT fPrediction;
    FLOAT fJitterRadius;
    FLOAT fMaxDeviationRadius;
} 	NUI_TRANSFORM_SMOOTH_PARAMETERS;



typedef enum _NUI_SKELETON_POSITION_TRACKING_STATE
{
	NUI_SKELETON_POSITION_NOT_TRACKED	= 0,
	NUI_SKELETON_POSITION_INFERRED	= ( NUI_SKELETON_POSITION_NOT_TRACKED + 1 ) ,
	NUI_SKELETON_POSITION_TRACKED	= ( NUI_SKELETON_POSITION_INFERRED + 1 )
} 	NUI_SKELETON_POSITION_TRACKING_STATE;

typedef enum _NUI_SKELETON_TRACKING_STATE
{
	NUI_SKELETON_NOT_TRACKED	= 0,
	NUI_SKELETON_POSITION_ONLY	= ( NUI_SKELETON_NOT_TRACKED + 1 ) ,
	NUI_SKELETON_TRACKED	= ( NUI_SKELETON_POSITION_ONLY + 1 )
} 	NUI_SKELETON_TRACKING_STATE;

typedef struct _NUI_SKELETON_DATA
{
    NUI_SKELETON_TRACKING_STATE eTrackingState;
    DWORD dwTrackingID;
    DWORD dwEnrollmentIndex;
    DWORD dwUserIndex;
    Vector4 Position;
    Vector4 SkeletonPositions[ 20 ];
    NUI_SKELETON_POSITION_TRACKING_STATE eSkeletonPositionTrackingState[ 20 ];
    DWORD dwQualityFlags;
} 	NUI_SKELETON_DATA;


//	#pragma pack(push, 16)
typedef struct _NUI_SKELETON_FRAME
{
    LARGE_INTEGER liTimeStamp;
    DWORD dwFrameNumber;
    DWORD dwFlags;
    Vector4 vFloorClipPlane;
    Vector4 vNormalToGravity;
    NUI_SKELETON_DATA SkeletonData[ 6 ];
} 	NUI_SKELETON_FRAME;

typedef struct _NUI_LOCKED_RECT
{
	int32_t		Pitch;
	int32_t		size;
	uint8_t		*pBits;
} NUI_LOCKED_RECT;
]]
NUI_LOCKED_RECT = ffi.typeof("NUI_LOCKED_RECT")



require "INuiAudioBeam"
require "INuiFrameTexture"
require "INuiSensor"


ffi.cdef[[
HRESULT  NuiGetSensorCount(int * pCount );
HRESULT  NuiCreateSensorByIndex(int index, INuiSensor ** ppNuiSensor );
HRESULT  NuiCreateSensorById(const OLECHAR *strInstanceId, INuiSensor ** ppNuiSensor );
HRESULT  NuiGetAudioSource(INuiAudioBeam ** ppDmo );

typedef void (* NuiStatusProc)( HRESULT hrStatus, const OLECHAR* instanceName, const OLECHAR* uniqueDeviceName, void* pUserData );

void NuiSetDeviceStatusCallback( NuiStatusProc callback, void* pUserData );
]]






ffi.cdef[[
enum {
	MAX_DEV_STR_LEN = 512,
};

typedef struct
{
    wchar_t szDeviceName[MAX_DEV_STR_LEN];
    wchar_t szDeviceID[MAX_DEV_STR_LEN];
    int iDeviceIndex;
} NUI_MICROPHONE_ARRAY_DEVICE, *PNUI_MICROPHONE_ARRAY_DEVICE;


HRESULT NuiGetMicrophoneArrayDevices(PNUI_MICROPHONE_ARRAY_DEVICE pDeviceInfo, int size,  int *piDeviceCount);

typedef struct
{
    wchar_t szDeviceName[MAX_DEV_STR_LEN];
    int iDeviceIndex;
    bool fDefault;
} NUI_SPEAKER_DEVICE, *PNUI_SPEAKER_DEVICE;

HRESULT NuiGetSpeakerDevices(PNUI_SPEAKER_DEVICE pDeviceInfo, int size, int *piDeviceCount);
]]



function HasSkeletalEngine(pNuiSensor)

    if (not pNuiSensor) then
		return false;
	end

    return band(pNuiSensor.NuiInitializationFlags(), NUI_INITIALIZE_FLAG_USES_SKELETON) or
	band(pNuiSensor.NuiInitializationFlags(), NUI_INITIALIZE_FLAG_USES_DEPTH_AND_PLAYER_INDEX);
end
