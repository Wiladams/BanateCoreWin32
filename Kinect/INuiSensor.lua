
local ffi = require "ffi"

-- 1f5e088c-a8c7-41d3-9957-209677a13e85
IID_INuiSensor = DEFINE_UUID("IID_INuiSensor",0x1f5e088c,0xa8c7,0x41d3,0x99,0x57,0x20,0x96,0x77,0xa1,0x3e,0x85);

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

	HRESULT (  *NuiImageStreamSetImageFrameFlags )(INuiSensor * This,
            /* [in] */ HANDLE hStream,
            /* [in] */ DWORD dwImageFrameFlags);

	HRESULT (  *NuiImageStreamGetImageFrameFlags )(INuiSensor * This,
            /* [in] */ HANDLE hStream,
            /* [retval][out] */ DWORD *pdwImageFrameFlags);

	HRESULT (*NuiImageStreamGetNextFrame )(INuiSensor * This,
		HANDLE hStream,
        DWORD dwMillisecondsToWait,
        NUI_IMAGE_FRAME *pImageFrame);

	HRESULT (  *NuiImageStreamReleaseFrame )(INuiSensor * This,
            HANDLE hStream,
            NUI_IMAGE_FRAME *pImageFrame);

	HRESULT (  *NuiImageGetColorPixelCoordinatesFromDepthPixel )(INuiSensor * This,
            /* [in] */ NUI_IMAGE_RESOLUTION eColorResolution,
            /* [in] */ const NUI_IMAGE_VIEW_AREA *pcViewArea,
            /* [in] */ LONG lDepthX,
            /* [in] */ LONG lDepthY,
            /* [in] */ USHORT usDepthValue,
            /* [out] */ LONG *plColorX,
            /* [out] */ LONG *plColorY);

	HRESULT (*NuiImageGetColorPixelCoordinatesFromDepthPixelAtResolution )(INuiSensor * This,
            /* [in] */ NUI_IMAGE_RESOLUTION eColorResolution,
            /* [in] */ NUI_IMAGE_RESOLUTION eDepthResolution,
            /* [in] */ const NUI_IMAGE_VIEW_AREA *pcViewArea,
            /* [in] */ LONG lDepthX,
            /* [in] */ LONG lDepthY,
            /* [in] */ USHORT usDepthValue,
            /* [out] */ LONG *plColorX,
            /* [out] */ LONG *plColorY);

	HRESULT (*NuiImageGetColorPixelCoordinateFrameFromDepthPixelFrameAtResolution )(INuiSensor * This,
            /* [in] */ NUI_IMAGE_RESOLUTION eColorResolution,
            /* [in] */ NUI_IMAGE_RESOLUTION eDepthResolution,
            /* [in] */ DWORD cDepthValues,
            /* [size_is][in] */ USHORT *pDepthValues,
            /* [in] */ DWORD cColorCoordinates,
            /* [size_is][out][in] */ LONG *pColorCoordinates);

	HRESULT (  *NuiCameraElevationSetAngle )(INuiSensor * This,
            /* [in] */ LONG lAngleDegrees);

	HRESULT (  *NuiCameraElevationGetAngle )(INuiSensor * This,
            /* [retval][out] */ LONG *plAngleDegrees);

	HRESULT (  *NuiSkeletonTrackingEnable )(INuiSensor * This,
            /* [in] */ HANDLE hNextFrameEvent,
            /* [in] */ DWORD dwFlags);

	HRESULT (  *NuiSkeletonTrackingDisable )(INuiSensor * This);

	HRESULT (  *NuiSkeletonSetTrackedSkeletons )(INuiSensor * This,
            /* [size_is][in] */ DWORD *TrackingIDs);

	HRESULT (  *NuiSkeletonGetNextFrame )(INuiSensor * This,
            /* [in] */ DWORD dwMillisecondsToWait,
            /* [out][in] */ NUI_SKELETON_FRAME *pSkeletonFrame);

	HRESULT (  *NuiTransformSmooth )(INuiSensor * This,
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

INuiSensor = nil
INuiSensor_mt = {
	__index = {
	},
}
INuisensor = ffi.metatype("INuiSensor", INuiSensor_mt)

