--- Input handling for gamepads and keyboards
-- @classmod core.inputmanager

local InputManager = {}
InputManager.__index = InputManager

--- Constructor
-- @return A new InputManager instance
function InputManager.new()
	local instance = {}

	--- The current input state
	-- @field a A button
	-- @field b B button
	-- @field x X button
	-- @field y Y button
	-- @field left Left movement control
	-- @field right Right movement control
	-- @field up Up movement control
	-- @field down Down movement control
	-- @field back Back button
	-- @field start Start button
	-- @field lb Left shoulder button
	-- @field rb Right shoulder button
	-- @field lt Left trigger
	-- @field rt Right trigger
	-- @field ls Left stick button
	-- @field rs Right stick button
	instance.currentState = {
		a = false,
		b = false,
		x = false,
		y = false,
		left = false,
		right = false,
		up = false,
		down = false,
		back = false,
		start = false,
		lb = false,
		rb = false,
		lt = false,
		rt = false,
		ls = false,
		rs = false
	}

	--- The input state of the previous tick
	-- @field a A button
	-- @field b B button
	-- @field x X button
	-- @field y Y button
	-- @field left Left movement control
	-- @field right Right movement control
	-- @field up Up movement control
	-- @field down Down movement control
	-- @field back Back button
	-- @field start Start button
	-- @field lb Left shoulder button
	-- @field rb Right shoulder button
	-- @field lt Left trigger
	-- @field rt Right trigger
	-- @field ls Left stick button
	-- @field rs Right stick button
	instance.lastState = {
		a = false,
		b = false,
		x = false,
		y = false,
		left = false,
		right = false,
		up = false,
		down = false,
		back = false,
		start = false,
		lb = false,
		rb = false,
		lt = false,
		rt = false,
		ls = false,
		rs = false
	}

	--- Keyboard button bindings for each input
	-- @field a A button
	-- @field b B button
	-- @field x X button
	-- @field y Y button
	-- @field left Left movement control
	-- @field right Right movement control
	-- @field up Up movement control
	-- @field down Down movement control
	-- @field back Back button
	-- @field start Start button
	-- @field lb Left shoulder button
	-- @field rb Right shoulder button
	-- @field lt Left trigger
	-- @field rt Right trigger
	-- @field ls Left stick button
	-- @field rs Right stick button
	instance.keyboardBindings = {
		a = nil,
		b = 'space',
		x = 'q',
		y = 'e',
		left = 'a',
		right = 'd',
		up = 'w',
		down = 's',
		back = 'backspace',
		start = 'escape',
		lb = nil,
		rb = nil,
		lt = nil,
		rt = nil,
		ls = nil,
		rs = nil
	}

	--- Mouse bindings for each input
	-- @field a A button
	-- @field b B button
	-- @field x X button
	-- @field y Y button
	-- @field left Left movement control
	-- @field right Right movement control
	-- @field up Up movement control
	-- @field down Down movement control
	-- @field back Back button
	-- @field start Start button
	-- @field lb Left shoulder button
	-- @field rb Right shoulder button
	-- @field lt Left trigger
	-- @field rt Right trigger
	-- @field ls Left stick button
	-- @field rs Right stick button
	instance.mouseBindings = {
		a = 1,
		b = nil,
		x = nil,
		y = nil,
		left = nil,
		right = nil,
		up = nil,
		down = nil,
		back = nil,
		start = nil,
		lb = nil,
		rb = nil,
		lt = nil,
		rt = nil,
		ls = nil,
		rs = nil
	}

	--- Gamepad button bindings for each input
	-- @field a A button
	-- @field b B button
	-- @field x X button
	-- @field y Y button
	-- @field left Left movement control
	-- @field right Right movement control
	-- @field up Up movement control
	-- @field down Down movement control
	-- @field back Back button
	-- @field start Start button
	-- @field lb Left shoulder button
	-- @field rb Right shoulder button
	-- @field lt Left trigger
	-- @field rt Right trigger
	-- @field ls Left stick button
	-- @field rs Right stick button
	instance.gamepadButtonBindings = {
		a = 'a',
		b = 'b',
		x = 'x',
		y = 'y',
		left = 'dpleft',
		right = 'dpright',
		up = 'dpup',
		down = 'dpdown',
		back = 'back',
		start = 'start',
		lb = 'leftshoulder',
		rb = 'rightshoulder',
		lt = nil,
		rt = nil,
		ls = 'leftstick',
		rs = 'rightstick'
	}

	--- Gamepad trigger bindings for each input
	-- @field a A button
	-- @field b B button
	-- @field x X button
	-- @field y Y button
	-- @field left Left movement control
	-- @field right Right movement control
	-- @field up Up movement control
	-- @field down Down movement control
	-- @field back Back button
	-- @field start Start button
	-- @field lb Left shoulder button
	-- @field rb Right shoulder button
	-- @field lt Left trigger
	-- @field rt Right trigger
	-- @field ls Left stick button
	-- @field rs Right stick button
	instance.gamepadTriggerBindings = {
		a = nil,
		b = nil,
		x = nil,
		y = nil,
		left = nil,
		right = nil,
		up = nil,
		down = nil,
		back = nil,
		start = nil,
		lb = nil,
		rb = nil,
		lt = 'triggerleft',
		rt = 'triggerright',
		ls = nil,
		rs = nil
	}

	--- A stack containing the most recently activated inputs in order
	instance.stack = {}

	--- Trigger deadzone
	instance.triggerDeadzone = 0.5

	--- Stick deadzone
	instance.stickDeadzone = 0.3

	--- Collection of all gamepads found on the system
	instance.gamepads = nil

	--- Currently enabled gamepad
	instance.gamepad = nil

	-- Add input manager to the autoupdater
	Globals.updater:add(instance)

	setmetatable(instance, InputManager)
	return instance
