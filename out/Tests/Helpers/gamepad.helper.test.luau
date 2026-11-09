-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local GamepadHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "gamepad.helper").GamepadHelper
local STUDIO_SKIP_MESSAGE = TS.import(script, script.Parent, "layout").STUDIO_SKIP_MESSAGE
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local function inputType(name)
	local _exp = Enum.UserInputType:GetEnumItems()
	-- ▼ ReadonlyArray.find ▼
	local _callback = function(item)
		return item.Name == name
	end
	local _result
	for _i, _v in _exp do
		if _callback(_v, _i - 1, _exp) == true then
			_result = _v
			break
		end
	end
	-- ▲ ReadonlyArray.find ▲
	local found = _result
	Assert:notUndefined(found, `Expected Enum.UserInputType.{name} to exist`)
	return found
end
local function makeFrame(parent, name)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Parent = parent
	return frame
end
local function withTree(fn)
	local root = Instance.new("Folder")
	root.Name = "SelectionScopeTree"
	TS.try(function()
		fn(root)
	end, nil, function()
		root:Destroy()
	end)
end
local GamepadHelperChecks
do
	GamepadHelperChecks = setmetatable({}, {
		__tostring = function()
			return "GamepadHelperChecks"
		end,
	})
	GamepadHelperChecks.__index = GamepadHelperChecks
	function GamepadHelperChecks.new(...)
		local self = setmetatable({}, GamepadHelperChecks)
		return self:constructor(...) or self
	end
	function GamepadHelperChecks:constructor()
	end
	function GamepadHelperChecks:gamepadTypes(name)
		Assert["true"](Assert, GamepadHelper:isGamepadInputType(inputType(name)), `Expected {name} to count as gamepad input`)
	end
	function GamepadHelperChecks:otherTypes(name)
		Assert["false"](Assert, GamepadHelper:isGamepadInputType(inputType(name)), `Expected {name} not to count as gamepad input`)
	end
	function GamepadHelperChecks:missingIsOutside()
		withTree(function(root)
			local scope = makeFrame(root, "Scope")
			local child = makeFrame(scope, "Child")
			Assert["false"](Assert, GamepadHelper:isSelectionWithin(nil, scope), "Expected no selection to be outside the scope")
			Assert["false"](Assert, GamepadHelper:isSelectionWithin(child, nil), "Expected no scope to contain nothing")
		end)
	end
	function GamepadHelperChecks:scopeAndDescendants()
		withTree(function(root)
			local scope = makeFrame(root, "Scope")
			local child = makeFrame(scope, "Child")
			local grandchild = makeFrame(child, "Grandchild")
			Assert["true"](Assert, GamepadHelper:isSelectionWithin(scope, scope), "Expected the scope itself to be inside")
			Assert["true"](Assert, GamepadHelper:isSelectionWithin(child, scope), "Expected a direct child to be inside")
			Assert["true"](Assert, GamepadHelper:isSelectionWithin(grandchild, scope), "Expected a nested descendant to be inside")
		end)
	end
	function GamepadHelperChecks:siblingsAndAncestorsOutside()
		withTree(function(root)
			local outer = makeFrame(root, "Outer")
			local scope = makeFrame(outer, "Scope")
			local sibling = makeFrame(outer, "Sibling")
			Assert["false"](Assert, GamepadHelper:isSelectionWithin(sibling, scope), "Expected a sibling to be outside")
			Assert["false"](Assert, GamepadHelper:isSelectionWithin(outer, scope), "Expected an ancestor to be outside")
		end)
	end
	function GamepadHelperChecks:trySetSwallowsErrors()
		local detached = Instance.new("Frame")
		detached.Selectable = true
		TS.try(function()
			GamepadHelper:trySetSelectedObject(detached)
			GamepadHelper:trySetSelectedObject(nil)
		end, nil, function()
			detached:Destroy()
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Every Gamepad1 to Gamepad8 input type counts as gamepad input")
	local _decorator_2 = Each({ { "Gamepad1" }, { "Gamepad2" }, { "Gamepad3" }, { "Gamepad4" }, { "Gamepad5" }, { "Gamepad6" }, { "Gamepad7" }, { "Gamepad8" } })
	local _descriptor = Test(GamepadHelperChecks, "gamepadTypes", {
		value = GamepadHelperChecks.gamepadTypes,
	})
	if _descriptor then
		GamepadHelperChecks.gamepadTypes = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(GamepadHelperChecks, "gamepadTypes", {
		value = GamepadHelperChecks.gamepadTypes,
	})
	if _descriptor_1 then
		GamepadHelperChecks.gamepadTypes = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(GamepadHelperChecks, "gamepadTypes", {
		value = GamepadHelperChecks.gamepadTypes,
	})
	if _descriptor_2 then
		GamepadHelperChecks.gamepadTypes = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(GamepadHelperChecks, "gamepadTypes", {
		value = GamepadHelperChecks.gamepadTypes,
	})
	if _descriptor_3 then
		GamepadHelperChecks.gamepadTypes = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Mouse, keyboard, touch and None input types are not gamepad input")
	local _decorator_5 = Each({ { "Keyboard" }, { "MouseMovement" }, { "MouseButton1" }, { "MouseWheel" }, { "Touch" }, { "None" } })
	local _descriptor_4 = Test(GamepadHelperChecks, "otherTypes", {
		value = GamepadHelperChecks.otherTypes,
	})
	if _descriptor_4 then
		GamepadHelperChecks.otherTypes = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(GamepadHelperChecks, "otherTypes", {
		value = GamepadHelperChecks.otherTypes,
	})
	if _descriptor_5 then
		GamepadHelperChecks.otherTypes = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(GamepadHelperChecks, "otherTypes", {
		value = GamepadHelperChecks.otherTypes,
	})
	if _descriptor_6 then
		GamepadHelperChecks.otherTypes = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(GamepadHelperChecks, "otherTypes", {
		value = GamepadHelperChecks.otherTypes,
	})
	if _descriptor_7 then
		GamepadHelperChecks.otherTypes = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("No selection, or no scope, is never inside the scope")
	local _descriptor_8 = Test(GamepadHelperChecks, "missingIsOutside", {
		value = GamepadHelperChecks.missingIsOutside,
	})
	if _descriptor_8 then
		GamepadHelperChecks.missingIsOutside = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_7(GamepadHelperChecks, "missingIsOutside", {
		value = GamepadHelperChecks.missingIsOutside,
	})
	if _descriptor_9 then
		GamepadHelperChecks.missingIsOutside = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_6(GamepadHelperChecks, "missingIsOutside", {
		value = GamepadHelperChecks.missingIsOutside,
	})
	if _descriptor_10 then
		GamepadHelperChecks.missingIsOutside = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("The scope itself and any nested descendant count as inside the scope")
	local _descriptor_11 = Test(GamepadHelperChecks, "scopeAndDescendants", {
		value = GamepadHelperChecks.scopeAndDescendants,
	})
	if _descriptor_11 then
		GamepadHelperChecks.scopeAndDescendants = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_9(GamepadHelperChecks, "scopeAndDescendants", {
		value = GamepadHelperChecks.scopeAndDescendants,
	})
	if _descriptor_12 then
		GamepadHelperChecks.scopeAndDescendants = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_8(GamepadHelperChecks, "scopeAndDescendants", {
		value = GamepadHelperChecks.scopeAndDescendants,
	})
	if _descriptor_13 then
		GamepadHelperChecks.scopeAndDescendants = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A sibling of the scope and an ancestor of the scope both count as outside it")
	local _descriptor_14 = Test(GamepadHelperChecks, "siblingsAndAncestorsOutside", {
		value = GamepadHelperChecks.siblingsAndAncestorsOutside,
	})
	if _descriptor_14 then
		GamepadHelperChecks.siblingsAndAncestorsOutside = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(GamepadHelperChecks, "siblingsAndAncestorsOutside", {
		value = GamepadHelperChecks.siblingsAndAncestorsOutside,
	})
	if _descriptor_15 then
		GamepadHelperChecks.siblingsAndAncestorsOutside = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(GamepadHelperChecks, "siblingsAndAncestorsOutside", {
		value = GamepadHelperChecks.siblingsAndAncestorsOutside,
	})
	if _descriptor_16 then
		GamepadHelperChecks.siblingsAndAncestorsOutside = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("Selecting a detached GuiObject never throws, whether or not the engine accepts it")
	local _descriptor_17 = Test(GamepadHelperChecks, "trySetSwallowsErrors", {
		value = GamepadHelperChecks.trySetSwallowsErrors,
	})
	if _descriptor_17 then
		GamepadHelperChecks.trySetSwallowsErrors = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_13(GamepadHelperChecks, "trySetSwallowsErrors", {
		value = GamepadHelperChecks.trySetSwallowsErrors,
	})
	if _descriptor_18 then
		GamepadHelperChecks.trySetSwallowsErrors = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(GamepadHelperChecks, "trySetSwallowsErrors", {
		value = GamepadHelperChecks.trySetSwallowsErrors,
	})
	if _descriptor_19 then
		GamepadHelperChecks.trySetSwallowsErrors = _descriptor_19.value
	end
	GamepadHelperChecks = Tag("Studio")(GamepadHelperChecks) or GamepadHelperChecks
end
return GamepadHelperChecks
