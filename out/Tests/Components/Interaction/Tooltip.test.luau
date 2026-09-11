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
local Tooltip = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "Tooltip").Tooltip
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertCenteredIn = _layout.assertCenteredIn
local assertContained = _layout.assertContained
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local CONTENT = "Helpful hint"
local hoverEvents
local HoverTarget = React.forwardRef(function(props, ref)
	hoverEvents = props.Event
	return React.createElement("frame", {
		key = "HoverTarget",
		ref = ref,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 40),
		Position = UDim2.fromOffset(150, 130),
		Event = props.Event,
	})
end)
local function tooltipApp(placement)
	return React.createElement(OverlayProvider, nil, React.createElement(Tooltip, {
		content = CONTENT,
		placement = placement,
	}, React.createElement(HoverTarget)))
end
local function waitForTarget(host)
	waitForGuiObject(host, "OverlayProvider")
	return waitForGuiObject(host, "HoverTarget")
end
local function hover(target)
	local events = waitForLayout(function()
		return hoverEvents
	end, "Timed out waiting for Tooltip to inject hover handlers into HoverTarget")
	Assert:notUndefined(events.MouseEnter, "Expected Tooltip to inject a MouseEnter handler")
	events.MouseEnter(target, 0, 0)
end
local function unhover(target)
	local events = waitForLayout(function()
		return hoverEvents
	end, "Timed out waiting for Tooltip to inject hover handlers into HoverTarget")
	Assert:notUndefined(events.MouseLeave, "Expected Tooltip to inject a MouseLeave handler")
	events.MouseLeave(target, 0, 0)
end
local function waitForRemoval(host, name)
	for attempt = 0, 119 do
		if host:FindFirstChild(name, true) == nil then
			return nil
		end
		task.wait()
	end
	Assert:fail(`Timed out waiting for "{name}" to be removed from {host:GetFullName()}`)
end
local TooltipMountValidation
do
	TooltipMountValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipMountValidation"
		end,
	})
	TooltipMountValidation.__index = TooltipMountValidation
	function TooltipMountValidation.new(...)
		local self = setmetatable({}, TooltipMountValidation)
		return self:constructor(...) or self
	end
	function TooltipMountValidation:constructor()
	end
	function TooltipMountValidation:hiddenUntilHover()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(), function(mounted)
			waitForTarget(mounted.host)
			task.wait()
			Assert:undefined(mounted.host:FindFirstChild("Tooltip", true), "Expected no Tooltip popup before hovering")
		end)
	end
	function TooltipMountValidation:showsOnHover(placement)
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(placement), function(mounted)
			local target = waitForTarget(mounted.host)
			hover(target)
			local overlay = findDescendant(mounted.host, "OverlayProvider")
			local tooltip = waitForGuiObject(overlay, "Tooltip")
			local content = waitForGuiObject(tooltip, "Content")
			local text = findDescendant(content, "TooltipText")
			Assert:equal(text.Text, CONTENT, "Expected a string content prop to render as TooltipText")
			assertContained(text, content, `{placement} tooltip text`)
			assertContained(tooltip, overlay, `{placement} tooltip vs overlay`)
			assertCenteredIn(tooltip, target, "x", 1, `{placement} tooltip`)
			local tooltipRect = rect(tooltip)
			local targetRect = rect(target)
			if placement == "Top" then
				Assert["true"](Assert, tooltipRect.bottom <= targetRect.top + 1, `Expected a Top tooltip (bottom={tooltipRect.bottom}) to sit above the target (top={targetRect.top})`)
			else
				Assert["true"](Assert, tooltipRect.top >= targetRect.bottom - 1, `Expected a Bottom tooltip (top={tooltipRect.top}) to sit below the target (bottom={targetRect.bottom})`)
			end
		end)
	end
	function TooltipMountValidation:hidesAfterLeave()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(), function(mounted)
			local target = waitForTarget(mounted.host)
			hover(target)
			waitForGuiObject(mounted.host, "Tooltip")
			unhover(target)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Before any hover the target is rendered but no Tooltip popup exists in the overlay")
	local _descriptor = Test(TooltipMountValidation, "hiddenUntilHover", {
		value = TooltipMountValidation.hiddenUntilHover,
	})
	if _descriptor then
		TooltipMountValidation.hiddenUntilHover = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TooltipMountValidation, "hiddenUntilHover", {
		value = TooltipMountValidation.hiddenUntilHover,
	})
	if _descriptor_1 then
		TooltipMountValidation.hiddenUntilHover = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TooltipMountValidation, "hiddenUntilHover", {
		value = TooltipMountValidation.hiddenUntilHover,
	})
	if _descriptor_2 then
		TooltipMountValidation.hiddenUntilHover = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "Top" }, { "Bottom" } })
	local _decorator_4 = DisplayName("Hovering the target portals a Tooltip into the overlay, centered on the target and on the requested side")
	local _descriptor_3 = Test(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_3 then
		TooltipMountValidation.showsOnHover = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_4 then
		TooltipMountValidation.showsOnHover = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_5 then
		TooltipMountValidation.showsOnHover = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_6 then
		TooltipMountValidation.showsOnHover = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Leaving the target fades the Tooltip out and removes it from the overlay")
	local _descriptor_7 = Test(TooltipMountValidation, "hidesAfterLeave", {
		value = TooltipMountValidation.hidesAfterLeave,
	})
	if _descriptor_7 then
		TooltipMountValidation.hidesAfterLeave = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TooltipMountValidation, "hidesAfterLeave", {
		value = TooltipMountValidation.hidesAfterLeave,
	})
	if _descriptor_8 then
		TooltipMountValidation.hidesAfterLeave = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TooltipMountValidation, "hidesAfterLeave", {
		value = TooltipMountValidation.hidesAfterLeave,
	})
	if _descriptor_9 then
		TooltipMountValidation.hidesAfterLeave = _descriptor_9.value
	end
	TooltipMountValidation = Tag("Studio")(TooltipMountValidation) or TooltipMountValidation
end
return TooltipMountValidation
