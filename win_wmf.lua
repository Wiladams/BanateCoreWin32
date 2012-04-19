local ffi = require "ffi"

require "WinBase"
require "win32_IUnknown"

--[[
	From mfobjects.h
--]]

ffi.cdef[[
typedef struct IMFAttributes IMFAttributes;
typedef struct IMFMediaBuffer IMFMediaBuffer;
typedef struct IMFSample IMFSample;
typedef struct IMF2DBuffer IMF2DBuffer;
typedef struct IMFMediaType IMFMediaType;
typedef struct IMFAudioMediaType IMFAudioMediaType;
typedef struct IMFVideoMediaType IMFVideoMediaType;
typedef struct IMFAsyncResult IMFAsyncResult;
typedef struct IMFAsyncCallback IMFAsyncCallback;
typedef struct IMFMediaEvent IMFMediaEvent;
typedef struct IMFMediaEventGenerator IMFMediaEventGenerator;
typedef struct IMFRemoteAsyncCallback IMFRemoteAsyncCallback;
typedef struct IMFByteStream IMFByteStream;
typedef struct IMFCollection IMFCollection;
typedef struct IMFMediaEventQueue IMFMediaEventQueue;
typedef struct IMFActivate IMFActivate;
typedef struct IMFPluginControl IMFPluginControl;


]]

--[[
	From mediaobj.h
--]]
ffi.cdef[[
typedef struct IMediaBuffer IMediaBuffer;
typedef struct IMediaObject IMediaObject;
typedef struct IEnumDMO IEnumDMO;
typedef struct IMediaObjectInPlace IMediaObjectInPlace;
typedef struct IDMOQualityControl IDMOQualityControl;
typedef struct IDMOVideoOutputOptimizations IDMOVideoOutputOptimizations;



typedef struct _DMOMediaType
    {
    GUID majortype;
    GUID subtype;
    BOOL bFixedSizeSamples;
    BOOL bTemporalCompression;
    ULONG lSampleSize;
    GUID formattype;
    IUnknown *pUnk;
    ULONG cbFormat;
    BYTE *pbFormat;
    } 	DMO_MEDIA_TYPE;

typedef LONGLONG REFERENCE_TIME;


enum _DMO_INPUT_DATA_BUFFER_FLAGS
    {	DMO_INPUT_DATA_BUFFERF_SYNCPOINT	= 0x1,
	DMO_INPUT_DATA_BUFFERF_TIME	= 0x2,
	DMO_INPUT_DATA_BUFFERF_TIMELENGTH	= 0x4
    } ;

enum _DMO_OUTPUT_DATA_BUFFER_FLAGS
    {	DMO_OUTPUT_DATA_BUFFERF_SYNCPOINT	= 0x1,
	DMO_OUTPUT_DATA_BUFFERF_TIME	= 0x2,
	DMO_OUTPUT_DATA_BUFFERF_TIMELENGTH	= 0x4,
	DMO_OUTPUT_DATA_BUFFERF_INCOMPLETE	= 0x1000000
    } ;

enum _DMO_INPUT_STATUS_FLAGS
    {	DMO_INPUT_STATUSF_ACCEPT_DATA	= 0x1
    } ;

enum _DMO_INPUT_STREAM_INFO_FLAGS
    {	DMO_INPUT_STREAMF_WHOLE_SAMPLES	= 0x1,
	DMO_INPUT_STREAMF_SINGLE_SAMPLE_PER_BUFFER	= 0x2,
	DMO_INPUT_STREAMF_FIXED_SAMPLE_SIZE	= 0x4,
	DMO_INPUT_STREAMF_HOLDS_BUFFERS	= 0x8
    } ;

enum _DMO_OUTPUT_STREAM_INFO_FLAGS
    {	DMO_OUTPUT_STREAMF_WHOLE_SAMPLES	= 0x1,
	DMO_OUTPUT_STREAMF_SINGLE_SAMPLE_PER_BUFFER	= 0x2,
	DMO_OUTPUT_STREAMF_FIXED_SAMPLE_SIZE	= 0x4,
	DMO_OUTPUT_STREAMF_DISCARDABLE	= 0x8,
	DMO_OUTPUT_STREAMF_OPTIONAL	= 0x10
    } ;

enum _DMO_SET_TYPE_FLAGS
    {	DMO_SET_TYPEF_TEST_ONLY	= 0x1,
	DMO_SET_TYPEF_CLEAR	= 0x2
    } ;

enum _DMO_PROCESS_OUTPUT_FLAGS
    {	DMO_PROCESS_OUTPUT_DISCARD_WHEN_NO_BUFFER	= 0x1
    } ;
]]


