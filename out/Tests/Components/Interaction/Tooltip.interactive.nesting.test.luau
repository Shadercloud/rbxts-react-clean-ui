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
local Each = _binding.Each
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _tooltip = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip")
local HOLD_SECONDS = _tooltip.HOLD_SECONDS
local assertStaysShown = _tooltip.assertStaysShown
local nestedApp = _tooltip.nestedApp
local waitForShown = _tooltip.waitForShown
local waitForTrigger = _tooltip.waitForTrigger
local TooltipNestingValidation
do
	TooltipNestingValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipNestingValidation"
		end,
	})
	TooltipNestingValidation.__index = TooltipNestingValidation
	function TooltipNestingValidation.new(...)
		local self = setmetatable({}, TooltipNestingValidation)
		return self:constructor(...) or self
	end
	function TooltipNestingValidation:constructor()
	end
	function TooltipNestingValidation:childHoldsParent(mode)
		withMounted(400, 300, nestedApp(mode, true), function(mounted)
			local trigger = waitForTrigger(mounted.host, "ParentTrigger")
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			waitForShown(mounted.host, "ParentTip")
			waitForShown(mounted.host, "ChildTip")
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			assertStaysShown(mounted.host, HOLD_SECONDS, `Expected the nested tooltip to hold the {mode} parent open`, "ParentTip")
			mounted.update(nestedApp(mode, false))
			waitForRemoval(mounted.host, "ParentTip")
		end)
	end
	function TooltipNestingValidation:plainParentCloses()
		withMounted(400, 300, nestedApp("plain", true), function(mounted)
			local trigger = waitForTrigger(mounted.host, "ParentTrigger")
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			waitForShown(mounted.host, "ParentTip")
			waitForShown(mounted.host, "ChildTip")
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			waitForRemoval(mounted.host, "ParentTip")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "interactive" }, { "pinOnPress" } })
	local _decorator_2 = DisplayName("An open nested tooltip keeps an interactive or pinOnPress parent open until the nested one hides")
	local _descriptor = Test(TooltipNestingValidation, "childHoldsParent", {
		value = TooltipNestingValidation.childHoldsParent,
	})
	if _descriptor then
		TooltipNestingValidation.childHoldsParent = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TooltipNestingValidation, "childHoldsParent", {
		value = TooltipNestingValidation.childHoldsParent,
	})
	if _descriptor_1 then
		TooltipNestingValidation.childHoldsParent = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TooltipNestingValidation, "childHoldsParent", {
		value = TooltipNestingValidation.childHoldsParent,
	})
	if _descriptor_2 then
		TooltipNestingValidation.childHoldsParent = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TooltipNestingValidation, "childHoldsParent", {
		value = TooltipNestingValidation.childHoldsParent,
	})
	if _descriptor_3 then
		TooltipNestingValidation.childHoldsParent = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("An open nested tooltip does not keep a plain hover parent open after its trigger is left")
	local _descriptor_4 = Test(TooltipNestingValidation, "plainParentCloses", {
		value = TooltipNestingValidation.plainParentCloses,
	})
	if _descriptor_4 then
		TooltipNestingValidation.plainParentCloses = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(TooltipNestingValidation, "plainParentCloses", {
		value = TooltipNestingValidation.plainParentCloses,
	})
	if _descriptor_5 then
		TooltipNestingValidation.plainParentCloses = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TooltipNestingValidation, "plainParentCloses", {
		value = TooltipNestingValidation.plainParentCloses,
	})
	if _descriptor_6 then
		TooltipNestingValidation.plainParentCloses = _descriptor_6.value
	end
	TooltipNestingValidation = Tag("Studio")(TooltipNestingValidation) or TooltipNestingValidation
end
return TooltipNestingValidation
