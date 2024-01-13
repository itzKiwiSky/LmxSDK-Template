function love.errorhandler(msg)
    utf8 = require 'utf8'

    love.graphics.setNewFont(14)

    -- addons loader --
    local Addons = love.filesystem.getDirectoryItems("src/Addons")
    for addon = 1, #Addons, 1 do
        require("src.Addons." .. string.gsub(Addons[addon], ".lua", ""))
    end

    gradientError = love.graphics.newGradient("vertical", {255, 255, 255, 255}, {0, 0, 0, 0})
    loveimage = love.graphics.newImage("resources/images/love.png")
    plus = love.graphics.newImage("resources/images/plus.png")
    lmxsdk = love.graphics.newImage("resources/images/luminixsdk.png")

    local function error_printer(msg, layer)
        print((debug.traceback("[Error]: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
    end

	msg = tostring(msg)

	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end


	love.graphics.setColor(1, 1, 1)

	local trace = debug.traceback()

	love.graphics.origin()

	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)

	local err = {}

	table.insert(err, "[Error]\n")
	table.insert(err, sanitizedmsg)

	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end

	table.insert(err, "\n")

	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")

	local function draw()
		if not love.graphics.isActive() then return end
		local pos = 70
		love.graphics.clear(232 / 255, 103 / 255, 152 / 255)

        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(gradientError, 0, 0, 0, love.graphics.getWidth(), 128)

        love.graphics.draw(gradientError, 0, love.graphics.getHeight(), 0, love.graphics.getWidth(), -128)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.setColor(0, 0, 0, 1)
		love.graphics.print(p, pos, pos + 2)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(p, pos, pos)

        love.graphics.draw(loveimage, love.graphics.getWidth() - loveimage:getWidth() * 0.1 - (plus:getWidth() * 1.5) * 2, love.graphics.getHeight() - loveimage:getHeight() * 0.1, 0, 0.1, 0.1)
        love.graphics.draw(plus, love.graphics.getWidth() - plus:getWidth() * 1.5 - (lmxsdk:getWidth() * 1.5), love.graphics.getHeight() - plus:getHeight() * 1.5, 0, 1.5)
        love.graphics.draw(lmxsdk, love.graphics.getWidth() - (lmxsdk:getWidth() * 1.5), love.graphics.getHeight() - lmxsdk:getHeight() * 1.5, 0, 1.5, 1.5)

		love.graphics.present()
	end

	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
	end

	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end

	return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
                return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end