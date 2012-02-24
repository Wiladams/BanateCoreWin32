require "GameWindow"

-- The routine that gets called for any
-- mouse activity messages
function mouseinteraction(msg)
	print(string.format("Mouse: 0x%x", msg.message))
end

function keyboardinteraction(msg)
	print(string.format("Keyboard: 0x%x", msg.message))
end

function main()
	local appwin = GameWindow({
		Title = "Game Window",
		MouseInteractor = mouseinteraction,
		KeyboardInteractor = keyboardinteraction,
		})

	appwin:Run()
end

main()
