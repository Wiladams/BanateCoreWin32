require "glsl"


local v2 = vec2(10, 15)

--print(v2.r, v2.g)
--print(v2.x, v2.y)
--print("Vec2: ",v2)

local v3 = vec3(15, 30, 45)
--print("Vec3: ",v3)

local v4 = vec4(5, 10, 15, 0)
print("Vec4: ", v4)
print("Length: ", #v4)

--v3.z = 60
--print("Vec3: ", v3.z)

local v5 = vec3(1,1,1) + vec3(2,4,6)
print("V5: ", v5)

local v6 = -v5
print("Negate V6: ", v6)
print("Length: ", #v6)
