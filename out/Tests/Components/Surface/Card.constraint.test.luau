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
local Card = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "Card").Card
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local waitForWidth = _layout.waitForWidth
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 300
local CardSizeConstraint
do
	CardSizeConstraint = setmetatable({}, {
		__tostring = function()
			return "CardSizeConstraint"
		end,
	})
	CardSizeConstraint.__index = CardSizeConstraint
	function CardSizeConstraint.new(...)
		local self = setmetatable({}, CardSizeConstraint)
		return self:constructor(...) or self
	end
	function CardSizeConstraint:constructor()
	end
	function CardSizeConstraint:noConstraintWhenUnset()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Card, {
			width = "100%",
		}, React.createElement(Card.Header, {
			overlay = true,
		}, React.createElement(Text, {
			text = "Header",
		})), React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Body",
		}))), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "CardOverlayWrapper")
			local box = waitForGuiObject(wrapper, "Card")
			Assert:equal(#sizeConstraintsOf(wrapper), 0)
			Assert:equal(#sizeConstraintsOf(box), 0)
		end)
	end
	function CardSizeConstraint:overlayWrapperClamped()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Card, {
			width = "100%",
			maxWidth = 200,
		}, React.createElement(Card.Header, {
			overlay = true,
		}, React.createElement(Text, {
			text = "Header",
		})), React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Body",
		}))), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "CardOverlayWrapper")
			local box = waitForGuiObject(wrapper, "Card")
			Assert:equal(soleSizeConstraint(wrapper).MaxSize.X, 200)
			Assert:equal(soleSizeConstraint(box).MaxSize.X, 200)
			waitForWidth(wrapper, 200)
			waitForWidth(box, 200)
		end)
	end
	function CardSizeConstraint:centerWrapperUnconstrained()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Card, {
			center = true,
			width = "100%",
			maxWidth = 180,
		}, React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Body",
		}))), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "CardCenterWrapper")
			local box = waitForGuiObject(wrapper, "Card")
			Assert:equal(#sizeConstraintsOf(wrapper), 0)
			soleSizeConstraint(box)
			waitForWidth(box, 180)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without min or max props neither the overlay wrapper nor the Card box gets a UISizeConstraint")
	local _descriptor = Test(CardSizeConstraint, "noConstraintWhenUnset", {
		value = CardSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor then
		CardSizeConstraint.noConstraintWhenUnset = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(CardSizeConstraint, "noConstraintWhenUnset", {
		value = CardSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_1 then
		CardSizeConstraint.noConstraintWhenUnset = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(CardSizeConstraint, "noConstraintWhenUnset", {
		value = CardSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_2 then
		CardSizeConstraint.noConstraintWhenUnset = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("With an overlay header the wrapper and the Card box both carry the constraint and clamp to the same width")
	local _descriptor_3 = Test(CardSizeConstraint, "overlayWrapperClamped", {
		value = CardSizeConstraint.overlayWrapperClamped,
	})
	if _descriptor_3 then
		CardSizeConstraint.overlayWrapperClamped = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(CardSizeConstraint, "overlayWrapperClamped", {
		value = CardSizeConstraint.overlayWrapperClamped,
	})
	if _descriptor_4 then
		CardSizeConstraint.overlayWrapperClamped = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(CardSizeConstraint, "overlayWrapperClamped", {
		value = CardSizeConstraint.overlayWrapperClamped,
	})
	if _descriptor_5 then
		CardSizeConstraint.overlayWrapperClamped = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A centred Card clamps its box while the full-size centre wrapper gets no constraint")
	local _descriptor_6 = Test(CardSizeConstraint, "centerWrapperUnconstrained", {
		value = CardSizeConstraint.centerWrapperUnconstrained,
	})
	if _descriptor_6 then
		CardSizeConstraint.centerWrapperUnconstrained = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(CardSizeConstraint, "centerWrapperUnconstrained", {
		value = CardSizeConstraint.centerWrapperUnconstrained,
	})
	if _descriptor_7 then
		CardSizeConstraint.centerWrapperUnconstrained = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(CardSizeConstraint, "centerWrapperUnconstrained", {
		value = CardSizeConstraint.centerWrapperUnconstrained,
	})
	if _descriptor_8 then
		CardSizeConstraint.centerWrapperUnconstrained = _descriptor_8.value
	end
	CardSizeConstraint = Tag("Studio")(CardSizeConstraint) or CardSizeConstraint
end
return CardSizeConstraint
