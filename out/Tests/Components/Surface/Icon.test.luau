-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local Icon = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "Icon").Icon
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local DEFAULT_SCALE_SIZE = 20
local IconMountValidation
do
	IconMountValidation = setmetatable({}, {
		__tostring = function()
			return "IconMountValidation"
		end,
	})
	IconMountValidation.__index = IconMountValidation
	function IconMountValidation.new(...)
		local self = setmetatable({}, IconMountValidation)
		return self:constructor(...) or self
	end
	function IconMountValidation:constructor()
	end
	function IconMountValidation:defaultScaleSize()
		withMounted(200, 200, React.createElement(Icon, {
			icon = "check",
		}), function(mounted)
			local icon = waitForGuiObject(mounted.host, "Icon")
			Assert["true"](Assert, icon:IsA("ImageLabel"), "Expected a non-spinning Icon to render as an ImageLabel")
			assertSizeApprox(icon, DEFAULT_SCALE_SIZE, DEFAULT_SCALE_SIZE, 0, "default scale icon")
			assertContained(icon, mounted.host, "default scale icon")
		end)
	end
	function IconMountValidation:scaleSize(scale, expected)
		withMounted(200, 200, React.createElement(Icon, {
			icon = "check",
			scale = scale,
		}), function(mounted)
			local icon = waitForGuiObject(mounted.host, "Icon")
			assertSizeApprox(icon, expected, expected, 0, `{scale} icon`)
		end)
	end
	function IconMountValidation:explicitSize()
		withMounted(200, 200, React.createElement(Icon, {
			icon = "check",
			scale = "sm",
			Size = UDim2.fromOffset(48, 32),
		}), function(mounted)
			local icon = waitForGuiObject(mounted.host, "Icon")
			assertSizeApprox(icon, 48, 32, 0, "explicit size icon")
		end)
	end
	function IconMountValidation:spinningWrapped()
		withMounted(200, 200, React.createElement(Icon, {
			icon = "check",
			scale = "lg",
			spinning = true,
		}), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "Icon")
			Assert["true"](Assert, wrapper:IsA("Frame"), "Expected the spinning Icon's outer instance to be the wrapper Frame")
			local inner = findDescendant(wrapper, "Icon")
			Assert["true"](Assert, inner:IsA("ImageLabel"), "Expected the wrapper Frame to contain the rotating ImageLabel")
			assertSizeApprox(inner, 24, 24, 0, "spinning inner icon")
			assertSizeApprox(wrapper, 24, 24, 1, "spinning wrapper")
			assertContained(inner, wrapper, "spinning inner icon")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without a scale prop the Icon renders at the theme's default (md) icon size")
	local _descriptor = Test(IconMountValidation, "defaultScaleSize", {
		value = IconMountValidation.defaultScaleSize,
	})
	if _descriptor then
		IconMountValidation.defaultScaleSize = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(IconMountValidation, "defaultScaleSize", {
		value = IconMountValidation.defaultScaleSize,
	})
	if _descriptor_1 then
		IconMountValidation.defaultScaleSize = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(IconMountValidation, "defaultScaleSize", {
		value = IconMountValidation.defaultScaleSize,
	})
	if _descriptor_2 then
		IconMountValidation.defaultScaleSize = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "sm", 16 }, { "lg", 24 }, { "xl", 30 } })
	local _decorator_4 = DisplayName("The scale prop picks the matching square pixel size from theme.iconSize")
	local _descriptor_3 = Test(IconMountValidation, "scaleSize", {
		value = IconMountValidation.scaleSize,
	})
	if _descriptor_3 then
		IconMountValidation.scaleSize = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(IconMountValidation, "scaleSize", {
		value = IconMountValidation.scaleSize,
	})
	if _descriptor_4 then
		IconMountValidation.scaleSize = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(IconMountValidation, "scaleSize", {
		value = IconMountValidation.scaleSize,
	})
	if _descriptor_5 then
		IconMountValidation.scaleSize = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(IconMountValidation, "scaleSize", {
		value = IconMountValidation.scaleSize,
	})
	if _descriptor_6 then
		IconMountValidation.scaleSize = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("An explicit Size prop overrides the scale-derived size")
	local _descriptor_7 = Test(IconMountValidation, "explicitSize", {
		value = IconMountValidation.explicitSize,
	})
	if _descriptor_7 then
		IconMountValidation.explicitSize = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(IconMountValidation, "explicitSize", {
		value = IconMountValidation.explicitSize,
	})
	if _descriptor_8 then
		IconMountValidation.explicitSize = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(IconMountValidation, "explicitSize", {
		value = IconMountValidation.explicitSize,
	})
	if _descriptor_9 then
		IconMountValidation.explicitSize = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("spinning={true} wraps the ImageLabel in an auto-sized Frame that contains it")
	local _descriptor_10 = Test(IconMountValidation, "spinningWrapped", {
		value = IconMountValidation.spinningWrapped,
	})
	if _descriptor_10 then
		IconMountValidation.spinningWrapped = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(IconMountValidation, "spinningWrapped", {
		value = IconMountValidation.spinningWrapped,
	})
	if _descriptor_11 then
		IconMountValidation.spinningWrapped = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(IconMountValidation, "spinningWrapped", {
		value = IconMountValidation.spinningWrapped,
	})
	if _descriptor_12 then
		IconMountValidation.spinningWrapped = _descriptor_12.value
	end
	IconMountValidation = Tag("Studio")(IconMountValidation) or IconMountValidation
end
return IconMountValidation
