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
local Card = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "Card").Card
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedLeft = _layout.assertAlignedLeft
local assertAlignedTop = _layout.assertAlignedTop
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertCenteredIn = _layout.assertCenteredIn
local assertContained = _layout.assertContained
local assertMinSize = _layout.assertMinSize
local assertNoSiblingOverlap = _layout.assertNoSiblingOverlap
local assertNonZeroSize = _layout.assertNonZeroSize
local assertSizeApprox = _layout.assertSizeApprox
local assertStackedVertically = _layout.assertStackedVertically
local assertTextFits = _layout.assertTextFits
local findDescendant = _layout.findDescendant
local findDescendantOfClass = _layout.findDescendantOfClass
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local SHORT_TITLE = "Card title"
local LONG_TITLE = string.sub(string.rep("Averyverylongcardheadertitle ", 7), 1, 200)
local function cardWithSections(title)
	return React.createElement(Card, nil, React.createElement(Card.Header, nil, React.createElement(Text, {
		text = title,
	})), React.createElement(Card.Body, nil, React.createElement(Text, {
		text = "Body copy for the card under test.",
	})), React.createElement(Card.Footer, nil, React.createElement(Text, {
		text = "Footer",
	})))
end
local function waitForCard(host)
	return waitForGuiObject(host, "Card")
end
local function findSection(card, name)
	return findDescendant(card, name)
end
local function findHeaderText(card)
	return findDescendantOfClass(findSection(card, "CardHeader"), "TextLabel")
