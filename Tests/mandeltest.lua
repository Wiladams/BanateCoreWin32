-- The Computer Language Benchmarks Game
-- http://shootout.alioth.debian.org/
-- contributed by Mike Pall

local bit = require("bit")
local bor, band = bit.bor, bit.band
local shl, shr, rol = bit.lshift, bit.rshift, bit.rol
local char, unpack = string.char, unpack
local N = tonumber(arg and arg[1]) or 100

function mandelbrot(rows)
	local M, buf = 2/rows, {}
	local cols = rows

	for y=0,rows-1 do
		local Ci= y*M-1
		local b = -16777216
		local p = 0

		local Ciq = Ci*Ci

		for x=0,cols-1,2 do
			local Cr, Cr2 = x*M-1.5, (x+1)*M-1.5
			local Zr, Zi, Zrq, Ziq = Cr, Ci, Cr*Cr, Ciq
			local Zr2, Zi2, Zrq2, Ziq2 = Cr2, Ci, Cr2*Cr2, Ciq

			b = rol(b, 2)
			for i=1,49 do
				Zi = Zr*Zi*2 + Ci; Zi2 = Zr2*Zi2*2 + Ci
				Zr = Zrq-Ziq + Cr; Zr2 = Zrq2-Ziq2 + Cr2
				Ziq = Zi*Zi; Ziq2 = Zi2*Zi2
				Zrq = Zr*Zr; Zrq2 = Zr2*Zr2

				if band(b, 2) ~= 0 and Zrq+Ziq > 4.0 then
					b = band(b, -3)
				end

				if band(b, 1) ~= 0 and Zrq2+Ziq2 > 4.0 then
					b = band(b, -2)
				end

				if band(b, 3) == 0 then
					break
				end
			end

			if b >= 0 then
				p = p + 1;
				buf[p] = b;
				b = -16777216;
			end
		end

		if b ~= -16777216 then
			if band(N, 1) ~= 0 then
				b = shr(b, 1)
			end
			p = p + 1;
			buf[p] = shl(b, 8-band(N, 7))
		end

		-- write out pixel
		--write(char(unpack(buf, 1, p)))
	end
end

