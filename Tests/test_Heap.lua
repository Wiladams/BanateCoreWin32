-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

require "Heap"

print("Heap.lua - TEST")
gheap = nil
gheap = CreateHeap()
print(gheap)

--local b1 = HeapBlob()
--print("Default Size: ", b1:Size())
--print("Default IsValid: ", b1:IsValid())

function test_blob(gheap)
	local blob = gheap:Alloc(1024)

	print("Blob: ", blob)
	print("Blob IsValid: ", blob:IsValid(), blob:Size())

	blob = nil
end

function heapwalk(gheap)
	-- Start walking the heap
	gheap:Lock()
	local heapEntry, success = gheap:StartHeapWalk()
	print("Start Heap Walk: ", heapEntry, success)
	while success do
		print("Heap cbData: ", heapEntry.cbData)
		heapEntry, success = gheap:ContinueHeapWalk(heapEntry)
	end
	gheap:Unlock()
end

test_blob(gheap)
--heapwalk(gheap)

--heapwalk(GetProcessHeap())

for i=0,5 do
	print("loop", i)
end


