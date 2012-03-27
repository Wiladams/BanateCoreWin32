-- OleAuto.h
local ffi = require"ffi"

require "WTypes"

oleaut = ffi.load("oleaut32")

ffi.cdef[[
/*---------------------------------------------------------------------*/
/*                            BSTR API                                 */
/*---------------------------------------------------------------------*/

BSTR SysAllocString(const OLECHAR * psz);
INT  SysReAllocString(BSTR* pbstr, const OLECHAR* psz);
BSTR SysAllocStringLen(const OLECHAR * strIn, UINT ui);
INT  SysReAllocStringLen(BSTR* pbstr, const OLECHAR* psz, unsigned int len);
void SysFreeString(BSTR bstrString);
UINT SysStringLen(BSTR);

UINT SysStringByteLen(BSTR bstr);
BSTR SysAllocStringByteLen(LPCSTR psz, UINT len);
]]

function CreateBSTR(str)
	local widestring = str
	local bstr = ffi.gc(oleaut.SysAllocString(widestring), oleaut.SysFreeString)

	return bstr, string.len(str)
end


local bstr,len = CreateBSTR("Hello World!")

print("Length: ", bstr, len)

for i=0,len do
	print(string.char(bstr[i]))
end

bstr = nil

a = 0
for i=0,10000 do
	a = a + 1
end