end
local CardMountValidation
do
	CardMountValidation = setmetatable({}, {
		__tostring = function()
			return "CardMountValidation"
		end,
	})
	CardMountValidation.__index = CardMountValidation
	function CardMountValidation.new(...)
		local self = setmetatable({}, CardMountValidation)
		return self:constructor(...) or self
	end
	function CardMountValidation:constructor()
	end
	function CardMountValidation:mountsWithSize()
		withMounted(400, 300, cardWithSections(SHORT_TITLE), function(mounted)
			local card = waitForCard(mounted.host)
			assertNonZeroSize(card, "mounted card")
		end)
	end
	function CardMountValidation:defaultPropsContained()
		withMounted(400, 300, React.createElement(Card, nil, React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Body copy for the card under test.",
		}))), function(mounted)
			local card = waitForCard(mounted.host)
			assertAllDescendantsContained(card, "default props")
		end)
	end
	function CardMountValidation:shortHeaderContained()
		withMounted(400, 300, cardWithSections(SHORT_TITLE), function(mounted)
			local card = waitForCard(mounted.host)
			assertAllDescendantsContained(card, "short header")
		end)
	end
	function CardMountValidation:longHeaderContained()
		withMounted(240, 600, cardWithSections(LONG_TITLE), function(mounted)
			local card = waitForCard(mounted.host)
			assertContained(card, mounted.host, "long header (card vs host)")
			assertAllDescendantsContained(card, "long header")
		end)
	end
	function CardMountValidation:longHeaderFixedWidth()
		withMounted(400, 600, React.createElement(Card, {
			width = 240,
		}, React.createElement(Card.Header, nil, React.createElement(Text, {
			text = LONG_TITLE,
		})), React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Body copy for the card under test.",
		}))), function(mounted)
			local card = waitForCard(mounted.host)
			assertSizeApprox(card, 240, nil, 1, "long header fixed width")
			assertAllDescendantsContained(card, "long header fixed width")
		end)
	end
	function CardMountValidation:headerTextFits(variant, title, hostWidth)
		withMounted(hostWidth, 600, cardWithSections(title), function(mounted)
			local card = waitForCard(mounted.host)
			local label = findHeaderText(card)
			assertTextFits(label, `{variant} header`)
		end)
	end
	function CardMountValidation:sectionsDoNotOverlap()
		withMounted(400, 300, cardWithSections(SHORT_TITLE), function(mounted)
			local card = waitForCard(mounted.host)
			local header = findSection(card, "CardHeader")
			local body = findSection(card, "CardBody")
			local footer = findSection(card, "CardFooter")
			Assert:equal(header.Parent, card, "Expected CardHeader to be a direct child of the Card's Box")
			Assert:equal(footer.Parent, card, "Expected CardFooter to be a direct child of the Card's Box")
			local _result = body.Parent
			if _result ~= nil then
				_result = _result.Parent
			end
			Assert:equal(_result, card, "Expected CardBody's FlexItem wrapper to be a direct child of the Card's Box")
			assertNoSiblingOverlap(card, "card sections")
			assertStackedVertically({ header, body, footer }, "card sections")
		end)
	end
	function CardMountValidation:centeredInHost()
		withMounted(400, 300, React.createElement(Card, {
			center = true,
			width = 200,
			height = 100,
		}, React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Centered",
		}))), function(mounted)
			local card = waitForCard(mounted.host)
			assertSizeApprox(card, 200, 100, 1, "centered card")
			assertCenteredIn(card, mounted.host, "both", 1, "centered card")
		end)
	end
	function CardMountValidation:leftAlignedByDefault()
		withMounted(400, 300, React.createElement(Card, {
			width = 200,
			height = 100,
		}, React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Top left",
		}))), function(mounted)
			local card = waitForCard(mounted.host)
			assertAlignedLeft(card, mounted.host, 1, "uncentered card")
			assertAlignedTop(card, mounted.host, 1, "uncentered card")
		end)
	end
	function CardMountValidation:respectsExplicitSize(width, height)
		withMounted(400, 300, React.createElement(Card, {
			width = width,
			height = height,
		}, React.createElement(Card.Body, nil, React.createElement(Text, {
			text = "Sized",
		}))), function(mounted)
			local card = waitForCard(mounted.host)
			assertSizeApprox(card, width, height, 1, "explicit size")
		end)
	end
	function CardMountValidation:growsWithContent()
		withMounted(400, 600, React.createElement(Card, {
			width = 300,
		}, React.createElement(Card.Body, nil, React.createElement("frame", {
			key = "TallContent",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(50, 400),
		}))), function(mounted)
			local card = waitForGuiObject(mounted.host, "Card", function(gui)
				return gui.AbsoluteSize.Y >= 400
			end, "Timed out waiting for the Card to grow to at least its 400px body content")
			assertSizeApprox(card, 300, nil, 1, "auto-height card")
			assertMinSize(card, nil, 400, "auto-height card")
			assertAllDescendantsContained(card, "auto-height card")
		end)
	end
	function CardMountValidation:resizeKeepsContained()
		withMounted(400, 600, cardWithSections(LONG_TITLE), function(mounted)
			local card = waitForCard(mounted.host)
			assertAllDescendantsContained(card, "before resize")
			mounted.resize(240, 600)
			assertContained(card, mounted.host, "after resize (card vs host)")
			assertAllDescendantsContained(card, "after resize")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Mounting a Card with default props renders its root Box with a non-zero AbsoluteSize")
	local _descriptor = Test(CardMountValidation, "mountsWithSize", {
		value = CardMountValidation.mountsWithSize,
	})
	if _descriptor then
		CardMountValidation.mountsWithSize = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(CardMountValidation, "mountsWithSize", {
		value = CardMountValidation.mountsWithSize,
	})
	if _descriptor_1 then
		CardMountValidation.mountsWithSize = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(CardMountValidation, "mountsWithSize", {
		value = CardMountValidation.mountsWithSize,
	})
	if _descriptor_2 then
		CardMountValidation.mountsWithSize = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("With only a body and default props, every visible descendant stays inside the Card")
	local _descriptor_3 = Test(CardMountValidation, "defaultPropsContained", {
		value = CardMountValidation.defaultPropsContained,
	})
	if _descriptor_3 then
		CardMountValidation.defaultPropsContained = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(CardMountValidation, "defaultPropsContained", {
		value = CardMountValidation.defaultPropsContained,
	})
	if _descriptor_4 then
		CardMountValidation.defaultPropsContained = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(CardMountValidation, "defaultPropsContained", {
		value = CardMountValidation.defaultPropsContained,
	})
	if _descriptor_5 then
		CardMountValidation.defaultPropsContained = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("With a short header, body and footer, every visible descendant stays inside the Card")
	local _descriptor_6 = Test(CardMountValidation, "shortHeaderContained", {
		value = CardMountValidation.shortHeaderContained,
	})
	if _descriptor_6 then
		CardMountValidation.shortHeaderContained = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(CardMountValidation, "shortHeaderContained", {
		value = CardMountValidation.shortHeaderContained,
	})
	if _descriptor_7 then
		CardMountValidation.shortHeaderContained = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(CardMountValidation, "shortHeaderContained", {
		value = CardMountValidation.shortHeaderContained,
	})
	if _descriptor_8 then
		CardMountValidation.shortHeaderContained = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("A 200-character header in a 240px host stays inside the Card, and the Card stays inside its host")
	local _descriptor_9 = Test(CardMountValidation, "longHeaderContained", {
		value = CardMountValidation.longHeaderContained,
	})
	if _descriptor_9 then
		CardMountValidation.longHeaderContained = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(CardMountValidation, "longHeaderContained", {
		value = CardMountValidation.longHeaderContained,
	})
	if _descriptor_10 then
		CardMountValidation.longHeaderContained = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(CardMountValidation, "longHeaderContained", {
		value = CardMountValidation.longHeaderContained,
	})
	if _descriptor_11 then
		CardMountValidation.longHeaderContained = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A 200-character header stays inside a Card whose width is pinned to 240px")
	local _descriptor_12 = Test(CardMountValidation, "longHeaderFixedWidth", {
		value = CardMountValidation.longHeaderFixedWidth,
	})
	if _descriptor_12 then
		CardMountValidation.longHeaderFixedWidth = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(CardMountValidation, "longHeaderFixedWidth", {
		value = CardMountValidation.longHeaderFixedWidth,
	})
	if _descriptor_13 then
		CardMountValidation.longHeaderFixedWidth = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(CardMountValidation, "longHeaderFixedWidth", {
		value = CardMountValidation.longHeaderFixedWidth,
	})
	if _descriptor_14 then
		CardMountValidation.longHeaderFixedWidth = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = Each({ { "short", SHORT_TITLE, 400 }, { "long", LONG_TITLE, 240 } })
	local _decorator_12 = DisplayName("The header's TextLabel reports its text as fitting for both short and long titles")
	local _descriptor_15 = Test(CardMountValidation, "headerTextFits", {
		value = CardMountValidation.headerTextFits,
	})
	if _descriptor_15 then
		CardMountValidation.headerTextFits = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_12(CardMountValidation, "headerTextFits", {
		value = CardMountValidation.headerTextFits,
	})
	if _descriptor_16 then
		CardMountValidation.headerTextFits = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_11(CardMountValidation, "headerTextFits", {
		value = CardMountValidation.headerTextFits,
	})
	if _descriptor_17 then
		CardMountValidation.headerTextFits = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_10(CardMountValidation, "headerTextFits", {
		value = CardMountValidation.headerTextFits,
	})
	if _descriptor_18 then
		CardMountValidation.headerTextFits = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("Header, body and footer are laid out as non-overlapping siblings inside the Card")
	local _descriptor_19 = Test(CardMountValidation, "sectionsDoNotOverlap", {
		value = CardMountValidation.sectionsDoNotOverlap,
	})
	if _descriptor_19 then
		CardMountValidation.sectionsDoNotOverlap = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_14(CardMountValidation, "sectionsDoNotOverlap", {
		value = CardMountValidation.sectionsDoNotOverlap,
	})
	if _descriptor_20 then
		CardMountValidation.sectionsDoNotOverlap = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_13(CardMountValidation, "sectionsDoNotOverlap", {
		value = CardMountValidation.sectionsDoNotOverlap,
	})
	if _descriptor_21 then
		CardMountValidation.sectionsDoNotOverlap = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("center={true} with a fixed width and height places the Card in the middle of the host")
	local _descriptor_22 = Test(CardMountValidation, "centeredInHost", {
		value = CardMountValidation.centeredInHost,
	})
	if _descriptor_22 then
		CardMountValidation.centeredInHost = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_16(CardMountValidation, "centeredInHost", {
		value = CardMountValidation.centeredInHost,
	})
	if _descriptor_23 then
		CardMountValidation.centeredInHost = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_15(CardMountValidation, "centeredInHost", {
		value = CardMountValidation.centeredInHost,
	})
	if _descriptor_24 then
		CardMountValidation.centeredInHost = _descriptor_24.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("Without center, a fixed-size Card sits flush with the host's top-left corner")
	local _descriptor_25 = Test(CardMountValidation, "leftAlignedByDefault", {
		value = CardMountValidation.leftAlignedByDefault,
	})
	if _descriptor_25 then
		CardMountValidation.leftAlignedByDefault = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_18(CardMountValidation, "leftAlignedByDefault", {
		value = CardMountValidation.leftAlignedByDefault,
	})
	if _descriptor_26 then
		CardMountValidation.leftAlignedByDefault = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_17(CardMountValidation, "leftAlignedByDefault", {
		value = CardMountValidation.leftAlignedByDefault,
	})
	if _descriptor_27 then
		CardMountValidation.leftAlignedByDefault = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = Each({ { 300, 150 }, { 120, 80 } })
	local _decorator_21 = DisplayName("Explicit width and height props pin the Card's AbsoluteSize to those pixel values")
	local _descriptor_28 = Test(CardMountValidation, "respectsExplicitSize", {
		value = CardMountValidation.respectsExplicitSize,
	})
	if _descriptor_28 then
		CardMountValidation.respectsExplicitSize = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_21(CardMountValidation, "respectsExplicitSize", {
		value = CardMountValidation.respectsExplicitSize,
	})
	if _descriptor_29 then
		CardMountValidation.respectsExplicitSize = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_20(CardMountValidation, "respectsExplicitSize", {
		value = CardMountValidation.respectsExplicitSize,
	})
	if _descriptor_30 then
		CardMountValidation.respectsExplicitSize = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_19(CardMountValidation, "respectsExplicitSize", {
		value = CardMountValidation.respectsExplicitSize,
	})
	if _descriptor_31 then
		CardMountValidation.respectsExplicitSize = _descriptor_31.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("With only a width set, the Card keeps that width and grows in height to fit tall body content")
	local _descriptor_32 = Test(CardMountValidation, "growsWithContent", {
		value = CardMountValidation.growsWithContent,
	})
	if _descriptor_32 then
		CardMountValidation.growsWithContent = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_23(CardMountValidation, "growsWithContent", {
		value = CardMountValidation.growsWithContent,
	})
	if _descriptor_33 then
		CardMountValidation.growsWithContent = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_22(CardMountValidation, "growsWithContent", {
		value = CardMountValidation.growsWithContent,
	})
	if _descriptor_34 then
		CardMountValidation.growsWithContent = _descriptor_34.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_25 = DisplayName("Narrowing the host from 400px to 240px keeps every descendant inside the Card")
	local _descriptor_35 = Test(CardMountValidation, "resizeKeepsContained", {
		value = CardMountValidation.resizeKeepsContained,
	})
	if _descriptor_35 then
		CardMountValidation.resizeKeepsContained = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_25(CardMountValidation, "resizeKeepsContained", {
		value = CardMountValidation.resizeKeepsContained,
	})
	if _descriptor_36 then
		CardMountValidation.resizeKeepsContained = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_24(CardMountValidation, "resizeKeepsContained", {
		value = CardMountValidation.resizeKeepsContained,
	})
	if _descriptor_37 then
		CardMountValidation.resizeKeepsContained = _descriptor_37.value
	end
	CardMountValidation = Tag("Studio")(CardMountValidation) or CardMountValidation
end
return CardMountValidation
