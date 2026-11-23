-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
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
local UiScaleRoot = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "UiScaleRoot").UiScaleRoot
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 300
local function scaledApp(scale, props)
	if props == nil then
		props = {}
	end
	return React.createElement(UiScaleRoot, {
		scale = scale,
		ZIndex = props.ZIndex,
		name = props.name,
	}, React.createElement("frame", {
		key = "Content",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 40),
	}))
end
local function waitForRoot(host, name)
	if name == nil then
		name = "UiScaleRoot"
	end
	return waitForGuiObject(host, name)
end
local function guiChildren(instance)
	local found = {}
	for _, child in instance:GetChildren() do
		if child:IsA("GuiObject") then
			table.insert(found, child)
		end
	end
	return found
end
local function fillsArea(frame, width, height)
	return math.abs(frame.AbsoluteSize.X - width) <= 0.5 and math.abs(frame.AbsoluteSize.Y - height) <= 0.5
end
local UiScaleRootMountValidation
do
	UiScaleRootMountValidation = setmetatable({}, {
		__tostring = function()
			return "UiScaleRootMountValidation"
		end,
	})
	UiScaleRootMountValidation.__index = UiScaleRootMountValidation
	function UiScaleRootMountValidation.new(...)
		local self = setmetatable({}, UiScaleRootMountValidation)
		return self:constructor(...) or self
	end
	function UiScaleRootMountValidation:constructor()
	end
	function UiScaleRootMountValidation:fillsHost(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(scale), function(mounted)
			local root = waitForRoot(mounted.host)
			waitForLayout(function()
				return if fillsArea(root, HOST_WIDTH, HOST_HEIGHT) then true else nil
			end, `Timed out waiting for the scale {scale} root to fill the {HOST_WIDTH}x{HOST_HEIGHT} host (is {root.AbsoluteSize.X}x{root.AbsoluteSize.Y})`)
			Assert["true"](Assert, math.abs(root.AbsolutePosition.X - mounted.host.AbsolutePosition.X) <= 0.5 and math.abs(root.AbsolutePosition.Y - mounted.host.AbsolutePosition.Y) <= 0.5, `Expected the scale {scale} root to share the host's top-left corner`)
		end)
	end
	function UiScaleRootMountValidation:fillsScreenGui(scale)
		local coreGui = game:FindFirstChild("CoreGui")
		Assert:notUndefined(coreGui, "Expected CoreGui to be available to host the ScreenGui")
		local gui = Instance.new("ScreenGui")
		gui.Name = "UiScaleRootScreenGui"
		gui.Parent = coreGui
		local root = ReactRoblox.createRoot(gui)
		TS.try(function()
			root:render(scaledApp(scale))
			task.wait()
			local frame = waitForRoot(gui)
			waitForLayout(function()
				return if fillsArea(frame, gui.AbsoluteSize.X, gui.AbsoluteSize.Y) then true else nil
			end, `Timed out waiting for the scale {scale} root ({frame.AbsoluteSize.X}x{frame.AbsoluteSize.Y}) to fill the ScreenGui ({gui.AbsoluteSize.X}x{gui.AbsoluteSize.Y})`)
		end, nil, function()
			root:unmount()
			gui:Destroy()
		end)
	end
	function UiScaleRootMountValidation:uiScaleSet(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(scale), function(mounted)
			local root = waitForRoot(mounted.host)
			local uiScale = root:FindFirstChild("UiScale")
			Assert:notUndefined(uiScale, "Expected a UiScale child on the root frame")
			Assert["true"](Assert, uiScale:IsA("UIScale"), `Expected UiScale to be a UIScale, got {uiScale.ClassName}`)
			Assert:equal(uiScale.Scale, scale, "Expected UIScale.Scale to equal the scale prop")
			Assert:equal(root.Size, UDim2.fromScale(1 / scale, 1 / scale), "Expected the root frame Size to be fromScale(1/scale, 1/scale)")
		end)
	end
	function UiScaleRootMountValidation:childScaled(scale, expectedWidth, expectedHeight)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(scale), function(mounted)
			local root = waitForRoot(mounted.host)
			local content = waitForGuiObject(root, "Content", function(gui)
				return math.abs(gui.AbsoluteSize.X - expectedWidth) <= 0.5
			end, `Timed out waiting for Content to render {expectedWidth}px wide at scale {scale}`)
			assertSizeApprox(content, expectedWidth, expectedHeight, 0.5, `scale {scale} content`)
		end)
	end
	function UiScaleRootMountValidation:transparent()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1.5), function(mounted)
			local root = waitForRoot(mounted.host)
			Assert:equal(root.BackgroundTransparency, 1, "Expected BackgroundTransparency 1")
			Assert:equal(root.BorderSizePixel, 0, "Expected BorderSizePixel 0")
			Assert:equal(root.Position, UDim2.new(), "Expected the default Position")
			Assert:equal(root.AnchorPoint, Vector2.zero, "Expected the default AnchorPoint")
			Assert["false"](Assert, root.Active, "Expected the root frame not to be Active")
		end)
	end
	function UiScaleRootMountValidation:zIndexForwarded(zIndex, expected)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1.25, {
			ZIndex = zIndex,
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			Assert:equal(root.ZIndex, expected, `Expected the root frame ZIndex to be {expected}`)
		end)
	end
	function UiScaleRootMountValidation:treeShapeAtOne()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1), function(mounted)
			local root = waitForRoot(mounted.host)
			local hostChildren = mounted.host:GetChildren()
			Assert:equal(#hostChildren, 1, "Expected the root frame to be the host's only child")
			Assert:equal(hostChildren[1], root, "Expected the host's only child to be the UiScaleRoot frame")
			Assert:equal(root.Size, UDim2.fromScale(1, 1), "Expected a scale 1 root to be fromScale(1, 1)")
			local children = root:GetChildren()
			Assert:equal(#children, 2, `Expected exactly UiScale and Content under the root, got {#children} children`)
			local uiScale = findDescendant(root, "UiScale")
			Assert:equal(uiScale.Parent, root, "Expected UiScale directly under the root frame")
			Assert:equal(uiScale.Scale, 1, "Expected UiScale.Scale 1")
			local gui = guiChildren(root)
			Assert:equal(#gui, 1, "Expected Content to be the only GuiObject under the root")
			Assert:equal(gui[1].Name, "Content", "Expected the child to be rendered directly under the root frame")
		end)
	end
	function UiScaleRootMountValidation:customName()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1.25, {
			name = "AppScale",
		}), function(mounted)
			waitForRoot(mounted.host, "AppScale")
			Assert:undefined(mounted.host:FindFirstChild("UiScaleRoot"), "Expected no frame under the default name")
		end)
	end
	function UiScaleRootMountValidation:forwardsRef()
		local ref = React.createRef()
		local element = (React.createElement(UiScaleRoot, {
			ref = ref,
			scale = 1.5,
		}, React.createElement("frame", {
			key = "Content",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(100, 40),
		})))
		withMounted(HOST_WIDTH, HOST_HEIGHT, element, function(mounted)
			local root = waitForRoot(mounted.host)
			waitForLayout(function()
				return ref.current
			end, "Timed out waiting for the forwarded ref to be assigned")
			Assert:equal(ref.current, root, "Expected the forwarded ref to point at the UiScaleRoot frame")
		end)
	end
	function UiScaleRootMountValidation:nestedComposes()
		local element = (React.createElement(UiScaleRoot, {
			scale = 1.25,
		}, React.createElement(UiScaleRoot, {
			name = "InnerRoot",
			scale = 1.2,
		}, React.createElement("frame", {
			key = "Content",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(100, 40),
		}))))
		withMounted(HOST_WIDTH, HOST_HEIGHT, element, function(mounted)
			local inner = waitForRoot(mounted.host, "InnerRoot")
			local content = waitForGuiObject(inner, "Content", function(gui)
				return math.abs(gui.AbsoluteSize.X - 150) <= 0.5
			end, "Timed out waiting for the nested Content to render at 150px")
			waitForDescendant(inner, "UiScale", function(uiScale)
				return math.abs(uiScale.Scale - 1.2) <= 1e-6
			end)
			assertSizeApprox(inner, HOST_WIDTH, HOST_HEIGHT, 0.5, "inner root")
			assertSizeApprox(content, 150, 60, 0.5, "nested content")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { 1 }, { 1.25 }, { 1.5 } })
	local _decorator_2 = DisplayName("After its UIScale applies, the root frame covers exactly the host's screen area")
	local _descriptor = Test(UiScaleRootMountValidation, "fillsHost", {
		value = UiScaleRootMountValidation.fillsHost,
	})
	if _descriptor then
		UiScaleRootMountValidation.fillsHost = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(UiScaleRootMountValidation, "fillsHost", {
		value = UiScaleRootMountValidation.fillsHost,
	})
	if _descriptor_1 then
		UiScaleRootMountValidation.fillsHost = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(UiScaleRootMountValidation, "fillsHost", {
		value = UiScaleRootMountValidation.fillsHost,
	})
	if _descriptor_2 then
		UiScaleRootMountValidation.fillsHost = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(UiScaleRootMountValidation, "fillsHost", {
		value = UiScaleRootMountValidation.fillsHost,
	})
	if _descriptor_3 then
		UiScaleRootMountValidation.fillsHost = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = Each({ { 1 }, { 1.25 }, { 1.5 } })
	local _decorator_5 = DisplayName("Mounted straight into a ScreenGui, the scaled root covers the whole ScreenGui")
	local _descriptor_4 = Test(UiScaleRootMountValidation, "fillsScreenGui", {
		value = UiScaleRootMountValidation.fillsScreenGui,
	})
	if _descriptor_4 then
		UiScaleRootMountValidation.fillsScreenGui = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(UiScaleRootMountValidation, "fillsScreenGui", {
		value = UiScaleRootMountValidation.fillsScreenGui,
	})
	if _descriptor_5 then
		UiScaleRootMountValidation.fillsScreenGui = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(UiScaleRootMountValidation, "fillsScreenGui", {
		value = UiScaleRootMountValidation.fillsScreenGui,
	})
	if _descriptor_6 then
		UiScaleRootMountValidation.fillsScreenGui = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(UiScaleRootMountValidation, "fillsScreenGui", {
		value = UiScaleRootMountValidation.fillsScreenGui,
	})
	if _descriptor_7 then
		UiScaleRootMountValidation.fillsScreenGui = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = Each({ { 1 }, { 1.25 }, { 1.5 } })
	local _decorator_8 = DisplayName("The root frame is sized to 1/scale of its parent and carries a UIScale named UiScale set to the scale")
	local _descriptor_8 = Test(UiScaleRootMountValidation, "uiScaleSet", {
		value = UiScaleRootMountValidation.uiScaleSet,
	})
	if _descriptor_8 then
		UiScaleRootMountValidation.uiScaleSet = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_8(UiScaleRootMountValidation, "uiScaleSet", {
		value = UiScaleRootMountValidation.uiScaleSet,
	})
	if _descriptor_9 then
		UiScaleRootMountValidation.uiScaleSet = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(UiScaleRootMountValidation, "uiScaleSet", {
		value = UiScaleRootMountValidation.uiScaleSet,
	})
	if _descriptor_10 then
		UiScaleRootMountValidation.uiScaleSet = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(UiScaleRootMountValidation, "uiScaleSet", {
		value = UiScaleRootMountValidation.uiScaleSet,
	})
	if _descriptor_11 then
		UiScaleRootMountValidation.uiScaleSet = _descriptor_11.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = Each({ { 1, 100, 40 }, { 1.25, 125, 50 }, { 1.5, 150, 60 } })
	local _decorator_11 = DisplayName("A child sized in design pixels renders at that size times the scale on screen")
	local _descriptor_12 = Test(UiScaleRootMountValidation, "childScaled", {
		value = UiScaleRootMountValidation.childScaled,
	})
	if _descriptor_12 then
		UiScaleRootMountValidation.childScaled = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_11(UiScaleRootMountValidation, "childScaled", {
		value = UiScaleRootMountValidation.childScaled,
	})
	if _descriptor_13 then
		UiScaleRootMountValidation.childScaled = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(UiScaleRootMountValidation, "childScaled", {
		value = UiScaleRootMountValidation.childScaled,
	})
	if _descriptor_14 then
		UiScaleRootMountValidation.childScaled = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(UiScaleRootMountValidation, "childScaled", {
		value = UiScaleRootMountValidation.childScaled,
	})
	if _descriptor_15 then
		UiScaleRootMountValidation.childScaled = _descriptor_15.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("The root frame is fully transparent, borderless, inactive and keeps the default Position and AnchorPoint")
	local _descriptor_16 = Test(UiScaleRootMountValidation, "transparent", {
		value = UiScaleRootMountValidation.transparent,
	})
	if _descriptor_16 then
		UiScaleRootMountValidation.transparent = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_13(UiScaleRootMountValidation, "transparent", {
		value = UiScaleRootMountValidation.transparent,
	})
	if _descriptor_17 then
		UiScaleRootMountValidation.transparent = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_12(UiScaleRootMountValidation, "transparent", {
		value = UiScaleRootMountValidation.transparent,
	})
	if _descriptor_18 then
		UiScaleRootMountValidation.transparent = _descriptor_18.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = Each({ { 5, 5 }, { nil, 1 } })
	local _decorator_16 = DisplayName("A ZIndex prop is forwarded to the root frame, which otherwise keeps the engine default of 1")
	local _descriptor_19 = Test(UiScaleRootMountValidation, "zIndexForwarded", {
		value = UiScaleRootMountValidation.zIndexForwarded,
	})
	if _descriptor_19 then
		UiScaleRootMountValidation.zIndexForwarded = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_16(UiScaleRootMountValidation, "zIndexForwarded", {
		value = UiScaleRootMountValidation.zIndexForwarded,
	})
	if _descriptor_20 then
		UiScaleRootMountValidation.zIndexForwarded = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_15(UiScaleRootMountValidation, "zIndexForwarded", {
		value = UiScaleRootMountValidation.zIndexForwarded,
	})
	if _descriptor_21 then
		UiScaleRootMountValidation.zIndexForwarded = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(UiScaleRootMountValidation, "zIndexForwarded", {
		value = UiScaleRootMountValidation.zIndexForwarded,
	})
	if _descriptor_22 then
		UiScaleRootMountValidation.zIndexForwarded = _descriptor_22.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("At scale 1 the tree is one full-size frame holding only a UiScale of 1 and the children")
	local _descriptor_23 = Test(UiScaleRootMountValidation, "treeShapeAtOne", {
		value = UiScaleRootMountValidation.treeShapeAtOne,
	})
	if _descriptor_23 then
		UiScaleRootMountValidation.treeShapeAtOne = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_18(UiScaleRootMountValidation, "treeShapeAtOne", {
		value = UiScaleRootMountValidation.treeShapeAtOne,
	})
	if _descriptor_24 then
		UiScaleRootMountValidation.treeShapeAtOne = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(UiScaleRootMountValidation, "treeShapeAtOne", {
		value = UiScaleRootMountValidation.treeShapeAtOne,
	})
	if _descriptor_25 then
		UiScaleRootMountValidation.treeShapeAtOne = _descriptor_25.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = DisplayName("A name prop renames the root frame")
	local _descriptor_26 = Test(UiScaleRootMountValidation, "customName", {
		value = UiScaleRootMountValidation.customName,
	})
	if _descriptor_26 then
		UiScaleRootMountValidation.customName = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_20(UiScaleRootMountValidation, "customName", {
		value = UiScaleRootMountValidation.customName,
	})
	if _descriptor_27 then
		UiScaleRootMountValidation.customName = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_19(UiScaleRootMountValidation, "customName", {
		value = UiScaleRootMountValidation.customName,
	})
	if _descriptor_28 then
		UiScaleRootMountValidation.customName = _descriptor_28.value
	end
	local _decorator_21 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_22 = DisplayName("A ref passed to UiScaleRoot receives its root Frame")
	local _descriptor_29 = Test(UiScaleRootMountValidation, "forwardsRef", {
		value = UiScaleRootMountValidation.forwardsRef,
	})
	if _descriptor_29 then
		UiScaleRootMountValidation.forwardsRef = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_22(UiScaleRootMountValidation, "forwardsRef", {
		value = UiScaleRootMountValidation.forwardsRef,
	})
	if _descriptor_30 then
		UiScaleRootMountValidation.forwardsRef = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_21(UiScaleRootMountValidation, "forwardsRef", {
		value = UiScaleRootMountValidation.forwardsRef,
	})
	if _descriptor_31 then
		UiScaleRootMountValidation.forwardsRef = _descriptor_31.value
	end
	local _decorator_23 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_24 = DisplayName("Nested roots compose physically: 1.2 inside 1.25 still fills the host and renders content at 1.5x")
	local _descriptor_32 = Test(UiScaleRootMountValidation, "nestedComposes", {
		value = UiScaleRootMountValidation.nestedComposes,
	})
	if _descriptor_32 then
		UiScaleRootMountValidation.nestedComposes = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_24(UiScaleRootMountValidation, "nestedComposes", {
		value = UiScaleRootMountValidation.nestedComposes,
	})
	if _descriptor_33 then
		UiScaleRootMountValidation.nestedComposes = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_23(UiScaleRootMountValidation, "nestedComposes", {
		value = UiScaleRootMountValidation.nestedComposes,
	})
	if _descriptor_34 then
		UiScaleRootMountValidation.nestedComposes = _descriptor_34.value
	end
	UiScaleRootMountValidation = Tag("Studio")(UiScaleRootMountValidation) or UiScaleRootMountValidation
end
return UiScaleRootMountValidation