IID_IMediaBuffer = UUIDFromString("59eff8b9-938c-4a26-82f2-95cb84cdc837");

ffi.cdef[[
    typedef struct IMediaBufferVtbl
    {

        HRESULT ( *QueryInterface )(IMediaBuffer * This, REFIID riid, void **ppvObject);

        ULONG ( *AddRef )(IMediaBuffer * This);

        ULONG ( *Release )(IMediaBuffer * This);


        HRESULT ( *SetLength )(
            IMediaBuffer * This,
            DWORD cbLength);

        HRESULT ( *GetMaxLength )(
            IMediaBuffer * This,
            /* [annotation][out] */
            DWORD *pcbMaxLength);

        HRESULT ( *GetBufferAndLength )(
            IMediaBuffer * This,
            /* [annotation][out] */
            BYTE **ppBuffer,
            /* [annotation][out] */
            DWORD *pcbLength);

    } IMediaBufferVtbl;

    typedef struct IMediaBuffer
    {
        struct IMediaBufferVtbl *lpVtbl;
    }IMediaBuffer;

]]

ffi.cdef[[
typedef struct _DMO_OUTPUT_DATA_BUFFER
    {
    IMediaBuffer *pBuffer;
    DWORD dwStatus;
    REFERENCE_TIME rtTimestamp;
    REFERENCE_TIME rtTimelength;
    } 	DMO_OUTPUT_DATA_BUFFER;

typedef struct _DMO_OUTPUT_DATA_BUFFER *PDMO_OUTPUT_DATA_BUFFER;


]]

IID_IMediaObject = UUIDFromString("d8ad0f58-5494-4102-97c5-ec798e59bcf4");


