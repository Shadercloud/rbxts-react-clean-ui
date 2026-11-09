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
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Container").Container
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertSizeApprox = _layout.assertSizeApprox
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local waitForWidth = _layout.waitForWidth
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 300
local function content(width, height)
	if width == nil then
		width = 120
	end
	if height == nil then
		height = 50
	end
	return React.createElement("frame", {
		key = "Content",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(width, height),
	})
end
local ContainerSizeConstraint
do
	ContainerSizeConstraint = setmetatable({}, {
		__tostring = function()
			return "ContainerSizeConstraint"
		end,
	})
	ContainerSizeConstraint.__index = ContainerSizeConstraint
	function ContainerSizeConstraint.new(...)
		local self = setmetatable({}, ContainerSizeConstraint)
		return self:constructor(...) or self
	end
	function ContainerSizeConstraint:constructor()
	end
	function ContainerSizeConstraint:noConstraintWhenUnset()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			width = 100,
			height = 50,
		}), function(mounted)
			local container = waitForGuiObject(mounted.host, "Container")
			Assert:equal(#sizeConstraintsOf(container), 0)
		end)
	end
	function ContainerSizeConstraint:singleNamedConstraint()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			width = 100,
			height = 50,
			minWidth = "20px",
			maxWidth = 300,
			minHeight = "10",
			maxHeight = 200,
		}), function(mounted)
			local constraint = soleSizeConstraint(waitForGuiObject(mounted.host, "Container"))
			Assert:equal(constraint.MinSize, Vector2.new(20, 10))
			Assert:equal(constraint.MaxSize, Vector2.new(300, 200))
		end)
	end
	function ContainerSizeConstraint:centeredConstraintOnInner()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			center = true,
			minWidth = 200,
		}, content()), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "ContainerCenterWrapper")
			local container = waitForGuiObject(wrapper, "Container")
			Assert:equal(#sizeConstraintsOf(wrapper), 0)
			soleSizeConstraint(container)
			waitForWidth(container, 200)
			assertSizeApprox(wrapper, HOST_WIDTH, HOST_HEIGHT, 1, "centre wrapper still fills the host")
		end)
	end
	function ContainerSizeConstraint:percentWidthCapped()
		withMounted(200, HOST_HEIGHT, React.createElement(Container, {
			width = "100%",
			height = 40,
			maxWidth = 250,
		}), function(mounted)
			local container = waitForGuiObject(mounted.host, "Container")
			waitForWidth(container, 200)
			mounted.resize(HOST_WIDTH, HOST_HEIGHT)
			waitForWidth(container, 250)
			assertSizeApprox(container, 250, 40, 1, "capped container")
		end)
	end
	function ContainerSizeConstraint:minWidthRaises()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			width = 50,
			height = 40,
			minWidth = 150,
		}), function(mounted)
			local container = waitForGuiObject(mounted.host, "Container")
			waitForWidth(container, 150)
			assertSizeApprox(container, 150, 40, 1, "raised container")
		end)
	end
	function ContainerSizeConstraint:autoSizeRaised()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Container, {
			minWidth = 200,
			minHeight = "100px",
		}, content(120, 50)), function(mounted)
			local container = waitForGuiObject(mounted.host, "Container")
			waitForWidth(container, 200)
			assertSizeApprox(container, 200, 100, 1, "raised auto-size")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without min or max props the Container renders no UISizeConstraint at all")
	local _descriptor = Test(ContainerSizeConstraint, "noConstraintWhenUnset", {
		value = ContainerSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor then
		ContainerSizeConstraint.noConstraintWhenUnset = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ContainerSizeConstraint, "noConstraintWhenUnset", {
		value = ContainerSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_1 then
		ContainerSizeConstraint.noConstraintWhenUnset = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ContainerSizeConstraint, "noConstraintWhenUnset", {
		value = ContainerSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_2 then
		ContainerSizeConstraint.noConstraintWhenUnset = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Setting min and max props renders one SizeConstraint carrying the resolved pixel sizes")
	local _descriptor_3 = Test(ContainerSizeConstraint, "singleNamedConstraint", {
		value = ContainerSizeConstraint.singleNamedConstraint,
	})
	if _descriptor_3 then
		ContainerSizeConstraint.singleNamedConstraint = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ContainerSizeConstraint, "singleNamedConstraint", {
		value = ContainerSizeConstraint.singleNamedConstraint,
	})
	if _descriptor_4 then
		ContainerSizeConstraint.singleNamedConstraint = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ContainerSizeConstraint, "singleNamedConstraint", {
		value = ContainerSizeConstraint.singleNamedConstraint,
	})
	if _descriptor_5 then
		ContainerSizeConstraint.singleNamedConstraint = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A centred auto-sized Container puts the constraint on the inner Container and none on the centre wrapper")
	local _descriptor_6 = Test(ContainerSizeConstraint, "centeredConstraintOnInner", {
		value = ContainerSizeConstraint.centeredConstraintOnInner,
	})
	if _descriptor_6 then
		ContainerSizeConstraint.centeredConstraintOnInner = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ContainerSizeConstraint, "centeredConstraintOnInner", {
		value = ContainerSizeConstraint.centeredConstraintOnInner,
	})
	if _descriptor_7 then
		ContainerSizeConstraint.centeredConstraintOnInner = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ContainerSizeConstraint, "centeredConstraintOnInner", {
		value = ContainerSizeConstraint.centeredConstraintOnInner,
	})
	if _descriptor_8 then
		ContainerSizeConstraint.centeredConstraintOnInner = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("width 100% with a maxWidth fills a narrow host but stops at the maximum in a wide one")
	local _descriptor_9 = Test(ContainerSizeConstraint, "percentWidthCapped", {
		value = ContainerSizeConstraint.percentWidthCapped,
	})
	if _descriptor_9 then
		ContainerSizeConstraint.percentWidthCapped = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ContainerSizeConstraint, "percentWidthCapped", {
		value = ContainerSizeConstraint.percentWidthCapped,
	})
	if _descriptor_10 then
		ContainerSizeConstraint.percentWidthCapped = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ContainerSizeConstraint, "percentWidthCapped", {
		value = ContainerSizeConstraint.percentWidthCapped,
	})
	if _descriptor_11 then
		ContainerSizeConstraint.percentWidthCapped = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A minWidth larger than the explicit width raises the rendered width to the minimum")
	local _descriptor_12 = Test(ContainerSizeConstraint, "minWidthRaises", {
		value = ContainerSizeConstraint.minWidthRaises,
	})
	if _descriptor_12 then
		ContainerSizeConstraint.minWidthRaises = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(ContainerSizeConstraint, "minWidthRaises", {
		value = ContainerSizeConstraint.minWidthRaises,
	})
	if _descriptor_13 then
		ContainerSizeConstraint.minWidthRaises = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(ContainerSizeConstraint, "minWidthRaises", {
		value = ContainerSizeConstraint.minWidthRaises,
	})
	if _descriptor_14 then
		ContainerSizeConstraint.minWidthRaises = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A minWidth and minHeight raise an auto-sized Container above its content size")
	local _descriptor_15 = Test(ContainerSizeConstraint, "autoSizeRaised", {
		value = ContainerSizeConstraint.autoSizeRaised,
	})
	if _descriptor_15 then
		ContainerSizeConstraint.autoSizeRaised = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(ContainerSizeConstraint, "autoSizeRaised", {
		value = ContainerSizeConstraint.autoSizeRaised,
	})
	if _descriptor_16 then
		ContainerSizeConstraint.autoSizeRaised = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(ContainerSizeConstraint, "autoSizeRaised", {
		value = ContainerSizeConstraint.autoSizeRaised,
	})
	if _descriptor_17 then
		ContainerSizeConstraint.autoSizeRaised = _descriptor_17.value
	end
	ContainerSizeConstraint = Tag("Studio")(ContainerSizeConstraint) or ContainerSizeConstraint
end
return ContainerSizeConstraint
