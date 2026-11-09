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
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Container").Container
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
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
local BORDER_COLOR = Color3.fromRGB(200, 40, 40)
local function waitForContainer(host, name)
	if name == nil then
		name = "Container"
	end
	return waitForGuiObject(host, name)
end
local function strokeOf(container)
	local stroke = container:FindFirstChildWhichIsA("UIStroke")
	Assert:notUndefined(stroke, `Expected {container.Name} to have a direct UIStroke child`)
	return stroke
end
local function paddingOf(container)
	local padding = container:FindFirstChildWhichIsA("UIPadding")
	Assert:notUndefined(padding, `Expected {container.Name} to have a direct UIPadding child`)
	return padding
end
local function cornerOf(container)
	local corner = container:FindFirstChildWhichIsA("UICorner")
	Assert:notUndefined(corner, `Expected {container.Name} to have a direct UICorner child`)
	return corner
end
local function assertNoDecorators(instance, label)
	Assert:undefined(instance:FindFirstChildWhichIsA("UIStroke"), `{label}: expected no UIStroke`)
	Assert:undefined(instance:FindFirstChildWhichIsA("UIPadding"), `{label}: expected no UIPadding`)
	Assert:undefined(instance:FindFirstChildWhichIsA("UICorner"), `{label}: expected no UICorner`)
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
	function ContainerMountValidation:noDecoratorsByDefault()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, nil, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			assertNoDecorators(container, "unset props")
		end)
	end
	function ContainerMountValidation:zeroThicknessNoStroke()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			borderThickness = 0,
			borderColor = BORDER_COLOR,
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			Assert:undefined(container:FindFirstChildWhichIsA("UIStroke"), "Expected no UIStroke for borderThickness 0")
		end)
	end
	function ContainerMountValidation:strokeFromBorderProps()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			borderThickness = 2,
			borderColor = BORDER_COLOR,
			borderTransparency = 0.5,
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			local stroke = strokeOf(container)
			Assert:equal(stroke.Name, "Stroke")
			Assert:equal(stroke.Thickness, 2)
			Assert:equal(stroke.Color, BORDER_COLOR)
			Assert:equal(stroke.Transparency, 0.5)
			Assert:equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner)
		end)
	end
	function ContainerMountValidation:outerBorderPosition()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			borderThickness = 1,
			borderPosition = "outer",
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			Assert:equal(strokeOf(container).BorderStrokePosition, Enum.BorderStrokePosition.Outer)
		end)
	end
	function ContainerMountValidation:paddingQuadSides(padding, top, right, bottom, left)
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			padding = padding,
		}, content()), function(mounted)
			local uiPadding = paddingOf(waitForContainer(mounted.host))
			Assert:equal(uiPadding.Name, "Padding")
			Assert:equal(uiPadding.PaddingTop, UDim.new(0, top), `padding="{padding}": PaddingTop`)
			Assert:equal(uiPadding.PaddingRight, UDim.new(0, right), `padding="{padding}": PaddingRight`)
			Assert:equal(uiPadding.PaddingBottom, UDim.new(0, bottom), `padding="{padding}": PaddingBottom`)
			Assert:equal(uiPadding.PaddingLeft, UDim.new(0, left), `padding="{padding}": PaddingLeft`)
		end)
	end
	function ContainerMountValidation:paddingGrowsAutoSize()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			padding = "4 8 12 16",
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			assertSizeApprox(container, CONTENT_WIDTH + 8 + 16, CONTENT_HEIGHT + 4 + 12, 1, "padded container")
		end)
	end
	function ContainerMountValidation:cornerRadiusResolves(radius, scale, offset)
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			cornerRadius = radius,
		}, content()), function(mounted)
			local corner = cornerOf(waitForContainer(mounted.host))
			Assert:equal(corner.Name, "Corners")
			Assert:equal(corner.CornerRadius, UDim.new(scale, offset), `cornerRadius={radius}`)
		end)
	end
	function ContainerMountValidation:zeroRadiusNoCorner()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			cornerRadius = 0,
		}, content()), function(mounted)
			local container = waitForContainer(mounted.host)
			Assert:undefined(container:FindFirstChildWhichIsA("UICorner"), "Expected no UICorner for cornerRadius 0")
		end)
	end
	function ContainerMountValidation:centeredDecoratorsOnInner()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			center = true,
			borderThickness = 2,
			padding = "6",
			cornerRadius = "md",
		}, content()), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "ContainerCenterWrapper")
			local container = waitForContainer(wrapper)
			assertNoDecorators(wrapper, "centering wrapper")
			Assert:equal(strokeOf(container).Thickness, 2)
			Assert:equal(paddingOf(container).PaddingTop, UDim.new(0, 6))
			Assert:equal(cornerOf(container).CornerRadius, UDim.new(0, DefaultTheme.radius.md))
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
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("With no border, padding or cornerRadius props the Container renders no UIStroke, UIPadding or UICorner")
	local _descriptor_16 = Test(ContainerMountValidation, "noDecoratorsByDefault", {
		value = ContainerMountValidation.noDecoratorsByDefault,
	})
	if _descriptor_16 then
		ContainerMountValidation.noDecoratorsByDefault = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(ContainerMountValidation, "noDecoratorsByDefault", {
		value = ContainerMountValidation.noDecoratorsByDefault,
	})
	if _descriptor_17 then
		ContainerMountValidation.noDecoratorsByDefault = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(ContainerMountValidation, "noDecoratorsByDefault", {
		value = ContainerMountValidation.noDecoratorsByDefault,
	})
	if _descriptor_18 then
		ContainerMountValidation.noDecoratorsByDefault = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("A zero borderThickness renders no UIStroke even when a borderColor is given")
	local _descriptor_19 = Test(ContainerMountValidation, "zeroThicknessNoStroke", {
		value = ContainerMountValidation.zeroThicknessNoStroke,
	})
	if _descriptor_19 then
		ContainerMountValidation.zeroThicknessNoStroke = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_14(ContainerMountValidation, "zeroThicknessNoStroke", {
		value = ContainerMountValidation.zeroThicknessNoStroke,
	})
	if _descriptor_20 then
		ContainerMountValidation.zeroThicknessNoStroke = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_13(ContainerMountValidation, "zeroThicknessNoStroke", {
		value = ContainerMountValidation.zeroThicknessNoStroke,
	})
	if _descriptor_21 then
		ContainerMountValidation.zeroThicknessNoStroke = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("A positive borderThickness renders a Stroke with that thickness, colour and transparency, drawn inside by default")
	local _descriptor_22 = Test(ContainerMountValidation, "strokeFromBorderProps", {
		value = ContainerMountValidation.strokeFromBorderProps,
	})
	if _descriptor_22 then
		ContainerMountValidation.strokeFromBorderProps = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_16(ContainerMountValidation, "strokeFromBorderProps", {
		value = ContainerMountValidation.strokeFromBorderProps,
	})
	if _descriptor_23 then
		ContainerMountValidation.strokeFromBorderProps = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_15(ContainerMountValidation, "strokeFromBorderProps", {
		value = ContainerMountValidation.strokeFromBorderProps,
	})
	if _descriptor_24 then
		ContainerMountValidation.strokeFromBorderProps = _descriptor_24.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("borderPosition outer draws the stroke outside the Container's bounds")
	local _descriptor_25 = Test(ContainerMountValidation, "outerBorderPosition", {
		value = ContainerMountValidation.outerBorderPosition,
	})
	if _descriptor_25 then
		ContainerMountValidation.outerBorderPosition = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_18(ContainerMountValidation, "outerBorderPosition", {
		value = ContainerMountValidation.outerBorderPosition,
	})
	if _descriptor_26 then
		ContainerMountValidation.outerBorderPosition = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_17(ContainerMountValidation, "outerBorderPosition", {
		value = ContainerMountValidation.outerBorderPosition,
	})
	if _descriptor_27 then
		ContainerMountValidation.outerBorderPosition = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = Each({ { "8", 8, 8, 8, 8 }, { "4 12", 4, 12, 4, 12 }, { "4 8 12 16", 4, 8, 12, 16 } })
	local _decorator_21 = DisplayName("A CSS padding quad becomes a UIPadding named Padding with the matching pixel offset on each side")
	local _descriptor_28 = Test(ContainerMountValidation, "paddingQuadSides", {
		value = ContainerMountValidation.paddingQuadSides,
	})
	if _descriptor_28 then
		ContainerMountValidation.paddingQuadSides = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_21(ContainerMountValidation, "paddingQuadSides", {
		value = ContainerMountValidation.paddingQuadSides,
	})
	if _descriptor_29 then
		ContainerMountValidation.paddingQuadSides = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_20(ContainerMountValidation, "paddingQuadSides", {
		value = ContainerMountValidation.paddingQuadSides,
	})
	if _descriptor_30 then
		ContainerMountValidation.paddingQuadSides = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_19(ContainerMountValidation, "paddingQuadSides", {
		value = ContainerMountValidation.paddingQuadSides,
	})
	if _descriptor_31 then
		ContainerMountValidation.paddingQuadSides = _descriptor_31.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("Padding grows an auto-sized Container by the padded amount around its content")
	local _descriptor_32 = Test(ContainerMountValidation, "paddingGrowsAutoSize", {
		value = ContainerMountValidation.paddingGrowsAutoSize,
	})
	if _descriptor_32 then
		ContainerMountValidation.paddingGrowsAutoSize = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_23(ContainerMountValidation, "paddingGrowsAutoSize", {
		value = ContainerMountValidation.paddingGrowsAutoSize,
	})
	if _descriptor_33 then
		ContainerMountValidation.paddingGrowsAutoSize = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_22(ContainerMountValidation, "paddingGrowsAutoSize", {
		value = ContainerMountValidation.paddingGrowsAutoSize,
	})
	if _descriptor_34 then
		ContainerMountValidation.paddingGrowsAutoSize = _descriptor_34.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_25 = Each({ { 6, 0, 6 }, { "50%", 0.5, 0 }, { "sm", 0, DefaultTheme.radius.sm }, { "lg", 0, DefaultTheme.radius.lg } })
	local _decorator_26 = DisplayName("cornerRadius accepts pixels, percentages and theme radius tokens and renders a UICorner named Corners")
	local _descriptor_35 = Test(ContainerMountValidation, "cornerRadiusResolves", {
		value = ContainerMountValidation.cornerRadiusResolves,
	})
	if _descriptor_35 then
		ContainerMountValidation.cornerRadiusResolves = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_26(ContainerMountValidation, "cornerRadiusResolves", {
		value = ContainerMountValidation.cornerRadiusResolves,
	})
	if _descriptor_36 then
		ContainerMountValidation.cornerRadiusResolves = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_25(ContainerMountValidation, "cornerRadiusResolves", {
		value = ContainerMountValidation.cornerRadiusResolves,
	})
	if _descriptor_37 then
		ContainerMountValidation.cornerRadiusResolves = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_24(ContainerMountValidation, "cornerRadiusResolves", {
		value = ContainerMountValidation.cornerRadiusResolves,
	})
	if _descriptor_38 then
		ContainerMountValidation.cornerRadiusResolves = _descriptor_38.value
	end
	local _decorator_27 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_28 = DisplayName("A zero cornerRadius renders no UICorner")
	local _descriptor_39 = Test(ContainerMountValidation, "zeroRadiusNoCorner", {
		value = ContainerMountValidation.zeroRadiusNoCorner,
	})
	if _descriptor_39 then
		ContainerMountValidation.zeroRadiusNoCorner = _descriptor_39.value
	end
	local _descriptor_40 = _decorator_28(ContainerMountValidation, "zeroRadiusNoCorner", {
		value = ContainerMountValidation.zeroRadiusNoCorner,
	})
	if _descriptor_40 then
		ContainerMountValidation.zeroRadiusNoCorner = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_27(ContainerMountValidation, "zeroRadiusNoCorner", {
		value = ContainerMountValidation.zeroRadiusNoCorner,
	})
	if _descriptor_41 then
		ContainerMountValidation.zeroRadiusNoCorner = _descriptor_41.value
	end
	local _decorator_29 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_30 = DisplayName("With center on an auto-sized Container the stroke, padding and corners land on the inner Container, not the wrapper")
	local _descriptor_42 = Test(ContainerMountValidation, "centeredDecoratorsOnInner", {
		value = ContainerMountValidation.centeredDecoratorsOnInner,
	})
	if _descriptor_42 then
		ContainerMountValidation.centeredDecoratorsOnInner = _descriptor_42.value
	end
	local _descriptor_43 = _decorator_30(ContainerMountValidation, "centeredDecoratorsOnInner", {
		value = ContainerMountValidation.centeredDecoratorsOnInner,
	})
	if _descriptor_43 then
		ContainerMountValidation.centeredDecoratorsOnInner = _descriptor_43.value
	end
	local _descriptor_44 = _decorator_29(ContainerMountValidation, "centeredDecoratorsOnInner", {
		value = ContainerMountValidation.centeredDecoratorsOnInner,
	})
	if _descriptor_44 then
		ContainerMountValidation.centeredDecoratorsOnInner = _descriptor_44.value
	end
	ContainerMountValidation = Tag("Studio")(ContainerMountValidation) or ContainerMountValidation
end
return ContainerMountValidation
