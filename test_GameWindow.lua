require "ApplicationWindow"

function mouseinteraction(msg)
	print(string.format("Mouse: 0x%x", msg.message))
end

function main()
	local appwin = ApplicationWindow({
		Title = "Application Window",
		MouseInteractor = mouseinteraction,
		})

	appwin:Run()
end

main()
