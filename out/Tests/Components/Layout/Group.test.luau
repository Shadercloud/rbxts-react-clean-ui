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
local Group = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Group").Group
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Container").Container
local VStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "VStack").VStack
local RegistryProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "registry.provider").RegistryProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertNonZeroSize = _layout.assertNonZeroSize
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 300
local NARROW_WIDTH = 80
local WIDE_WIDTH = 150
local ROW_HEIGHT = 30
local function groupedContainers(grouped)
	return React.createElement(RegistryProvider, nil, React.createElement("frame", {
		key = "Stack",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(VStack, {
		spacing = "None",
		HorizontalFlex = Enum.UIFlexAlignment.None,
	}, React.createElement(Group, nil, React.createElement(Container, {
		name = "Narrow",
		group = grouped,
		LayoutOrder = 1,
	}, React.createElement("frame", {
		key = "NarrowContent",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(NARROW_WIDTH, ROW_HEIGHT),
	})), React.createElement(Container, {
		name = "Wide",
		group = grouped,
		LayoutOrder = 2,
	}, React.createElement("frame", {
		key = "WideContent",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(WIDE_WIDTH, ROW_HEIGHT),
	}))))))
end
local GroupMountValidation
do
	GroupMountValidation = setmetatable({}, {
		__tostring = function()
			return "GroupMountValidation"
		end,
	})
	GroupMountValidation.__index = GroupMountValidation
	function GroupMountValidation.new(...)
		local self = setmetatable({}, GroupMountValidation)
		return self:constructor(...) or self
	end
	function GroupMountValidation:constructor()
	end
	function GroupMountValidation:rendersChildrenWithoutWrapper()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Group, nil, React.createElement("frame", {
			key = "Child",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(NARROW_WIDTH, ROW_HEIGHT),
		})), function(mounted)
			local child = waitForGuiObject(mounted.host, "Child")
			Assert:equal(child.Parent, mounted.host, "Expected Group's child to be parented straight to the host")
			assertNonZeroSize(child, "group child")
		end)
	end
	function GroupMountValidation:groupedContainersShareWidth()
		withMounted(HOST_WIDTH, HOST_HEIGHT, groupedContainers(true), function(mounted)
			local narrow = waitForGuiObject(mounted.host, "Narrow", function(gui)
				return gui.AbsoluteSize.X == WIDE_WIDTH
			end, `Timed out waiting for the narrow grouped Container to widen to {WIDE_WIDTH}px`)
			local wide = waitForGuiObject(mounted.host, "Wide")
			assertSizeApprox(narrow, WIDE_WIDTH, ROW_HEIGHT, 1, "narrow grouped container")
			assertSizeApprox(wide, WIDE_WIDTH, ROW_HEIGHT, 1, "wide grouped container")
			assertAllDescendantsContained(narrow, "narrow grouped container")
			assertAllDescendantsContained(wide, "wide grouped container")
		end)
	end
	function GroupMountValidation:ungroupedContainersKeepOwnWidth()
		withMounted(HOST_WIDTH, HOST_HEIGHT, groupedContainers(false), function(mounted)
			local narrow = waitForGuiObject(mounted.host, "Narrow")
			local wide = waitForGuiObject(mounted.host, "Wide")
			assertSizeApprox(narrow, NARROW_WIDTH, ROW_HEIGHT, 1, "ungrouped narrow container")
			assertSizeApprox(wide, WIDE_WIDTH, ROW_HEIGHT, 1, "ungrouped wide container")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Group renders its children directly into the parent without adding an instance of its own")
	local _descriptor = Test(GroupMountValidation, "rendersChildrenWithoutWrapper", {
		value = GroupMountValidation.rendersChildrenWithoutWrapper,
	})
	if _descriptor then
		GroupMountValidation.rendersChildrenWithoutWrapper = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(GroupMountValidation, "rendersChildrenWithoutWrapper", {
		value = GroupMountValidation.rendersChildrenWithoutWrapper,
	})
	if _descriptor_1 then
		GroupMountValidation.rendersChildrenWithoutWrapper = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(GroupMountValidation, "rendersChildrenWithoutWrapper", {
		value = GroupMountValidation.rendersChildrenWithoutWrapper,
	})
	if _descriptor_2 then
		GroupMountValidation.rendersChildrenWithoutWrapper = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Containers with group={true} inside one Group all adopt the widest member's width")
	local _descriptor_3 = Test(GroupMountValidation, "groupedContainersShareWidth", {
		value = GroupMountValidation.groupedContainersShareWidth,
	})
	if _descriptor_3 then
		GroupMountValidation.groupedContainersShareWidth = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(GroupMountValidation, "groupedContainersShareWidth", {
		value = GroupMountValidation.groupedContainersShareWidth,
	})
	if _descriptor_4 then
		GroupMountValidation.groupedContainersShareWidth = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(GroupMountValidation, "groupedContainersShareWidth", {
		value = GroupMountValidation.groupedContainersShareWidth,
	})
	if _descriptor_5 then
		GroupMountValidation.groupedContainersShareWidth = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Containers without group={true} inside a Group keep their own content width")
	local _descriptor_6 = Test(GroupMountValidation, "ungroupedContainersKeepOwnWidth", {
		value = GroupMountValidation.ungroupedContainersKeepOwnWidth,
	})
	if _descriptor_6 then
		GroupMountValidation.ungroupedContainersKeepOwnWidth = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(GroupMountValidation, "ungroupedContainersKeepOwnWidth", {
		value = GroupMountValidation.ungroupedContainersKeepOwnWidth,
	})
	if _descriptor_7 then
		GroupMountValidation.ungroupedContainersKeepOwnWidth = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(GroupMountValidation, "ungroupedContainersKeepOwnWidth", {
		value = GroupMountValidation.ungroupedContainersKeepOwnWidth,
	})
	if _descriptor_8 then
		GroupMountValidation.ungroupedContainersKeepOwnWidth = _descriptor_8.value
	end
	GroupMountValidation = Tag("Studio")(GroupMountValidation) or GroupMountValidation
end
return GroupMountValidation
