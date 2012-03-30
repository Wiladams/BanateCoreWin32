local ffi = require"ffi"
local C = ffi.C

ffi.cdef[[
	typedef struct { float Red, Green, Blue, Alpha; } color_RGBA_f;
]]


-- RGBA_Doubles
function  ColorRGBAFromWavelength(wl, gamma)
	local t = ffi.new("color_RGBA_f", 0.0, 0.0, 0.0, 1);

	if (wl >= 380.0 and wl <= 440.0) then
		t.Red = -1.0 * (wl - 440.0) / (440.0 - 380.0);
		t.Blue = 1.0;
	elseif (wl >= 440.0 and wl <= 490.0) then
		t.Green = (wl - 440.0) / (490.0 - 440.0);
		t.Blue = 1.0;
	elseif (wl >= 490.0 and wl <= 510.0) then
		t.Green = 1.0;
		t.Blue = -1.0 * (wl - 510.0) / (510.0 - 490.0);
	elseif (wl >= 510.0 and wl <= 580.0) then
		t.Red = (wl - 510.0) / (580.0 - 510.0);
		t.Green = 1.0;
	elseif (wl >= 580.0 and wl <= 645.0) then
		t.Red = 1.0;
		t.Green = -1.0 * (wl - 645.0) / (645.0 - 580.0);
	elseif (wl >= 645.0 and wl <= 780.0) then
		t.Red = 1.0;
	end

    local s = 1.0;
	if (wl > 700.0) then
		s = 0.3 + 0.7 * (780.0 - wl) / (780.0 - 700.0);
	elseif (wl < 420.0) then
		s = 0.3 + 0.7 * (wl - 380.0) / (420.0 - 380.0);
	end

	t.Red = math.pow(t.Red * s, gamma);
	t.Green = math.pow(t.Green * s, gamma);
	t.Blue = math.pow(t.Blue * s, gamma);

	return t;
end




function factorAdjust(comp, Factor, IntensityMax, Gamma)
	if(comp == 0.0)then
		return 0;
	else
		return IntensityMax * math.pow(comp * Factor, Gamma);
	end
end

function getColorFromWaveLength(Wavelength, Gamma)
  local IntensityMax = 255;
  local Blue;
  local Green;
  local Red;
  local Factor;

  if(Wavelength >= 350 and Wavelength <= 439) then
   Red	= -(Wavelength - 440) / (440 - 350);
   Green = 0.0;
   Blue	= 1.0;
  elseif(Wavelength >= 440 and Wavelength <= 489) then
   Red	= 0.0;
   Green = (Wavelength - 440) / (490 - 440);
   Blue	= 1.0;
  elseif(Wavelength >= 490 and Wavelength <= 509) then
   Red = 0.0;
   Green = 1.0;
   Blue = -(Wavelength - 510) / (510 - 490);
  elseif(Wavelength >= 510 and Wavelength <= 579)then
   Red = (Wavelength - 510) / (580 - 510);
   Green = 1.0;
   Blue = 0.0;
  elseif(Wavelength >= 580 and Wavelength <= 644) then
   Red = 1.0;
   Green = -(Wavelength - 645) / (645 - 580);
   Blue = 0.0;
  elseif(Wavelength >= 645 and Wavelength <= 780) then
   Red = 1.0;
   Green = 0.0;
   Blue = 0.0;
  else
   Red = 0.0;
   Green = 0.0;
   Blue = 0.0;
  end

  if(Wavelength >= 350 and Wavelength <= 419) then
   Factor = 0.3 + 0.7*(Wavelength - 350) / (420 - 350);
  elseif(Wavelength >= 420 and Wavelength <= 700) then
     Factor = 1.0;
  elseif(Wavelength >= 701 and Wavelength <= 780) then
   Factor = 0.3 + 0.7*(780 - Wavelength) / (780 - 700);
  else
   Factor = 0.0;
 end

  local R = factorAdjust(Red, Factor, IntensityMax, Gamma);
  local G = factorAdjust(Green, Factor, IntensityMax, Gamma);
  local B = factorAdjust(Blue, Factor, IntensityMax, Gamma);

  return R, G, B
end





ColorRGBA = nil
ColorRGBA_mt = {
	__tostring = function(self)
		return string.format("ColorRGBA(%f, %f, %f, %f)",
			self.Red, self.Green, self.Blue, self.Alpha)
		end,
}
ColorRGBA = ffi.metatype("color_RGBA_f", ColorRGBA_mt)

---[[
print("Color.lua - TEST")

local c1 = ColorRGBAFromWavelength(380.0 + 400.0 * 0, 0.8)
print(c1)
--]]
