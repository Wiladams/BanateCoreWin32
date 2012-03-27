-- NuiSkeleton.h

local ffi = require "ffi"

ffi.cdef[[
HRESULT NuiTransformSmooth(NUI_SKELETON_FRAME *pSkeletonFrame,
    const NUI_TRANSFORM_SMOOTH_PARAMETERS *pSmoothingParams);
]]

FLT_EPSILON     = 1.192092896e-07        -- smallest such that 1.0+FLT_EPSILON != 1.0

--
--  Number of NUI_SKELETON_DATA elements that can be in the NUI_SKELETON_TRACKED state
--

NUI_SKELETON_MAX_TRACKED_COUNT = 2

--
--  Tracking IDs start at 1
--

NUI_SKELETON_INVALID_TRACKING_ID =0


NUI_SKELETON_QUALITY_CLIPPED_RIGHT  = 0x00000001
NUI_SKELETON_QUALITY_CLIPPED_LEFT   = 0x00000002
NUI_SKELETON_QUALITY_CLIPPED_TOP    = 0x00000004
NUI_SKELETON_QUALITY_CLIPPED_BOTTOM = 0x00000008


NUI_SKELETON_TRACKING_FLAG_SUPPRESS_NO_FRAME_DATA       =0x00000001
NUI_SKELETON_TRACKING_FLAG_TITLE_SETS_TRACKED_SKELETONS =0x00000002


ffi.cdef[[
HRESULT NuiSkeletonTrackingEnable(HANDLE hNextFrameEvent, DWORD  dwFlags);

HRESULT NuiSkeletonTrackingDisable();

HRESULT NuiSkeletonGetNextFrame(DWORD dwMillisecondsToWait, NUI_SKELETON_FRAME *pSkeletonFrame);

HRESULT NuiSkeletonSetTrackedSkeletons(DWORD *TrackingIDs);
]]


--[[
// Assuming a pixel resolution of 320x240
// x_meters = (x_pixelcoord - 160) * NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 * z_meters;
// y_meters = (y_pixelcoord - 120) * NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 * z_meters;
#define NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 (NUI_CAMERA_DEPTH_NOMINAL_INVERSE_FOCAL_LENGTH_IN_PIXELS)

// Assuming a pixel resolution of 320x240
// x_pixelcoord = (x_meters) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / z_meters + 160;
// y_pixelcoord = (y_meters) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / z_meters + 120;
#define NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 (NUI_CAMERA_DEPTH_NOMINAL_FOCAL_LENGTH_IN_PIXELS)
--]]

--[[
function NuiTransformSkeletonToDepthImage(
    Vector4 vPoint,
    LONG *plDepthX,
    LONG *plDepthY,
    USHORT *pusDepthValue,
    NUI_IMAGE_RESOLUTION eResolution)
{
    if((plDepthX == nil) or (plDepthY == nil) or (pusDepthValue == nil)) then

        return;
    end

    --
    -- Requires a valid depth value.
    --

    if(vPoint.z > FLT_EPSILON) then

        DWORD width;
        DWORD height;
        NuiImageResolutionToSize( eResolution, width, height );

        //
        // Center of depth sensor is at (0,0,0) in skeleton space, and
        // and (width/2,height/2) in depth image coordinates.  Note that positive Y
        // is up in skeleton space and down in image coordinates.
        //
        // The 0.5f is to correct for casting to int truncating, not rounding

        *plDepthX = static_cast<INT>( width / 2 + vPoint.x * (width/320.f) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / vPoint.z + 0.5f);
        *plDepthY = static_cast<INT>( height / 2 - vPoint.y * (height/240.f) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / vPoint.z + 0.5f);

        //
        //  Depth is in meters in skeleton space.
        //  The depth image pixel format has depth in millimeters shifted left by 3.
        //

        *pusDepthValue = static_cast<USHORT>(vPoint.z *1000) << 3;
    else

        *plDepthX = 0;
        *plDepthY = 0;
        *pusDepthValue = 0;
    end
end

function NuiTransformSkeletonToDepthImage(
    Vector4 vPoint,
    LONG *plDepthX,
    LONG *plDepthY,
    USHORT *pusDepthValue)

    NuiTransformSkeletonToDepthImage( vPoint, plDepthX, plDepthY, pusDepthValue, NUI_IMAGE_RESOLUTION_320x240);
end


function NuiTransformSkeletonToDepthImage(
    Vector4 vPoint,
    FLOAT *pfDepthX,
    FLOAT *pfDepthY,
    NUI_IMAGE_RESOLUTION eResolution)

    if((pfDepthX == NULL) || (pfDepthY == NULL))
    {
        return;
    }

    //
    // Requires a valid depth value.
    //

    if(vPoint.z > FLT_EPSILON)
    {
        DWORD width;
        DWORD height;
        NuiImageResolutionToSize( eResolution, width, height );

        //
        // Center of depth sensor is at (0,0,0) in skeleton space, and
        // and (width/2,height/2) in depth image coordinates.  Note that positive Y
        // is up in skeleton space and down in image coordinates.
        //

        *pfDepthX = width / 2 + vPoint.x * (width/320.f) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / vPoint.z;
        *pfDepthY = height / 2 - vPoint.y * (height/240.f) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / vPoint.z;

    } else
    {
        *pfDepthX = 0.0f;
        *pfDepthY = 0.0f;
    }
end

inline
VOID
NuiTransformSkeletonToDepthImage(
    _In_ Vector4 vPoint,
    _Out_ FLOAT *pfDepthX,
    _Out_ FLOAT *pfDepthY
    )
{
    NuiTransformSkeletonToDepthImage(vPoint, pfDepthX, pfDepthY, NUI_IMAGE_RESOLUTION_320x240);
}

function NuiTransformDepthImageToSkeleton(LONG lDepthX,LONG lDepthY,
    USHORT usDepthValue, NUI_IMAGE_RESOLUTION eResolution)
{
    DWORD width;
    DWORD height;
    NuiImageResolutionToSize( eResolution, width, height );

    //
    //  Depth is in meters in skeleton space.
    //  The depth image pixel format has depth in millimeters shifted left by 3.
    //

    FLOAT fSkeletonZ = static_cast<FLOAT>(usDepthValue >> 3) / 1000.0f;

    //
    // Center of depth sensor is at (0,0,0) in skeleton space, and
    // and (width/2,height/2) in depth image coordinates.  Note that positive Y
    // is up in skeleton space and down in image coordinates.
    //

    FLOAT fSkeletonX = (lDepthX - width/2.0f) * (320.0f/width) * NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 * fSkeletonZ;
    FLOAT fSkeletonY = -(lDepthY - height/2.0f) * (240.0f/height) * NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 * fSkeletonZ;

    //
    // Return the result as a vector.
    //

    Vector4 v4;
    v4.x = fSkeletonX;
    v4.y = fSkeletonY;
    v4.z = fSkeletonZ;
    v4.w = 1.0f;
    return v4;
}

function NuiTransformDepthImageToSkeleton(LONG lDepthX, LONG lDepthY, USHORT usDepthValue)
    return NuiTransformDepthImageToSkeleton(lDepthX, lDepthY, usDepthValue, NUI_IMAGE_RESOLUTION_320x240);
end
--]]