end

--- Load input bindings from a configuration file
function InputManager:loadBindings()

end

--- Save input bindings to a configuration file
function InputManager:saveBindings()

end

--- Find all connected gamepads
-- @todo Allow the ability to choose from a list
function InputManager:findGamepads()
	local joysticks = love.joystick.getJoysticks()
	for i, joystick in ipairs(joysticks) do
		if joystick:isGamepad() then
			table.insert(self.joysticks, joystick)

			-- Fix
			if i == 1 then
				self.gamepad = joystick
			end
		end
	end
end

--- Determine whether the given input was activated between the last tick and now
-- @return True if activated, false if not
function InputManager:wasActivated(input)
	return self.currentState[input] and not self.lastState[input]
end

--- Determine whether the given input was deactivated between the last tick and now
-- @return True if deactivated, false if not
function InputManager:wasDeactivated(input)
	return self.lastState[input] and not self.currentState[input]
end

--- Polls the current input state.
-- @return The current input state
function InputManager:update(dt)
	-- Copy previous state and clear current state
	for input, state in pairs(self.currentState) do
		self.lastState[input] = state
		self.currentState[input] = false
	end

	-- Keyboard bindings
	for input, binding in pairs(self.keyboardBindings) do
		if binding ~= nil then
			self.currentState[input] = self.currentState[input] or love.keyboard.isDown(binding)
		end
	end

	-- Mouse bindings
	for input, binding in pairs(self.mouseBindings) do
		if binding ~= nil then
			self.currentState[input] = self.currentState[input] or love.mouse.isDown(binding)
		end
	end

	if self.gamepad ~= nil then
		-- Gamepad button bindings
		for input, binding in pairs(self.gamepadButtonBindings) do
			if binding ~= nil then
				self.currentState[input] = self.currentState[input] or self.gamepad:isDown(binding)
			end
		end

		-- Gamepad trigger bindings
		for input, binding in pairs(self.gamepadTriggerBindings) do
			if binding ~= nil then
				self.currentState[input] = self.currentState[input] or math.abs(self.gamepad:getGamepadAxis(binding)) > self.triggerDeadzone
			end
		end

		-- Gamepad left stick
		self.currentState.left = self.currentState.left or self.gamepad:getGamepadAxis('leftx') > self.triggerDeadzone
		self.currentState.right = self.currentState.right or self.gamepad:getGamepadAxis('leftx') < -self.triggerDeadzone
		self.currentState.up = self.currentState.up or self.gamepad:getGamepadAxis('lefty') < -self.triggerDeadzone
		self.currentState.down = self.currentState.down or self.gamepad:getGamepadAxis('lefty') > self.triggerDeadzone
	end

	-- Update the input stack
	for input, state in pairs(self.currentState) do
		-- Input was activated
		if self:wasActivated(input) then
			local found = false

			for i, key in ipairs(self.stack) do
				if key == input then
					found = true
				end
			end

			if not found then
				table.insert(self.stack, input)
			end

		-- Input was deactivated
		elseif self:wasDeactivated(input) then
			for i = #self.stack, 1, -1 do
				if self.stack[i] == input then
					table.remove(self.stack, i)
					break
				end
			end
		end
	end
end

return InputManager
