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
local Padding = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Decorator", "Padding").Padding
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local function targetWith(children)
	return React.createElement("frame", {
		key = "Target",
		Size = UDim2.fromOffset(200, 100),
		BackgroundTransparency = 0,
	}, children)
end
local function assertSides(padding, top, right, bottom, left, label)
	Assert:equal(padding.PaddingTop, UDim.new(0, top), `{label}: PaddingTop`)
	Assert:equal(padding.PaddingRight, UDim.new(0, right), `{label}: PaddingRight`)
	Assert:equal(padding.PaddingBottom, UDim.new(0, bottom), `{label}: PaddingBottom`)
	Assert:equal(padding.PaddingLeft, UDim.new(0, left), `{label}: PaddingLeft`)
end
local PaddingMountValidation
do
	PaddingMountValidation = setmetatable({}, {
		__tostring = function()
			return "PaddingMountValidation"
		end,
	})
	PaddingMountValidation.__index = PaddingMountValidation
	function PaddingMountValidation.new(...)
		local self = setmetatable({}, PaddingMountValidation)
		return self:constructor(...) or self
	end
	function PaddingMountValidation:constructor()
	end
	function PaddingMountValidation:cssQuadSides()
		withMounted(300, 200, targetWith(React.createElement(Padding, {
			name = "Inset",
			padding = "4px 8px 12px 16px",
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local padding = findDescendant(target, "Inset")
			Assert:equal(padding.ClassName, "UIPadding")
			Assert:equal(padding.Parent, target, "Expected the UIPadding to be a direct child of the decorated frame")
			assertSides(padding, 4, 8, 12, 16, "css quad")
		end)
	end
	function PaddingMountValidation:spacingKeyAllSides()
		local expected = DefaultTheme.spacing.lg
		Assert:notUndefined(expected, "Expected the default theme to define spacing.lg")
		withMounted(300, 200, targetWith(React.createElement(Padding, {
			spacing = "lg",
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local padding = findDescendant(target, "Padding")
			assertSides(padding, expected, expected, expected, expected, "spacing=lg")
		end)
	end
	function PaddingMountValidation:noneWithSideOverride()
		local expectedTop = DefaultTheme.spacing.sm
		Assert:notUndefined(expectedTop, "Expected the default theme to define spacing.sm")
		withMounted(300, 200, targetWith(React.createElement(Padding, {
			spacing = "None",
			top = "sm",
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local padding = findDescendant(target, "Padding")
			assertSides(padding, expectedTop, 0, 0, 0, "spacing=None top=sm")
		end)
	end
	function PaddingMountValidation:shrinksChildRect()
		withMounted(300, 200, targetWith(React.createElement(React.Fragment, nil, React.createElement(Padding, {
			padding = "10px 20px 30px 40px",
		}), React.createElement("frame", {
			key = "Child",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0,
		}))), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local child = waitForGuiObject(target, "Child", function(gui)
				return gui.AbsoluteSize.X < target.AbsoluteSize.X
			end)
			assertSizeApprox(child, 140, 60, 1, "padded child")
			local childRect = rect(child)
			local targetRect = rect(target)
			Assert:approximately(childRect.left - targetRect.left, 40, 1)
			Assert:approximately(childRect.top - targetRect.top, 10, 1)
			Assert:approximately(targetRect.right - childRect.right, 20, 1)
			Assert:approximately(targetRect.bottom - childRect.bottom, 30, 1)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A four-value CSS padding quad emits a UIPadding under the parent with top/right/bottom/left in that order, renamed via name")
	local _descriptor = Test(PaddingMountValidation, "cssQuadSides", {
		value = PaddingMountValidation.cssQuadSides,
	})
	if _descriptor then
		PaddingMountValidation.cssQuadSides = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(PaddingMountValidation, "cssQuadSides", {
		value = PaddingMountValidation.cssQuadSides,
	})
	if _descriptor_1 then
		PaddingMountValidation.cssQuadSides = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(PaddingMountValidation, "cssQuadSides", {
		value = PaddingMountValidation.cssQuadSides,
	})
	if _descriptor_2 then
		PaddingMountValidation.cssQuadSides = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("A spacing scale key applies the theme's pixel value for that key to all four sides")
	local _descriptor_3 = Test(PaddingMountValidation, "spacingKeyAllSides", {
		value = PaddingMountValidation.spacingKeyAllSides,
	})
	if _descriptor_3 then
		PaddingMountValidation.spacingKeyAllSides = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(PaddingMountValidation, "spacingKeyAllSides", {
		value = PaddingMountValidation.spacingKeyAllSides,
	})
	if _descriptor_4 then
		PaddingMountValidation.spacingKeyAllSides = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(PaddingMountValidation, "spacingKeyAllSides", {
		value = PaddingMountValidation.spacingKeyAllSides,
	})
	if _descriptor_5 then
		PaddingMountValidation.spacingKeyAllSides = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("spacing=None zeroes every side, and a per-side key overrides just that side")
	local _descriptor_6 = Test(PaddingMountValidation, "noneWithSideOverride", {
		value = PaddingMountValidation.noneWithSideOverride,
	})
	if _descriptor_6 then
		PaddingMountValidation.noneWithSideOverride = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(PaddingMountValidation, "noneWithSideOverride", {
		value = PaddingMountValidation.noneWithSideOverride,
	})
	if _descriptor_7 then
		PaddingMountValidation.noneWithSideOverride = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(PaddingMountValidation, "noneWithSideOverride", {
		value = PaddingMountValidation.noneWithSideOverride,
	})
	if _descriptor_8 then
		PaddingMountValidation.noneWithSideOverride = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Padding shrinks a full-size child's rect by the given amounts on each side")
	local _descriptor_9 = Test(PaddingMountValidation, "shrinksChildRect", {
		value = PaddingMountValidation.shrinksChildRect,
	})
	if _descriptor_9 then
		PaddingMountValidation.shrinksChildRect = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(PaddingMountValidation, "shrinksChildRect", {
		value = PaddingMountValidation.shrinksChildRect,
	})
	if _descriptor_10 then
		PaddingMountValidation.shrinksChildRect = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(PaddingMountValidation, "shrinksChildRect", {
		value = PaddingMountValidation.shrinksChildRect,
	})
	if _descriptor_11 then
		PaddingMountValidation.shrinksChildRect = _descriptor_11.value
	end
	PaddingMountValidation = Tag("Studio")(PaddingMountValidation) or PaddingMountValidation
end
return PaddingMountValidation
