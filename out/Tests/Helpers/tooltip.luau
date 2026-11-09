-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Assert = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out).Assert
local Tooltip = TS.import(script, script.Parent.Parent.Parent, "Components", "Interaction", "Tooltip").Tooltip
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent, "layout")
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local FAST_TOOLTIP = {
	fadeDuration = 0.05,
	closeDelay = 0.1,
	longPressDelay = 0.2,
}
local FAST_THEME = extendTheme(DefaultTheme, {
	components = {
		tooltip = FAST_TOOLTIP,
	},
})
local HOLD_SECONDS = 0.3
local CONTENT = "Helpful hint"
local function assertNoPopup(host, message, name)
	if name == nil then
		name = "Tooltip"
	end
	settleFrames(10)
	Assert:undefined(host:FindFirstChild(name, true), message)
end
local function tip(options)
	if options == nil then
		options = {}
	end
	local _condition = options.trigger
	if _condition == nil then
		_condition = "Trigger"
	end
	local trigger = _condition
	local _attributes = {
		key = trigger,
		name = options.name,
	}
	local _condition_1 = options.content
	if _condition_1 == nil then
		_condition_1 = CONTENT
	end
	_attributes.content = _condition_1
	_attributes.placement = options.placement
	_attributes.open = options.open
	_attributes.disabled = options.disabled
	_attributes.interactive = options.interactive
	_attributes.pinOnPress = options.pinOnPress
	_attributes.longPress = options.longPress
	return React.createElement(Tooltip, _attributes, React.createElement("frame", {
		key = trigger,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 40),
		Position = options.position or UDim2.fromOffset(150, 130),
	}))
end
local function tipApp(options, theme)
	if options == nil then
		options = {}
	end
	if theme == nil then
		theme = FAST_THEME
	end
	return React.createElement(ThemeProvider, {
		theme = theme,
	}, React.createElement(OverlayProvider, nil, tip(options)))
end
local function coverApp(cover, under)
	if under == nil then
		under = {}
	end
	local _object = {
		name = "CoverTip",
		trigger = "CoverTrigger",
		position = UDim2.fromOffset(20, 20),
	}
	for _k, _v in cover do
		_object[_k] = _v
	end
	local _exp = tip(_object)
	local _object_1 = {
		name = "UnderTip",
		trigger = "UnderTrigger",
		position = UDim2.fromOffset(150, 200),
	}
	for _k, _v in under do
		_object_1[_k] = _v
	end
	return React.createElement(ThemeProvider, {
		theme = FAST_THEME,
	}, React.createElement(OverlayProvider, nil, _exp, tip(_object_1)))
end
local function nestedApp(mode, childOpen)
	return React.createElement(ThemeProvider, {
		theme = FAST_THEME,
	}, React.createElement(OverlayProvider, nil, React.createElement(Tooltip, {
		name = "ParentTip",
		interactive = mode == "interactive",
		pinOnPress = mode == "pinOnPress",
		content = React.createElement(Tooltip, {
			name = "ChildTip",
			content = "Nested hint",
			open = childOpen,
		}, React.createElement("frame", {
			key = "ChildTrigger",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(80, 20),
		})),
	}, React.createElement("frame", {
		key = "ParentTrigger",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 40),
		Position = UDim2.fromOffset(150, 200),
	}))))
end
local function waitForTrigger(host, name)
	if name == nil then
		name = "Trigger"
	end
	waitForGuiObject(host, "OverlayProvider")
	return waitForGuiObject(host, name)
end
local function pressInput(kind)
	if kind == nil then
		kind = "MouseButton1"
	end
	return {
		UserInputType = if kind == "Touch" then Enum.UserInputType.Touch else Enum.UserInputType.MouseButton1,
		UserInputState = Enum.UserInputState.Begin,
	}
end
local function touchPress()
	local changed = Instance.new("BindableEvent")
	local fields = {
		UserInputType = Enum.UserInputType.Touch,
		UserInputState = Enum.UserInputState.Begin,
		GetPropertyChangedSignal = function()
			return changed.Event
		end,
	}
	return {
		input = fields,
		finish = function(state)
			fields.UserInputState = state
			changed:Fire()
			task.wait()
			changed:Destroy()
		end,
	}
end
local function waitForShown(host, name, seconds)
	if name == nil then
		name = "Tooltip"
	end
	if seconds == nil then
		seconds = 2
	end
	local popup = waitForGuiObject(host, name)
	local deadline = os.clock() + seconds
	while os.clock() < deadline do
		if popup.GroupTransparency < 0.01 then
			return popup
		end
		task.wait()
	end
	return Assert:fail(`Timed out after {seconds}s waiting for "{name}" to fade in (GroupTransparency={popup.GroupTransparency})`)
end
local function assertStaysShown(host, seconds, message, name)
	if name == nil then
		name = "Tooltip"
	end
	task.wait(seconds)
	local popup = host:FindFirstChild(name, true)
	Assert:notUndefined(popup, message)
	Assert["true"](Assert, popup.GroupTransparency < 0.01, `{message} (GroupTransparency={popup.GroupTransparency})`)
end
local function fadesBy(popup, deadline)
	while os.clock() < deadline do
		if popup.GroupTransparency > 0.01 then
			return true
		end
		task.wait()
	end
	return false
end
return {
	assertNoPopup = assertNoPopup,
	tip = tip,
	tipApp = tipApp,
	coverApp = coverApp,
	nestedApp = nestedApp,
	waitForTrigger = waitForTrigger,
	pressInput = pressInput,
	touchPress = touchPress,
	waitForShown = waitForShown,
	assertStaysShown = assertStaysShown,
	fadesBy = fadesBy,
	FAST_TOOLTIP = FAST_TOOLTIP,
	FAST_THEME = FAST_THEME,
	HOLD_SECONDS = HOLD_SECONDS,
}
