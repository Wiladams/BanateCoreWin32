require "BanateCore"

lua = require "Luaffi"

class.LuaState()

function LuaState:_init(codechunk)
	local status, result
	local L = lua.luaL_newstate();  -- create state

	if L == nil then
		print("cannot create state: not enough memory")
		self.Status = EXIT_FAILURE;
	end

	self.State = L
	-- Load whatever libraries are necessary for
	-- your code to start
    lua.luaopen_base(L)
--[[
	print("luaopen_io: ", lua.luaopen_io(L)); -- provides io.*
    print("luaopen_table", lua.luaopen_table(L));

    print("luaopen_string", lua.luaopen_string(L));
    print("luaopen_math", lua.luaopen_math(L));
	print("luaopen_bit", lua.luaopen_bit(L));
	print("luaopen_jit", lua.luaopen_jit(L));
	print("luaopen_ffi", lua.luaopen_ffi(L));
--]]

	if codechunk then
		self:LoadChunk(codechunk)
	end
end

function LuaState:LoadChunk(s)
	self.CodeChunk = s

	local result = lua.luaL_loadstring(self.State, s)

	self.CompileStatus = result

	return result
end

function LuaState:Run(codechunk)
	if codechunk then
		self:LoadChunk(codechunk)
	end

	local result

	if self.CompileStatus == 0 then
		result = lua.lua_pcall(self.State, 0, LUA_MULTRET, 0)
		self.RunStatus = result
	else
		return self.CompileStatus
	end

	return self.RunStatus
end

local codechunk = "print('hello world')"
local st = LuaState(codechunk)
--st:LoadChunk(codechunk)
st:Run()