ffi.cdef[[
   typedef struct IMediaObjectVtbl
    {

        HRESULT (  *QueryInterface )(
            IMediaObject * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
              void **ppvObject);

        ULONG (  *AddRef )(
            IMediaObject * This);

        ULONG (  *Release )(
            IMediaObject * This);

        HRESULT (  *GetStreamCount )(
            IMediaObject * This,
            /* [annotation][out] */
              DWORD *pcInputStreams,
            /* [annotation][out] */
              DWORD *pcOutputStreams);

        HRESULT (  *GetInputStreamInfo )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            /* [annotation][out] */
              DWORD *pdwFlags);

        HRESULT (  *GetOutputStreamInfo )(
            IMediaObject * This,
            DWORD dwOutputStreamIndex,
            /* [annotation][out] */
              DWORD *pdwFlags);

        HRESULT (  *GetInputType )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            DWORD dwTypeIndex,
            /* [annotation][out] */
            DMO_MEDIA_TYPE *pmt);

        HRESULT (  *GetOutputType )(
            IMediaObject * This,
            DWORD dwOutputStreamIndex,
            DWORD dwTypeIndex,
            /* [annotation][out] */
            DMO_MEDIA_TYPE *pmt);

        HRESULT (  *SetInputType )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            /* [annotation][in] */
            const DMO_MEDIA_TYPE *pmt,
            DWORD dwFlags);

        HRESULT (  *SetOutputType )(
            IMediaObject * This,
            DWORD dwOutputStreamIndex,
            /* [annotation][in] */
            const DMO_MEDIA_TYPE *pmt,
            DWORD dwFlags);

        HRESULT (  *GetInputCurrentType )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            /* [annotation][out] */
            DMO_MEDIA_TYPE *pmt);

        HRESULT (  *GetOutputCurrentType )(
            IMediaObject * This,
            DWORD dwOutputStreamIndex,
            /* [annotation][out] */
              DMO_MEDIA_TYPE *pmt);

        HRESULT (  *GetInputSizeInfo )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            /* [annotation][out] */
              DWORD *pcbSize,
            /* [annotation][out] */
              DWORD *pcbMaxLookahead,
            /* [annotation][out] */
              DWORD *pcbAlignment);

        HRESULT (  *GetOutputSizeInfo )(
            IMediaObject * This,
            DWORD dwOutputStreamIndex,
            /* [annotation][out] */
              DWORD *pcbSize,
            /* [annotation][out] */
              DWORD *pcbAlignment);

        HRESULT (  *GetInputMaxLatency )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            /* [annotation][out] */
              REFERENCE_TIME *prtMaxLatency);

        HRESULT (  *SetInputMaxLatency )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            REFERENCE_TIME rtMaxLatency);

        HRESULT (  *Flush )(
            IMediaObject * This);

        HRESULT (  *Discontinuity )(
            IMediaObject * This,
            DWORD dwInputStreamIndex);

        HRESULT (  *AllocateStreamingResources )(
            IMediaObject * This);

        HRESULT (  *FreeStreamingResources )(
            IMediaObject * This);

        HRESULT (  *GetInputStatus )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            /* [annotation][out] */
              DWORD *dwFlags);

        HRESULT (  *ProcessInput )(
            IMediaObject * This,
            DWORD dwInputStreamIndex,
            IMediaBuffer *pBuffer,
            DWORD dwFlags,
            REFERENCE_TIME rtTimestamp,
            REFERENCE_TIME rtTimelength);

        HRESULT (  *ProcessOutput )(
            IMediaObject * This,
            DWORD dwFlags,
            DWORD cOutputBufferCount,
            /* [annotation][size_is][out][in] */
            DMO_OUTPUT_DATA_BUFFER *pOutputBuffers,
            /* [annotation][out] */
              DWORD *pdwStatus);

        HRESULT (  *Lock )(
            IMediaObject * This,
            LONG bLock);

    } IMediaObjectVtbl;

    typedef struct IMediaObject
    {
        struct IMediaObjectVtbl *lpVtbl;
    };
]]




IID_IEnumDMO = UUIDFromString("2c3cd98a-2bfa-4a53-9c27-5249ba64ba0f")

ffi.cdef[[
    typedef struct IEnumDMOVtbl
    {

        HRESULT (  *QueryInterface )(
            IEnumDMO * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
              void **ppvObject);

        ULONG (  *AddRef )(
            IEnumDMO * This);

        ULONG (  *Release )(
            IEnumDMO * This);

        HRESULT (  *Next )(
            IEnumDMO * This,
            DWORD cItemsToFetch,
            /* [annotation][length_is][size_is][out] */
            CLSID *pCLSID,
            /* [annotation][string][length_is][size_is][out] */
            LPWSTR *Names,
            /* [annotation][out] */
              DWORD *pcItemsFetched);

        HRESULT (  *Skip )(
            IEnumDMO * This,
            DWORD cItemsToSkip);

        HRESULT (  *Reset )(
            IEnumDMO * This);

        HRESULT (  *Clone )(
            IEnumDMO * This,
            /* [annotation][out] */
              IEnumDMO **ppEnum);

    } IEnumDMOVtbl;

    typedef struct IEnumDMO
    {
        struct IEnumDMOVtbl *lpVtbl;
    };
]]


ffi.cdef[[
enum _DMO_INPLACE_PROCESS_FLAGS
    {	DMO_INPLACE_NORMAL	= 0,
	DMO_INPLACE_ZERO	= 0x1
    } ;
]]

IID_IMediaObjectInPlace = UUIDFromString("651b9ad0-0fc7-4aa9-9538-d89931010741");

