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
local HoverButton = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "HoverButton").HoverButton
local Tooltip = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "Tooltip").Tooltip
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _fiber = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber")
local activateButton = _fiber.activateButton
local fireHostEvent = _fiber.fireHostEvent
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForGuiObject = _layout.waitForGuiObject
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local _tooltip = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip")
local FAST_THEME = _tooltip.FAST_THEME
local assertNoPopup = _tooltip.assertNoPopup
local waitForShown = _tooltip.waitForShown
local function hoverButtonTip(log)
	return React.createElement(ThemeProvider, {
		theme = FAST_THEME,
	}, React.createElement(OverlayProvider, nil, React.createElement(Tooltip, {
		content = "Helpful hint",
	}, React.createElement(HoverButton, {
		name = "TipButton",
		default = {
			Size = UDim2.fromOffset(100, 40),
			Position = UDim2.fromOffset(150, 130),
			Event = {
				Activated = function()
					log.count += 1
				end,
			},
		},
	}))))
end
local function waitForTipButton(host)
	waitForGuiObject(host, "OverlayProvider")
	return waitForGuiObject(host, "TipButton")
end
local TooltipHoverButtonValidation
do
	TooltipHoverButtonValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipHoverButtonValidation"
		end,
	})
	TooltipHoverButtonValidation.__index = TooltipHoverButtonValidation
	function TooltipHoverButtonValidation.new(...)
		local self = setmetatable({}, TooltipHoverButtonValidation)
		return self:constructor(...) or self
	end
	function TooltipHoverButtonValidation:constructor()
	end
	function TooltipHoverButtonValidation:opensOnHover()
		withMounted(400, 300, hoverButtonTip({
			count = 0,
		}), function(mounted)
			local button = waitForTipButton(mounted.host)
			assertNoPopup(mounted.host, "Expected no popup before the HoverButton is hovered")
			fireHostEvent(mounted, button, "MouseEnter", 0, 0)
			waitForShown(mounted.host)
			fireHostEvent(mounted, button, "MouseLeave", 0, 0)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipHoverButtonValidation:keepsOwnActivated()
		local log = {
			count = 0,
		}
		withMounted(400, 300, hoverButtonTip(log), function(mounted)
			local button = waitForTipButton(mounted.host)
			activateButton(mounted, button)
			Assert:equal(log.count, 1)
			fireHostEvent(mounted, button, "MouseEnter", 0, 0)
			waitForShown(mounted.host)
			activateButton(mounted, button)
			Assert:equal(log.count, 2, "Expected Activated to still fire while the tooltip is open")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A Tooltip wrapping a bare HoverButton opens on the button's MouseEnter and closes on its MouseLeave")
	local _descriptor = Test(TooltipHoverButtonValidation, "opensOnHover", {
		value = TooltipHoverButtonValidation.opensOnHover,
	})
	if _descriptor then
		TooltipHoverButtonValidation.opensOnHover = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TooltipHoverButtonValidation, "opensOnHover", {
		value = TooltipHoverButtonValidation.opensOnHover,
	})
	if _descriptor_1 then
		TooltipHoverButtonValidation.opensOnHover = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TooltipHoverButtonValidation, "opensOnHover", {
		value = TooltipHoverButtonValidation.opensOnHover,
	})
	if _descriptor_2 then
		TooltipHoverButtonValidation.opensOnHover = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("The wrapped HoverButton's own default.Event.Activated still fires exactly once per activation")
	local _descriptor_3 = Test(TooltipHoverButtonValidation, "keepsOwnActivated", {
		value = TooltipHoverButtonValidation.keepsOwnActivated,
	})
	if _descriptor_3 then
		TooltipHoverButtonValidation.keepsOwnActivated = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TooltipHoverButtonValidation, "keepsOwnActivated", {
		value = TooltipHoverButtonValidation.keepsOwnActivated,
	})
	if _descriptor_4 then
		TooltipHoverButtonValidation.keepsOwnActivated = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TooltipHoverButtonValidation, "keepsOwnActivated", {
		value = TooltipHoverButtonValidation.keepsOwnActivated,
	})
	if _descriptor_5 then
		TooltipHoverButtonValidation.keepsOwnActivated = _descriptor_5.value
	end
	TooltipHoverButtonValidation = Tag("Studio")(TooltipHoverButtonValidation) or TooltipHoverButtonValidation
end
return TooltipHoverButtonValidation
