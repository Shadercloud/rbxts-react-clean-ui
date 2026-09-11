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
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Container").Container
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedLeft = _layout.assertAlignedLeft
local assertAlignedTop = _layout.assertAlignedTop
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertCenteredIn = _layout.assertCenteredIn
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 300
local CONTENT_WIDTH = 120
local CONTENT_HEIGHT = 50
local function content()
	return React.createElement("frame", {
		key = "Content",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(CONTENT_WIDTH, CONTENT_HEIGHT),
	})
end
local function waitForContainer(host, name)
	if name == nil then
		name = "Container"
	end
	return waitForGuiObject(host, name)
end
local ContainerMountValidation
do
	ContainerMountValidation = setmetatable({}, {
		__tostring = function()
			return "ContainerMountValidation"
		end,
	})
	ContainerMountValidation.__index = ContainerMountValidation
	function ContainerMountValidation.new(...)
		local self = setmetatable({}, ContainerMountValidation)
		return self:constructor(...) or self
	end
	function ContainerMountValidation:constructor()
	end
	function ContainerMountValidation:autoSizesToContent()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, nil, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			assertSizeApprox(container, CONTENT_WIDTH, CONTENT_HEIGHT, 1, "auto-sized container")
			assertAlignedLeft(container, mounted.host, 1, "auto-sized container")
			assertAlignedTop(container, mounted.host, 1, "auto-sized container")
		end)
	end
	function ContainerMountValidation:respectsExplicitSize(width, height)
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			width = width,
			height = height,
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			assertSizeApprox(container, width, height, 1, "explicit size")
		end)
	end
	function ContainerMountValidation:centeredExplicitSize()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			center = true,
			width = 200,
			height = 100,
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			assertSizeApprox(container, 200, 100, 1, "centered container")
			assertCenteredIn(container, mounted.host, "both", 1, "centered container")
		end)
	end
	function ContainerMountValidation:centeredAutoSize()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			center = true,
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			assertSizeApprox(container, CONTENT_WIDTH, CONTENT_HEIGHT, 1, "centered auto-sized container")
			assertCenteredIn(container, mounted.host, "both", 1, "centered auto-sized container")
		end)
	end
	function ContainerMountValidation:namedContainerContainsChildren()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			name = "Panel",
			width = 200,
			height = 100,
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host, "Panel")
			waitForGuiObject(container, "Content")
			assertAllDescendantsContained(container, "named container")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without width or height the Container auto-sizes to its content and sits at the host's top-left")
	local _descriptor = Test(ContainerMountValidation, "autoSizesToContent", {
		value = ContainerMountValidation.autoSizesToContent,
	})
	if _descriptor then
		ContainerMountValidation.autoSizesToContent = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ContainerMountValidation, "autoSizesToContent", {
		value = ContainerMountValidation.autoSizesToContent,
	})
	if _descriptor_1 then
		ContainerMountValidation.autoSizesToContent = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ContainerMountValidation, "autoSizesToContent", {
		value = ContainerMountValidation.autoSizesToContent,
	})
	if _descriptor_2 then
		ContainerMountValidation.autoSizesToContent = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { 300, 150 }, { 80, 40 } })
	local _decorator_4 = DisplayName("Explicit width and height props pin the Container's AbsoluteSize to those pixel values")
	local _descriptor_3 = Test(ContainerMountValidation, "respectsExplicitSize", {
		value = ContainerMountValidation.respectsExplicitSize,
	})
	if _descriptor_3 then
		ContainerMountValidation.respectsExplicitSize = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(ContainerMountValidation, "respectsExplicitSize", {
		value = ContainerMountValidation.respectsExplicitSize,
	})
	if _descriptor_4 then
		ContainerMountValidation.respectsExplicitSize = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(ContainerMountValidation, "respectsExplicitSize", {
		value = ContainerMountValidation.respectsExplicitSize,
	})
	if _descriptor_5 then
		ContainerMountValidation.respectsExplicitSize = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(ContainerMountValidation, "respectsExplicitSize", {
		value = ContainerMountValidation.respectsExplicitSize,
	})
	if _descriptor_6 then
		ContainerMountValidation.respectsExplicitSize = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("center={true} with a fixed width and height places the Container in the middle of the host")
	local _descriptor_7 = Test(ContainerMountValidation, "centeredExplicitSize", {
		value = ContainerMountValidation.centeredExplicitSize,
	})
	if _descriptor_7 then
		ContainerMountValidation.centeredExplicitSize = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(ContainerMountValidation, "centeredExplicitSize", {
		value = ContainerMountValidation.centeredExplicitSize,
	})
	if _descriptor_8 then
		ContainerMountValidation.centeredExplicitSize = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(ContainerMountValidation, "centeredExplicitSize", {
		value = ContainerMountValidation.centeredExplicitSize,
	})
	if _descriptor_9 then
		ContainerMountValidation.centeredExplicitSize = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("center={true} on an auto-sized Container centers it via the layout wrapper while keeping its content size")
	local _descriptor_10 = Test(ContainerMountValidation, "centeredAutoSize", {
		value = ContainerMountValidation.centeredAutoSize,
	})
	if _descriptor_10 then
		ContainerMountValidation.centeredAutoSize = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(ContainerMountValidation, "centeredAutoSize", {
		value = ContainerMountValidation.centeredAutoSize,
	})
	if _descriptor_11 then
		ContainerMountValidation.centeredAutoSize = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(ContainerMountValidation, "centeredAutoSize", {
		value = ContainerMountValidation.centeredAutoSize,
	})
	if _descriptor_12 then
		ContainerMountValidation.centeredAutoSize = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("A named, fixed-size Container renders under that name and keeps every visible descendant inside itself")
	local _descriptor_13 = Test(ContainerMountValidation, "namedContainerContainsChildren", {
		value = ContainerMountValidation.namedContainerContainsChildren,
	})
	if _descriptor_13 then
		ContainerMountValidation.namedContainerContainsChildren = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(ContainerMountValidation, "namedContainerContainsChildren", {
		value = ContainerMountValidation.namedContainerContainsChildren,
	})
	if _descriptor_14 then
		ContainerMountValidation.namedContainerContainsChildren = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(ContainerMountValidation, "namedContainerContainsChildren", {
		value = ContainerMountValidation.namedContainerContainsChildren,
	})
	if _descriptor_15 then
		ContainerMountValidation.namedContainerContainsChildren = _descriptor_15.value
	end
	ContainerMountValidation = Tag("Studio")(ContainerMountValidation) or ContainerMountValidation
end
return ContainerMountValidation