ffi.cdef[[

    typedef struct IMediaObjectInPlaceVtbl
    {

        HRESULT (  *QueryInterface )(
            IMediaObjectInPlace * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
              void **ppvObject);

        ULONG (  *AddRef )(
            IMediaObjectInPlace * This);

        ULONG (  *Release )(
            IMediaObjectInPlace * This);

        HRESULT (  *Process )(
            IMediaObjectInPlace * This,
            /* [in] */ ULONG ulSize,
            /* [annotation][size_is][out][in] */
            BYTE *pData,
            /* [in] */ REFERENCE_TIME refTimeStart,
            /* [in] */ DWORD dwFlags);

        HRESULT (  *Clone )(
            IMediaObjectInPlace * This,
            /* [annotation][out] */
              IMediaObjectInPlace **ppMediaObject);

        HRESULT (  *GetLatency )(
            IMediaObjectInPlace * This,
            /* [annotation][out] */
              REFERENCE_TIME *pLatencyTime);

    } IMediaObjectInPlaceVtbl;

    typedef struct IMediaObjectInPlace
    {
        struct IMediaObjectInPlaceVtbl *lpVtbl;
    };
]]


IID_IDMOQualityControl = UUIDFromString("65abea96-cf36-453f-af8a-705e98f16260")


ffi.cdef[[
enum _DMO_QUALITY_STATUS_FLAGS
    {	DMO_QUALITY_STATUS_ENABLED	= 0x1
    } ;


    typedef struct IDMOQualityControlVtbl
    {

        HRESULT (  *QueryInterface )(
            IDMOQualityControl * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
              void **ppvObject);

        ULONG (  *AddRef )(
            IDMOQualityControl * This);

        ULONG (  *Release )(
            IDMOQualityControl * This);

        HRESULT (  *SetNow )(
            IDMOQualityControl * This,
            /* [in] */ REFERENCE_TIME rtNow);

        HRESULT (  *SetStatus )(
            IDMOQualityControl * This,
            /* [in] */ DWORD dwFlags);

        HRESULT (  *GetStatus )(
            IDMOQualityControl * This,
            /* [annotation][out] */
              DWORD *pdwFlags);

    } IDMOQualityControlVtbl;

    typedef struct IDMOQualityControl
    {
        struct IDMOQualityControlVtbl *lpVtbl;
    };
]]


ffi.cdef[[
enum _DMO_VIDEO_OUTPUT_STREAM_FLAGS
    {	DMO_VOSF_NEEDS_PREVIOUS_SAMPLE	= 0x1
    } ;

]]

IID_IDMOVideoOutputOptimizations = UUIDFromString("be8f4f4e-5b16-4d29-b350-7f6b5d9298ac")

ffi.cdef[[
    typedef struct IDMOVideoOutputOptimizationsVtbl
    {
        HRESULT (  *QueryInterface )(
            IDMOVideoOutputOptimizations * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */
              void **ppvObject);

        ULONG (  *AddRef )(
            IDMOVideoOutputOptimizations * This);

        ULONG (  *Release )(
            IDMOVideoOutputOptimizations * This);

        HRESULT (  *QueryOperationModePreferences )(
            IDMOVideoOutputOptimizations * This,
            ULONG ulOutputStreamIndex,
            /* [annotation] */
              DWORD *pdwRequestedCapabilities);

        HRESULT (  *SetOperationMode )(
            IDMOVideoOutputOptimizations * This,
            ULONG ulOutputStreamIndex,
            DWORD dwEnabledFeatures);

        HRESULT (  *GetCurrentOperationMode )(
            IDMOVideoOutputOptimizations * This,
            ULONG ulOutputStreamIndex,
            /* [annotation] */
              DWORD *pdwEnabledFeatures);

        HRESULT (  *GetCurrentSampleRequirements )(
            IDMOVideoOutputOptimizations * This,
            ULONG ulOutputStreamIndex,
            /* [annotation] */
              DWORD *pdwRequestedFeatures);

    } IDMOVideoOutputOptimizationsVtbl;

    typedef struct IDMOVideoOutputOptimizations
    {
        struct IDMOVideoOutputOptimizationsVtbl *lpVtbl;
    };
]]




--[[
	From mfidl.h
--]]

