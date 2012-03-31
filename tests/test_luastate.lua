-- test_winsock.lua
-- Put this at the top of any test
local ppath = package.path..';..\\?.lua'
package.path = ppath;

local ffi = require "ffi"
lua = require "Luaffi"

function report_errors(L, status)
	if status ~=0 then
		print("-- ", ffi.string(lua_tostring(L, -1)))
		lua_pop(L, 1); -- remove error message
	end
end

function execlua (codechunk)

	local status, result
	local L = lua.luaL_newstate();  -- create state

	if L == nil then
		print("cannot create state: not enough memory")
		return EXIT_FAILURE;
	end

	-- Load whatever libraries are necessary for
	-- your code to start
    print("luaopen_base: ", lua.luaopen_base(L))
	print("luaopen_io: ", lua.luaopen_io(L)); -- provides io.*
    print("luaopen_table", lua.luaopen_table(L));

    print("luaopen_string", lua.luaopen_string(L));
    print("luaopen_math", lua.luaopen_math(L));
	print("luaopen_bit", lua.luaopen_bit(L));
	print("luaopen_jit", lua.luaopen_jit(L));
	print("luaopen_ffi", lua.luaopen_ffi(L));

	--lua.luaL_openlibs(L);

	-- execute the given code chunk
	result = luaL_dostring(L, codechunk)
	print("Result: ", result)
	report_errors(L, status)

	lua.lua_close(L);

end

execlua("print('hello world'); return 5")
