ffi = require "ffi"
local C = ffi.C
local bit = require "bit"
local band = bit.band
local bor = bit.bor
local lshift = bit.lshift
local rshift = bit.rshift

require "guiddef"




--[[
	== NuiSensor.h ==
--]]

-- 1f5e088c-a8c7-41d3-9957-209677a13e85
IID_INuiSensor = DEFINE_UUID("IID_INuiSensor",0x1f5e088c,0xa8c7,0x41d3,0x99,0x57,0x20,0x96,0x77,0xa1,0x3e,0x85);

-- 13ea17f5-ff2e-4670-9ee5-1297a6e880d1
IID_INuiFrameTexture = DEFINE_UUID("IID_INuiFrameTexture",0x13ea17f5,0xff2e,0x4670,0x9e,0xe5,0x12,0x97,0xa6,0xe8,0x80,0xd1);

-- {8c3cebfa-a35d-497e-bc9a-e9752a8155e0}
IID_INuiAudioBeam = DEFINE_UUID("IID_INuiAudioBeam", 0x8c3cebfa, 0xa35d, 0x497e, 0xbc, 0x9a, 0xe9, 0x75, 0x2a, 0x81, 0x55, 0xe0);

NUI_SKELETON_COUNT = 6


ffi.cdef[[
typedef struct _Vector4
    {
    FLOAT x;
    FLOAT y;
    FLOAT z;
    FLOAT w;
    } 	Vector4;
]]

ffi.cdef[[

typedef
enum _NUI_SKELETON_POSITION_INDEX
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

typedef struct _NUI_SURFACE_DESC
    {
    UINT Width;
    UINT Height;
    } 	NUI_SURFACE_DESC;


typedef
enum _NUI_SKELETON_POSITION_TRACKING_STATE
    {	NUI_SKELETON_POSITION_NOT_TRACKED	= 0,
	NUI_SKELETON_POSITION_INFERRED	= ( NUI_SKELETON_POSITION_NOT_TRACKED + 1 ) ,
	NUI_SKELETON_POSITION_TRACKED	= ( NUI_SKELETON_POSITION_INFERRED + 1 )
    } 	NUI_SKELETON_POSITION_TRACKING_STATE;

typedef
enum _NUI_SKELETON_TRACKING_STATE
    {	NUI_SKELETON_NOT_TRACKED	= 0,
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
    INT		Pitch;
    INT		size;
    uint8_t	*pBits;
} NUI_LOCKED_RECT;
]]

MICARRAY_ADAPTIVE_BEAM = 0x1100