ffi.cdef[[
typedef struct IMFMediaSession IMFMediaSession;
typedef struct IMFSourceResolver IMFSourceResolver;
typedef struct IMFMediaSource IMFMediaSource;
typedef struct IMFMediaStream IMFMediaStream;
typedef struct IMFMediaSink IMFMediaSink;
typedef struct IMFStreamSink IMFStreamSink;
typedef struct IMFVideoSampleAllocator IMFVideoSampleAllocator;
typedef struct IMFVideoSampleAllocatorNotify IMFVideoSampleAllocatorNotify;
typedef struct IMFVideoSampleAllocatorCallback IMFVideoSampleAllocatorCallback;
typedef struct IMFTopology IMFTopology;
typedef struct IMFTopologyNode IMFTopologyNode;
typedef struct IMFGetService IMFGetService;
typedef struct IMFClock IMFClock;
typedef struct IMFPresentationClock IMFPresentationClock;
typedef struct IMFPresentationTimeSource IMFPresentationTimeSource;
typedef struct IMFClockStateSink IMFClockStateSink;
typedef struct IMFPresentationDescriptor IMFPresentationDescriptor;
typedef struct IMFStreamDescriptor IMFStreamDescriptor;
typedef struct IMFMediaTypeHandler IMFMediaTypeHandler;
typedef struct IMFTimer IMFTimer;
typedef struct IMFShutdown IMFShutdown;
typedef struct IMFTopoLoader IMFTopoLoader;
typedef struct IMFContentProtectionManager IMFContentProtectionManager;
typedef struct IMFContentEnabler IMFContentEnabler;
typedef struct IMFMetadata IMFMetadata;
typedef struct IMFMetadataProvider IMFMetadataProvider;
typedef struct IMFRateSupport IMFRateSupport;
typedef struct IMFRateControl IMFRateControl;
typedef struct IMFTimecodeTranslate IMFTimecodeTranslate;
typedef struct IMFSimpleAudioVolume IMFSimpleAudioVolume;
typedef struct IMFAudioStreamVolume IMFAudioStreamVolume;
typedef struct IMFAudioPolicy IMFAudioPolicy;
typedef struct IMFSampleGrabberSinkCallback IMFSampleGrabberSinkCallback;
typedef struct IMFSampleGrabberSinkCallback2 IMFSampleGrabberSinkCallback2;
typedef struct IMFWorkQueueServices IMFWorkQueueServices;
typedef struct IMFQualityManager IMFQualityManager;
typedef struct IMFQualityAdvise IMFQualityAdvise;
typedef struct IMFQualityAdvise2 IMFQualityAdvise2;
typedef struct IMFQualityAdviseLimits IMFQualityAdviseLimits;
typedef struct IMFRealTimeClient IMFRealTimeClient;
typedef struct IMFSequencerSource IMFSequencerSource;
typedef struct IMFMediaSourceTopologyProvider IMFMediaSourceTopologyProvider;
typedef struct IMFMediaSourcePresentationProvider IMFMediaSourcePresentationProvider;
typedef struct IMFTopologyNodeAttributeEditor IMFTopologyNodeAttributeEditor;
typedef struct IMFByteStreamBuffering IMFByteStreamBuffering;
typedef struct IMFByteStreamCacheControl IMFByteStreamCacheControl;
typedef struct IMFNetCredential IMFNetCredential;
typedef struct IMFNetCredentialManager IMFNetCredentialManager;
typedef struct IMFNetCredentialCache IMFNetCredentialCache;
typedef struct IMFSSLCertificateManager IMFSSLCertificateManager;
typedef struct IMFSourceOpenMonitor IMFSourceOpenMonitor;
typedef struct IMFNetProxyLocator IMFNetProxyLocator;
typedef struct IMFNetProxyLocatorFactory IMFNetProxyLocatorFactory;
typedef struct IMFSaveJob IMFSaveJob;
typedef struct IMFNetSchemeHandlerConfig IMFNetSchemeHandlerConfig;
typedef struct IMFSchemeHandler IMFSchemeHandler;
typedef struct IMFByteStreamHandler IMFByteStreamHandler;
typedef struct IMFTrustedInput IMFTrustedInput;
typedef struct IMFInputTrustAuthority IMFInputTrustAuthority;
typedef struct IMFTrustedOutput IMFTrustedOutput;
typedef struct IMFOutputTrustAuthority IMFOutputTrustAuthority;
typedef struct IMFOutputPolicy IMFOutputPolicy;
typedef struct IMFOutputSchema IMFOutputSchema;
typedef struct IMFSecureChannel IMFSecureChannel;
typedef struct IMFSampleProtection IMFSampleProtection;
typedef struct IMFMediaSinkPreroll IMFMediaSinkPreroll;
typedef struct IMFFinalizableMediaSink IMFFinalizableMediaSink;
typedef struct IMFStreamingSinkConfig IMFStreamingSinkConfig;
typedef struct IMFRemoteProxy IMFRemoteProxy;
typedef struct IMFObjectReferenceStream IMFObjectReferenceStream;
typedef struct IMFPMPHost IMFPMPHost;
typedef struct IMFPMPClient IMFPMPClient;
typedef struct IMFPMPServer IMFPMPServer;
typedef struct IMFRemoteDesktopPlugin IMFRemoteDesktopPlugin;
typedef struct IMFSAMIStyle IMFSAMIStyle;
typedef struct IMFTranscodeProfile IMFTranscodeProfile;
typedef struct IMFTranscodeSinkInfoProvider IMFTranscodeSinkInfoProvider;
typedef struct IMFFieldOfUseMFTUnlock IMFFieldOfUseMFTUnlock;
typedef struct IMFLocalMFTRegistration IMFLocalMFTRegistration;







typedef enum MFSESSION_SETTOPOLOGY_FLAGS
    {	MFSESSION_SETTOPOLOGY_IMMEDIATE	= 0x1,
	MFSESSION_SETTOPOLOGY_NORESOLUTION	= 0x2,
	MFSESSION_SETTOPOLOGY_CLEAR_CURRENT	= 0x4
    } 	MFSESSION_SETTOPOLOGY_FLAGS;

typedef enum MFSESSION_GETFULLTOPOLOGY_FLAGS
    {	MFSESSION_GETFULLTOPOLOGY_CURRENT	= 0x1
    } 	MFSESSION_GETFULLTOPOLOGY_FLAGS;

typedef enum MFPMPSESSION_CREATION_FLAGS
    {	MFPMPSESSION_UNPROTECTED_PROCESS	= 0x1
    } 	MFPMPSESSION_CREATION_FLAGS;

typedef uint64_t TOPOID;



]]

