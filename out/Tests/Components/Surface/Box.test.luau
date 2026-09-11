-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local Box = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "Box").Box
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertCenteredIn = _layout.assertCenteredIn
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local function waitForBox(host)
	return waitForGuiObject(host, "Box")
end
local BoxMountValidation
do
	BoxMountValidation = setmetatable({}, {
		__tostring = function()
			return "BoxMountValidation"
		end,
	})
	BoxMountValidation.__index = BoxMountValidation
	function BoxMountValidation.new(...)
		local self = setmetatable({}, BoxMountValidation)
		return self:constructor(...) or self
	end
	function BoxMountValidation:constructor()
	end
	function BoxMountValidation:fillsHostByDefault()
		withMounted(400, 300, React.createElement(Box), function(mounted)
			local box = waitForBox(mounted.host)
			assertSizeApprox(box, 400, 300, 1, "default-size box")
			assertContained(box, mounted.host, "default-size box")
		end)
	end
	function BoxMountValidation:respectsExplicitSize(width, height)
		withMounted(400, 300, React.createElement(Box, {
			width = width,
			height = height,
		}), function(mounted)
			local box = waitForBox(mounted.host)
			assertSizeApprox(box, width, height, 1, "explicit size")
		end)
	end
	function BoxMountValidation:childrenContained()
		withMounted(400, 300, React.createElement(Box, {
			width = 200,
			height = 120,
		}, React.createElement("frame", {
			key = "FullChild",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}, React.createElement(Text, {
			text = "Inside the box",
		}))), function(mounted)
			local box = waitForBox(mounted.host)
			local child = waitForGuiObject(box, "FullChild")
			assertContained(child, box, "full-scale child")
			assertAllDescendantsContained(box, "box children")
		end)
	end
	function BoxMountValidation:centeredInHost()
		withMounted(400, 300, React.createElement(Box, {
			center = true,
			width = 200,
			height = 100,
		}), function(mounted)
			local box = waitForBox(mounted.host)
			assertSizeApprox(box, 200, 100, 1, "centered box")
			assertCenteredIn(box, mounted.host, "both", 1, "centered box")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without width or height the Box defaults to a (1,1) scale Size and fills its host")
	local _descriptor = Test(BoxMountValidation, "fillsHostByDefault", {
		value = BoxMountValidation.fillsHostByDefault,
	})
	if _descriptor then
		BoxMountValidation.fillsHostByDefault = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(BoxMountValidation, "fillsHostByDefault", {
		value = BoxMountValidation.fillsHostByDefault,
	})
	if _descriptor_1 then
		BoxMountValidation.fillsHostByDefault = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(BoxMountValidation, "fillsHostByDefault", {
		value = BoxMountValidation.fillsHostByDefault,
	})
	if _descriptor_2 then
		BoxMountValidation.fillsHostByDefault = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { 200, 120 }, { 64, 32 } })
	local _decorator_4 = DisplayName("Explicit width and height props pin the Box's AbsoluteSize to those pixel values")
	local _descriptor_3 = Test(BoxMountValidation, "respectsExplicitSize", {
		value = BoxMountValidation.respectsExplicitSize,
	})
	if _descriptor_3 then
		BoxMountValidation.respectsExplicitSize = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(BoxMountValidation, "respectsExplicitSize", {
		value = BoxMountValidation.respectsExplicitSize,
	})
	if _descriptor_4 then
		BoxMountValidation.respectsExplicitSize = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(BoxMountValidation, "respectsExplicitSize", {
		value = BoxMountValidation.respectsExplicitSize,
	})
	if _descriptor_5 then
		BoxMountValidation.respectsExplicitSize = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(BoxMountValidation, "respectsExplicitSize", {
		value = BoxMountValidation.respectsExplicitSize,
	})
	if _descriptor_6 then
		BoxMountValidation.respectsExplicitSize = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("A full-scale frame child and a Text child both stay inside the padded Box")
	local _descriptor_7 = Test(BoxMountValidation, "childrenContained", {
		value = BoxMountValidation.childrenContained,
	})
	if _descriptor_7 then
		BoxMountValidation.childrenContained = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(BoxMountValidation, "childrenContained", {
		value = BoxMountValidation.childrenContained,
	})
	if _descriptor_8 then
		BoxMountValidation.childrenContained = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(BoxMountValidation, "childrenContained", {
		value = BoxMountValidation.childrenContained,
	})
	if _descriptor_9 then
		BoxMountValidation.childrenContained = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("center={true} with a fixed width and height places the Box in the middle of the host")
	local _descriptor_10 = Test(BoxMountValidation, "centeredInHost", {
		value = BoxMountValidation.centeredInHost,
	})
	if _descriptor_10 then
		BoxMountValidation.centeredInHost = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(BoxMountValidation, "centeredInHost", {
		value = BoxMountValidation.centeredInHost,
	})
	if _descriptor_11 then
		BoxMountValidation.centeredInHost = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(BoxMountValidation, "centeredInHost", {
		value = BoxMountValidation.centeredInHost,
	})
	if _descriptor_12 then
		BoxMountValidation.centeredInHost = _descriptor_12.value
	end
	BoxMountValidation = Tag("Studio")(BoxMountValidation) or BoxMountValidation
end
return BoxMountValidation
