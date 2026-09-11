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
local BoxShadow = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Decorator", "BoxShadow").BoxShadow
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local function targetWith(decorator)
	return React.createElement("frame", {
		key = "Target",
		Size = UDim2.fromOffset(200, 100),
		BackgroundTransparency = 0,
	}, decorator)
end
local BoxShadowMountValidation
do
	BoxShadowMountValidation = setmetatable({}, {
		__tostring = function()
			return "BoxShadowMountValidation"
		end,
	})
	BoxShadowMountValidation.__index = BoxShadowMountValidation
	function BoxShadowMountValidation.new(...)
		local self = setmetatable({}, BoxShadowMountValidation)
		return self:constructor(...) or self
	end
	function BoxShadowMountValidation:constructor()
	end
	function BoxShadowMountValidation:cssValueShadow()
		withMounted(300, 200, targetWith(React.createElement(BoxShadow, {
			value = "2px 4px 6px 8px",
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local shadow = findDescendant(target, "BoxShadow")
			Assert:equal(shadow.ClassName, "UIShadow")
			Assert:equal(shadow.Parent, target, "Expected the UIShadow to be a direct child of the decorated frame")
			Assert:equal(shadow.ZIndex, -1, "Expected the shadow to sit behind its parent")
			Assert:equal(shadow.Offset, UDim2.new(0, 2, 0, 4))
			Assert:equal(shadow.BlurRadius, UDim.new(0, 6))
			Assert:equal(shadow.Spread, UDim2.new(0, 8, 0, 8))
			Assert:equal(shadow.Color, DefaultTheme.components.boxShadow.color)
			Assert:approximately(shadow.Transparency, DefaultTheme.components.boxShadow.transparency, 1e-6)
		end)
	end
	function BoxShadowMountValidation:completeShadow()
		local color = Color3.fromRGB(10, 20, 30)
		withMounted(300, 200, targetWith(React.createElement(BoxShadow, {
			name = "Glow",
			zindex = 3,
			completeShadow = {
				shadow = "0px 0px 8px 3px",
				color = color,
				transparency = 0.25,
			},
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local shadow = findDescendant(target, "Glow")
			Assert:equal(shadow.ZIndex, 3)
			Assert:equal(shadow.Offset, UDim2.new(0, 0, 0, 0))
			Assert:equal(shadow.BlurRadius, UDim.new(0, 8))
			Assert:equal(shadow.Spread, UDim2.new(0, 3, 0, 3))
			Assert:equal(shadow.Color, color)
			Assert:approximately(shadow.Transparency, 0.25, 1e-6)
			Assert:undefined(target:FindFirstChild("BoxShadow"), "Expected the default BoxShadow name not to be used when name is set")
		end)
	end
	function BoxShadowMountValidation:zeroShadowEmitsNothing(value)
		withMounted(300, 200, targetWith(React.createElement(BoxShadow, {
			value = value,
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			Assert:undefined(target:FindFirstChildWhichIsA("UIShadow"), `Expected no UIShadow for shadow value {value}`)
		end)
	end
	function BoxShadowMountValidation:noValueEmitsNothing()
		withMounted(300, 200, targetWith(React.createElement(BoxShadow)), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			Assert:undefined(target:FindFirstChildWhichIsA("UIShadow"), "Expected no UIShadow when no shadow prop is set")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A CSS shadow value emits a UIShadow named BoxShadow under the parent, behind it (ZIndex -1), with parsed offset/blur/spread and the theme's colour")
	local _descriptor = Test(BoxShadowMountValidation, "cssValueShadow", {
		value = BoxShadowMountValidation.cssValueShadow,
	})
	if _descriptor then
		BoxShadowMountValidation.cssValueShadow = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(BoxShadowMountValidation, "cssValueShadow", {
		value = BoxShadowMountValidation.cssValueShadow,
	})
	if _descriptor_1 then
		BoxShadowMountValidation.cssValueShadow = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(BoxShadowMountValidation, "cssValueShadow", {
		value = BoxShadowMountValidation.cssValueShadow,
	})
	if _descriptor_2 then
		BoxShadowMountValidation.cssValueShadow = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("completeShadow uses its own colour and transparency instead of the theme's, and zindex/name are honoured")
	local _descriptor_3 = Test(BoxShadowMountValidation, "completeShadow", {
		value = BoxShadowMountValidation.completeShadow,
	})
	if _descriptor_3 then
		BoxShadowMountValidation.completeShadow = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(BoxShadowMountValidation, "completeShadow", {
		value = BoxShadowMountValidation.completeShadow,
	})
	if _descriptor_4 then
		BoxShadowMountValidation.completeShadow = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(BoxShadowMountValidation, "completeShadow", {
		value = BoxShadowMountValidation.completeShadow,
	})
	if _descriptor_5 then
		BoxShadowMountValidation.completeShadow = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = Each({ { 0 }, { "0px 0px 0px 0px" } })
	local _decorator_6 = DisplayName("An all-zero shadow value emits no UIShadow at all")
	local _descriptor_6 = Test(BoxShadowMountValidation, "zeroShadowEmitsNothing", {
		value = BoxShadowMountValidation.zeroShadowEmitsNothing,
	})
	if _descriptor_6 then
		BoxShadowMountValidation.zeroShadowEmitsNothing = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_6(BoxShadowMountValidation, "zeroShadowEmitsNothing", {
		value = BoxShadowMountValidation.zeroShadowEmitsNothing,
	})
	if _descriptor_7 then
		BoxShadowMountValidation.zeroShadowEmitsNothing = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(BoxShadowMountValidation, "zeroShadowEmitsNothing", {
		value = BoxShadowMountValidation.zeroShadowEmitsNothing,
	})
	if _descriptor_8 then
		BoxShadowMountValidation.zeroShadowEmitsNothing = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(BoxShadowMountValidation, "zeroShadowEmitsNothing", {
		value = BoxShadowMountValidation.zeroShadowEmitsNothing,
	})
	if _descriptor_9 then
		BoxShadowMountValidation.zeroShadowEmitsNothing = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("With neither value, box-shadow nor completeShadow set, no UIShadow is emitted")
	local _descriptor_10 = Test(BoxShadowMountValidation, "noValueEmitsNothing", {
		value = BoxShadowMountValidation.noValueEmitsNothing,
	})
	if _descriptor_10 then
		BoxShadowMountValidation.noValueEmitsNothing = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(BoxShadowMountValidation, "noValueEmitsNothing", {
		value = BoxShadowMountValidation.noValueEmitsNothing,
	})
	if _descriptor_11 then
		BoxShadowMountValidation.noValueEmitsNothing = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(BoxShadowMountValidation, "noValueEmitsNothing", {
		value = BoxShadowMountValidation.noValueEmitsNothing,
	})
	if _descriptor_12 then
		BoxShadowMountValidation.noValueEmitsNothing = _descriptor_12.value
	end
	BoxShadowMountValidation = Tag("Studio")(BoxShadowMountValidation) or BoxShadowMountValidation
end
return BoxShadowMountValidation
