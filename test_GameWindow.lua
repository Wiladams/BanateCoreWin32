require "GameWindow"

-- The routine that gets called for any
-- mouse activity messages
function mouseinteraction(msg)
	print(string.format("Mouse: 0x%x", msg.message))
end

function main()
	local appwin = GameWindow({
		Title = "Game Window",
		MouseInteractor = mouseinteraction,
		})

	appwin:Run()
end

main()
