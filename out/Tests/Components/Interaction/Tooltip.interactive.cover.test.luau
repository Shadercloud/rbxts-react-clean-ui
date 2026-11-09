-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _tooltip = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip")
local assertNoPopup = _tooltip.assertNoPopup
local assertStaysShown = _tooltip.assertStaysShown
local coverApp = _tooltip.coverApp
local pressInput = _tooltip.pressInput
local waitForShown = _tooltip.waitForShown
local waitForTrigger = _tooltip.waitForTrigger
local TooltipCoverValidation
do
	TooltipCoverValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipCoverValidation"
		end,
	})
	TooltipCoverValidation.__index = TooltipCoverValidation
	function TooltipCoverValidation.new(...)
		local self = setmetatable({}, TooltipCoverValidation)
		return self:constructor(...) or self
	end
	function TooltipCoverValidation:constructor()
	end
	function TooltipCoverValidation:coveredIgnoresHover()
		withMounted(400, 300, coverApp({
			interactive = true,
		}), function(mounted)
			local cover = waitForTrigger(mounted.host, "CoverTrigger")
			local under = waitForTrigger(mounted.host, "UnderTrigger")
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0)
			local coverPopup = waitForShown(mounted.host, "CoverTip")
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0)
			fireHostEvent(mounted, cover, "MouseLeave", 0, 0)
			fireHostEvent(mounted, under, "MouseEnter", 0, 0)
			assertNoPopup(mounted.host, "Expected a covered trigger not to open on MouseEnter", "UnderTip")
			fireHostEvent(mounted, coverPopup, "MouseLeave", 0, 0)
			waitForShown(mounted.host, "UnderTip")
		end)
	end
	function TooltipCoverValidation:coveredClosesOpen()
		withMounted(400, 300, coverApp({
			interactive = true,
		}), function(mounted)
			local cover = waitForTrigger(mounted.host, "CoverTrigger")
			local under = waitForTrigger(mounted.host, "UnderTrigger")
			fireHostEvent(mounted, under, "MouseEnter", 0, 0)
			waitForShown(mounted.host, "UnderTip")
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0)
			local coverPopup = waitForShown(mounted.host, "CoverTip")
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0)
			waitForRemoval(mounted.host, "UnderTip")
		end)
	end
	function TooltipCoverValidation:coveredIgnoresPress()
		withMounted(400, 300, coverApp({
			interactive = true,
		}, {
			pinOnPress = true,
		}), function(mounted)
			local cover = waitForTrigger(mounted.host, "CoverTrigger")
			local under = waitForTrigger(mounted.host, "UnderTrigger")
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0)
			local coverPopup = waitForShown(mounted.host, "CoverTip")
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0)
			fireHostEvent(mounted, cover, "MouseLeave", 0, 0)
			fireHostEvent(mounted, under, "InputBegan", pressInput())
			assertNoPopup(mounted.host, "Expected a covered trigger to ignore a press", "UnderTip")
			fireHostEvent(mounted, coverPopup, "MouseLeave", 0, 0)
			waitForRemoval(mounted.host, "CoverTip")
			fireHostEvent(mounted, under, "InputBegan", pressInput())
			waitForShown(mounted.host, "UnderTip")
			assertStaysShown(mounted.host, 0.2, "Expected an uncovered trigger to pin on press", "UnderTip")
		end)
	end
	function TooltipCoverValidation:uncoverOnHide()
		withMounted(400, 300, coverApp({
			interactive = true,
		}), function(mounted)
			local cover = waitForTrigger(mounted.host, "CoverTrigger")
			local under = waitForTrigger(mounted.host, "UnderTrigger")
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0)
			local coverPopup = waitForShown(mounted.host, "CoverTip")
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0)
			fireHostEvent(mounted, under, "MouseEnter", 0, 0)
			assertNoPopup(mounted.host, "Expected a covered trigger not to open on MouseEnter", "UnderTip")
			mounted.update(coverApp({
				interactive = true,
				disabled = true,
			}))
			waitForShown(mounted.host, "UnderTip")
		end)
	end
	function TooltipCoverValidation:centerDoesNotCover()
		withMounted(400, 300, coverApp({
			placement = "Center",
		}), function(mounted)
			local cover = waitForTrigger(mounted.host, "CoverTrigger")
			local under = waitForTrigger(mounted.host, "UnderTrigger")
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0)
			local coverPopup = waitForShown(mounted.host, "CoverTip")
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0)
			fireHostEvent(mounted, under, "MouseEnter", 0, 0)
			waitForShown(mounted.host, "UnderTip")
		end)
	end
	function TooltipCoverValidation:controlledNoCover()
		withMounted(400, 300, coverApp({
			open = true,
			interactive = true,
		}), function(mounted)
			local under = waitForTrigger(mounted.host, "UnderTrigger")
			local coverPopup = waitForShown(mounted.host, "CoverTip")
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0)
			fireHostEvent(mounted, under, "MouseEnter", 0, 0)
			waitForShown(mounted.host, "UnderTip")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A trigger covered by a hovered interactive popup ignores MouseEnter, then opens once the popup is left")
	local _descriptor = Test(TooltipCoverValidation, "coveredIgnoresHover", {
		value = TooltipCoverValidation.coveredIgnoresHover,
	})
	if _descriptor then
		TooltipCoverValidation.coveredIgnoresHover = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TooltipCoverValidation, "coveredIgnoresHover", {
		value = TooltipCoverValidation.coveredIgnoresHover,
	})
	if _descriptor_1 then
		TooltipCoverValidation.coveredIgnoresHover = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TooltipCoverValidation, "coveredIgnoresHover", {
		value = TooltipCoverValidation.coveredIgnoresHover,
	})
	if _descriptor_2 then
		TooltipCoverValidation.coveredIgnoresHover = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("An open hover-only tooltip closes once an interactive popup covering its trigger is hovered")
	local _descriptor_3 = Test(TooltipCoverValidation, "coveredClosesOpen", {
		value = TooltipCoverValidation.coveredClosesOpen,
	})
	if _descriptor_3 then
		TooltipCoverValidation.coveredClosesOpen = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TooltipCoverValidation, "coveredClosesOpen", {
		value = TooltipCoverValidation.coveredClosesOpen,
	})
	if _descriptor_4 then
		TooltipCoverValidation.coveredClosesOpen = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TooltipCoverValidation, "coveredClosesOpen", {
		value = TooltipCoverValidation.coveredClosesOpen,
	})
	if _descriptor_5 then
		TooltipCoverValidation.coveredClosesOpen = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A covered pinOnPress trigger ignores presses, and accepts them again once the covering popup is gone")
	local _descriptor_6 = Test(TooltipCoverValidation, "coveredIgnoresPress", {
		value = TooltipCoverValidation.coveredIgnoresPress,
	})
	if _descriptor_6 then
		TooltipCoverValidation.coveredIgnoresPress = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TooltipCoverValidation, "coveredIgnoresPress", {
		value = TooltipCoverValidation.coveredIgnoresPress,
	})
	if _descriptor_7 then
		TooltipCoverValidation.coveredIgnoresPress = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TooltipCoverValidation, "coveredIgnoresPress", {
		value = TooltipCoverValidation.coveredIgnoresPress,
	})
	if _descriptor_8 then
		TooltipCoverValidation.coveredIgnoresPress = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("A still-hovered covered trigger opens once the covering interactive tooltip hides because it was disabled")
	local _descriptor_9 = Test(TooltipCoverValidation, "uncoverOnHide", {
		value = TooltipCoverValidation.uncoverOnHide,
	})
	if _descriptor_9 then
		TooltipCoverValidation.uncoverOnHide = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TooltipCoverValidation, "uncoverOnHide", {
		value = TooltipCoverValidation.uncoverOnHide,
	})
	if _descriptor_10 then
		TooltipCoverValidation.uncoverOnHide = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TooltipCoverValidation, "uncoverOnHide", {
		value = TooltipCoverValidation.uncoverOnHide,
	})
	if _descriptor_11 then
		TooltipCoverValidation.uncoverOnHide = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A hovered non-interactive Center popup does not cover other triggers")
	local _descriptor_12 = Test(TooltipCoverValidation, "centerDoesNotCover", {
		value = TooltipCoverValidation.centerDoesNotCover,
	})
	if _descriptor_12 then
		TooltipCoverValidation.centerDoesNotCover = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(TooltipCoverValidation, "centerDoesNotCover", {
		value = TooltipCoverValidation.centerDoesNotCover,
	})
	if _descriptor_13 then
		TooltipCoverValidation.centerDoesNotCover = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TooltipCoverValidation, "centerDoesNotCover", {
		value = TooltipCoverValidation.centerDoesNotCover,
	})
	if _descriptor_14 then
		TooltipCoverValidation.centerDoesNotCover = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A controlled open={true} interactive popup ignores interactive, so hovering it covers no other trigger")
	local _descriptor_15 = Test(TooltipCoverValidation, "controlledNoCover", {
		value = TooltipCoverValidation.controlledNoCover,
	})
	if _descriptor_15 then
		TooltipCoverValidation.controlledNoCover = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(TooltipCoverValidation, "controlledNoCover", {
		value = TooltipCoverValidation.controlledNoCover,
	})
	if _descriptor_16 then
		TooltipCoverValidation.controlledNoCover = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(TooltipCoverValidation, "controlledNoCover", {
		value = TooltipCoverValidation.controlledNoCover,
	})
	if _descriptor_17 then
		TooltipCoverValidation.controlledNoCover = _descriptor_17.value
	end
	TooltipCoverValidation = Tag("Studio")(TooltipCoverValidation) or TooltipCoverValidation
end
return TooltipCoverValidation
