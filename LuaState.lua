require "BanateCore"

lua = require "Luaffi"

class.LuaState()

LuaState.Defaults = {
}


local function report_errors(L, status)
	if status ~=0 then
		print("-- ", ffi.string(lua_tostring(L, -1)))
		lua_pop(L, 1); -- remove error message
	end
end

function LuaState:_init(codechunk, autorun)
	local status, result
	local L = lua.luaL_newstate();  -- create state

	if L == nil then
		print("cannot create state: not enough memory")
		self.Status = EXIT_FAILURE;
	end

	self.State = L
	self.Init = LuaState.Defaults.InitLua

	-- Must at least load base library
	-- or 'require' and print won't work
	lua.luaopen_base(L)
	lua.luaopen_string(L);
	lua.luaopen_math(L);
	lua.luaopen_io(L);
	lua.luaopen_table(L);

	lua.luaopen_bit(L);
	lua.luaopen_jit(L);
	lua.luaopen_ffi(L);

	if self.Init then
		self.InitStatus = self:Run(self.Init)
	end

	if codechunk then
		self.CodeChunk = codechunk
		if autorun then
			self:Run(codechunk)
		end
	end
end

function LuaState:LoadChunk(s)
	local result = lua.luaL_loadstring(self.State, s)
	report_errors(self.State, result)

	return result
end

function LuaState:Run(codechunk)
	local result
	if codechunk then
		result = self:LoadChunk(codechunk)
	end


	if result == 0 then
		result = lua.lua_pcall(self.State, 0, LUA_MULTRET, 0)
	report_errors(self.State, result)
	else
		return result
	end

	return result
end