--[[
function CreateVideoDeviceSource(IMFMediaSource **ppSource)

    *ppSource = nil;

    IMFMediaSource *pSource = NULL;
    IMFAttributes *pAttributes = NULL;
    IMFActivate **ppDevices = NULL;

    // Create an attribute store to specify the enumeration parameters.
    HRESULT hr = MFCreateAttributes(&pAttributes, 1);
    if (FAILED(hr))
    {
        goto done;
    }

    // Source type: video capture devices
    hr = pAttributes.SetGUID(
        MF_DEVSOURCE_ATTRIBUTE_SOURCE_TYPE,
        MF_DEVSOURCE_ATTRIBUTE_SOURCE_TYPE_VIDCAP_GUID
        );
    if (FAILED(hr))
    {
        goto done;
    }

    -- Enumerate devices.
    local count;
    hr = MFEnumDeviceSources(pAttributes, &ppDevices, &count);

    if (FAILED(hr)) then

        goto done;
    end

    if (count == 0) then
        hr = E_FAIL;
        goto done;
    end

    -- Create the media source object.
    hr = ppDevices[0].ActivateObject(IID_PPV_ARGS(&pSource));
    if (FAILED(hr)) then

        goto done;
    end

    *ppSource = pSource;
    (*ppSource)->AddRef();

done:
    SafeRelease(&pAttributes);

    for (i = 0, count-1) do
        SafeRelease(&ppDevices[i]);
    end
    CoTaskMemFree(ppDevices);
    SafeRelease(&pSource);

	return hr;
end
--]]

--[[
-- After using resources
-- release them
   SafeRelease(&pAttributes);

    for (DWORD i = 0; i < count; i++)
    {
        SafeRelease(&ppDevices[i]);
    }
    CoTaskMemFree(ppDevices);
--]]