ffi.cdef[[
	typedef struct INuiAudioBeam INuiAudioBeam;

    typedef struct INuiAudioBeamVtbl
    {
        HRESULT (  *QueryInterface )(
            INuiAudioBeam * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
            void **ppvObject);

        ULONG (  *AddRef )(INuiAudioBeam * This);
        ULONG (  *Release )(INuiAudioBeam * This);


        HRESULT (  *GetBeam )(INuiAudioBeam * This,
            /* [retval][out] */ double *angle);

        HRESULT (  *SetBeam )(
            INuiAudioBeam * This,
            /* [in] */ double angle);

        HRESULT (  *GetPosition )(
            INuiAudioBeam * This,
            /* [out] */ double *angle,
            /* [out] */ double *confidence);

    } INuiAudioBeamVtbl;

    typedef struct INuiAudioBeam
    {
        INuiAudioBeamVtbl *lpVtbl;
    }INuiAudioBeam;
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

ffi.cdef[[
typedef struct INuiSensor INuiSensor;

typedef struct INuiSensorVtbl
{
	// IUnknown
	HRESULT (*QueryInterface)(INuiSensor * This,
		REFIID riid,
		void **ppvObject);

	ULONG (*AddRef)(INuiSensor * This);
	ULONG (*Release)(INuiSensor * This);


	// INuiSensor
	HRESULT (*NuiInitialize)(INuiSensor * This,
            /* [in] */ DWORD dwFlags);

	void (  *NuiShutdown )(INuiSensor * This);

	HRESULT (*NuiSetFrameEndEvent)(INuiSensor * This,
            /* [in] */ HANDLE hEvent,
            /* [in] */ DWORD dwFrameEventFlag);

	HRESULT (*NuiImageStreamOpen)(INuiSensor * This,
            NUI_IMAGE_TYPE eImageType,
            NUI_IMAGE_RESOLUTION eResolution,
            DWORD dwImageFrameFlags,
            DWORD dwFrameLimit,
            HANDLE hNextFrameEvent,
            HANDLE *phStreamHandle);

	HRESULT (  *NuiImageStreamSetImageFrameFlags )(
            INuiSensor * This,
            /* [in] */ HANDLE hStream,
            /* [in] */ DWORD dwImageFrameFlags);

	HRESULT (  *NuiImageStreamGetImageFrameFlags )(
            INuiSensor * This,
            /* [in] */ HANDLE hStream,
            /* [retval][out] */ DWORD *pdwImageFrameFlags);

	HRESULT (*NuiImageStreamGetNextFrame )(INuiSensor * This,
		HANDLE hStream,
        DWORD dwMillisecondsToWait,
        NUI_IMAGE_FRAME *pImageFrame);

	HRESULT (  *NuiImageStreamReleaseFrame )(
            INuiSensor * This,
            HANDLE hStream,
            NUI_IMAGE_FRAME *pImageFrame);

	HRESULT (  *NuiImageGetColorPixelCoordinatesFromDepthPixel )(
            INuiSensor * This,
            /* [in] */ NUI_IMAGE_RESOLUTION eColorResolution,
            /* [in] */ const NUI_IMAGE_VIEW_AREA *pcViewArea,
            /* [in] */ LONG lDepthX,
            /* [in] */ LONG lDepthY,
            /* [in] */ USHORT usDepthValue,
            /* [out] */ LONG *plColorX,
            /* [out] */ LONG *plColorY);

	HRESULT (*NuiImageGetColorPixelCoordinatesFromDepthPixelAtResolution )(
            INuiSensor * This,
            /* [in] */ NUI_IMAGE_RESOLUTION eColorResolution,
            /* [in] */ NUI_IMAGE_RESOLUTION eDepthResolution,
            /* [in] */ const NUI_IMAGE_VIEW_AREA *pcViewArea,
            /* [in] */ LONG lDepthX,
            /* [in] */ LONG lDepthY,
            /* [in] */ USHORT usDepthValue,
            /* [out] */ LONG *plColorX,
            /* [out] */ LONG *plColorY);

	HRESULT (*NuiImageGetColorPixelCoordinateFrameFromDepthPixelFrameAtResolution )(
            INuiSensor * This,
            /* [in] */ NUI_IMAGE_RESOLUTION eColorResolution,
            /* [in] */ NUI_IMAGE_RESOLUTION eDepthResolution,
            /* [in] */ DWORD cDepthValues,
            /* [size_is][in] */ USHORT *pDepthValues,
            /* [in] */ DWORD cColorCoordinates,
            /* [size_is][out][in] */ LONG *pColorCoordinates);

	HRESULT (  *NuiCameraElevationSetAngle )(
            INuiSensor * This,
            /* [in] */ LONG lAngleDegrees);

	HRESULT (  *NuiCameraElevationGetAngle )(
            INuiSensor * This,
            /* [retval][out] */ LONG *plAngleDegrees);

	HRESULT (  *NuiSkeletonTrackingEnable )(
            INuiSensor * This,
            /* [in] */ HANDLE hNextFrameEvent,
            /* [in] */ DWORD dwFlags);

	HRESULT (  *NuiSkeletonTrackingDisable )(
            INuiSensor * This);

	HRESULT (  *NuiSkeletonSetTrackedSkeletons )(
            INuiSensor * This,
            /* [size_is][in] */ DWORD *TrackingIDs);

	HRESULT (  *NuiSkeletonGetNextFrame )(
            INuiSensor * This,
            /* [in] */ DWORD dwMillisecondsToWait,
            /* [out][in] */ NUI_SKELETON_FRAME *pSkeletonFrame);

	HRESULT (  *NuiTransformSmooth )(
            INuiSensor * This,
            NUI_SKELETON_FRAME *pSkeletonFrame,
            const NUI_TRANSFORM_SMOOTH_PARAMETERS *pSmoothingParams);

        /* [helpstring] */ HRESULT (  *NuiGetAudioSource )(
            INuiSensor * This,
            /* [out] */ INuiAudioBeam **ppDmo);

	int (*NuiInstanceIndex)(INuiSensor * This);

	BSTR (*NuiDeviceConnectionId)(INuiSensor * This);

	BSTR (*NuiUniqueId)(INuiSensor * This);

	BSTR (*NuiAudioArrayId)(INuiSensor * This);

	HRESULT (*NuiStatus)(INuiSensor * This);

	DWORD (*NuiInitializationFlags)(INuiSensor * This);

} INuiSensorVtbl;

typedef struct INuiSensor
{
	INuiSensorVtbl *lpVtbl;
} INuiSensor, *PINuiSensor;

]]

INuiSensor = ffi.typeof("INuiSensor")

ffi.cdef[[
HRESULT  NuiGetSensorCount(int * pCount );
HRESULT  NuiCreateSensorByIndex(int index, INuiSensor ** ppNuiSensor );
HRESULT  NuiCreateSensorById(const OLECHAR *strInstanceId, INuiSensor ** ppNuiSensor );
HRESULT  NuiGetAudioSource(INuiAudioBeam ** ppDmo );

typedef void (* NuiStatusProc)( HRESULT hrStatus, const OLECHAR* instanceName, const OLECHAR* uniqueDeviceName, void* pUserData );

void NuiSetDeviceStatusCallback( NuiStatusProc callback, void* pUserData );
]]


function HasSkeletalEngine(pNuiSensor)

    if (not pNuiSensor) then
		return false;
	end

    return band(pNuiSensor.NuiInitializationFlags(), NUI_INITIALIZE_FLAG_USES_SKELETON) or
	band(pNuiSensor.NuiInitializationFlags(), NUI_INITIALIZE_FLAG_USES_DEPTH_AND_PLAYER_INDEX);
end


--MAX_DEV_STR_LEN = 512

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


//Fills the array of KINECT_AUDIO_DEVICE structs with the Kinect devices found on the system.
//
//pDeviceInfo: Array allocated by the caller, upon return contains the device information for up to piDeviceCount devices. Can be null
//to just retrieve the number of items in piDeviceCount
//size [in]: The number of items in the array
//piDeviceCount [out]: The actual number of devices found.
HRESULT NuiGetMicrophoneArrayDevices(PNUI_MICROPHONE_ARRAY_DEVICE pDeviceInfo, int size,  int *piDeviceCount);

typedef struct
{
    wchar_t szDeviceName[MAX_DEV_STR_LEN];
    int iDeviceIndex;
    bool fDefault;
} NUI_SPEAKER_DEVICE, *PNUI_SPEAKER_DEVICE;

//Fills the array of NUI_SPEAKER_DEVICE structs with the active speaker devices found on the system.
//
//pDeviceInfo: Array allocated by the caller, upon return contains the device information for up to piDeviceCount devices. Can be null
//to just retrieve the number of items in piDeviceCount
//size [in]: The number of items in the array
//piDeviceCount [out]: The actual number of devices found.
HRESULT NuiGetSpeakerDevices(PNUI_SPEAKER_DEVICE pDeviceInfo, int size, int *piDeviceCount);
]]


