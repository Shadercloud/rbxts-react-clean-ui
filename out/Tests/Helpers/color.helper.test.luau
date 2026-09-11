-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local ColorHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "color.helper").ColorHelper
local RED = Color3.fromRGB(255, 0, 0)
local GREEN = Color3.fromRGB(0, 255, 0)
local BLUE = Color3.fromRGB(0, 0, 255)
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local function themeWith(primaryDefault)
	if primaryDefault == nil then
		primaryDefault = {}
	end
	local base = {
		textColor = BLACK,
		backgroundColor = WHITE,
		borderColor = BLACK,
	}
	local _object = {}
	local _left = "colors"
	local _object_1 = {}
	local _left_1 = "intents"
	local _object_2 = {}
	local _left_2 = "primary"
	local _object_3 = {}
	local _left_3 = "default"
	local _object_4 = table.clone(base)
	setmetatable(_object_4, nil)
	for _k, _v in primaryDefault do
		_object_4[_k] = _v
	end
	_object_3[_left_3] = _object_4
	_object_2[_left_2] = _object_3
	_object_2.danger = {
		default = base,
	}
	_object_1[_left_1] = _object_2
	_object[_left] = _object_1
	return _object
end
local function gradientOf(scheme)
	Assert:notUndefined(scheme.backgroundGradient, "Expected the merged scheme to carry a backgroundGradient")
	return scheme.backgroundGradient
end
local function assertColors(actual, expected, label)
	Assert:notUndefined(actual, `{label}: expected merged colours`)
	local colors = actual
	Assert:equal(#colors, #expected, `{label}: expected {#expected} colours, got {#colors}`)
	for index = 0, #expected - 1 do
		Assert:equal(colors[index + 1], expected[index + 1], `{label}: colour {index} mismatch`)
	end
end
local IntentGradientMerge
do
	IntentGradientMerge = setmetatable({}, {
		__tostring = function()
			return "IntentGradientMerge"
		end,
	})
	IntentGradientMerge.__index = IntentGradientMerge
	function IntentGradientMerge.new(...)
		local self = setmetatable({}, IntentGradientMerge)
		return self:constructor(...) or self
	end
	function IntentGradientMerge:constructor()
	end
	function IntentGradientMerge:hoverKeepsColors()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, BLUE },
						rotation = 90,
					},
				},
				hover = {
					backgroundGradient = {
						rotation = 45,
					},
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { RED, BLUE }, "hover merge")
		Assert:equal(gradient.rotation, 45)
	end
	function IntentGradientMerge:defaultStateRotation()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "default", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, BLUE },
						rotation = 90,
					},
				},
				hover = {
					backgroundGradient = {
						rotation = 45,
					},
				},
			},
		})
		Assert:equal(gradientOf(scheme).rotation, 90)
	end
	function IntentGradientMerge:noGradientLayer()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundColor = GREEN,
				},
				hover = {
					backgroundColor = BLUE,
				},
			},
		})
		Assert:undefined(scheme.backgroundGradient)
		Assert:equal(scheme.backgroundColor, BLUE)
	end
	function IntentGradientMerge:colorsReplaced()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, GREEN, BLUE },
					},
				},
				hover = {
					backgroundGradient = {
						colors = { WHITE, BLACK },
					},
				},
			},
		})
		assertColors(gradientOf(scheme).colors, { WHITE, BLACK }, "replaced colours")
	end
	function IntentGradientMerge:colorsResetStops()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, GREEN, BLUE },
						stops = { 0, 0.2, 1 },
					},
				},
				hover = {
					backgroundGradient = {
						colors = { WHITE, BLACK, GREEN },
					},
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { WHITE, BLACK, GREEN }, "hover colours")
		Assert:undefined(gradient.stops)
	end
	function IntentGradientMerge:ownStopsKept()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, GREEN, BLUE },
						stops = { 0, 0.2, 1 },
					},
				},
				hover = {
					backgroundGradient = {
						colors = { WHITE, BLACK, GREEN },
						stops = { 0, 0.7, 1 },
					},
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { WHITE, BLACK, GREEN }, "hover colours")
		Assert:deepEqual(gradient.stops, { 0, 0.7, 1 })
	end
	function IntentGradientMerge:stopsRepositionColors()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, GREEN, BLUE },
						stops = { 0, 0.2, 1 },
					},
				},
				hover = {
					backgroundGradient = {
						stops = { 0, 0.8, 1 },
					},
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { RED, GREEN, BLUE }, "inherited colours")
		Assert:deepEqual(gradient.stops, { 0, 0.8, 1 })
	end
	function IntentGradientMerge:colorsKeepRotation()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, BLUE },
						rotation = 90,
					},
				},
				hover = {
					backgroundGradient = {
						colors = { WHITE, BLACK },
					},
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { WHITE, BLACK }, "hover colours")
		Assert:equal(gradient.rotation, 90)
	end
	function IntentGradientMerge:undefinedStopsIgnored()
		local scheme = ColorHelper:getIntentColors(themeWith(), "primary", "hover", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, GREEN, BLUE },
						stops = { 0, 0.2, 1 },
					},
				},
				hover = {
					backgroundGradient = {
						rotation = 45,
						stops = nil,
					},
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { RED, GREEN, BLUE }, "inherited colours")
		Assert:deepEqual(gradient.stops, { 0, 0.2, 1 })
		Assert:equal(gradient.rotation, 45)
	end
	function IntentGradientMerge:overrideRefinesTheme()
		local theme = themeWith({
			backgroundGradient = {
				colors = { RED, BLUE },
				rotation = 90,
			},
		})
		local scheme = ColorHelper:getIntentColors(theme, "primary", "default", nil, {
			primary = {
				backgroundGradient = {
					rotation = 45,
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { RED, BLUE }, "theme colours")
		Assert:equal(gradient.rotation, 45)
		Assert:equal(theme.colors.intents.primary.default.backgroundGradient.rotation, 90)
	end
	function IntentGradientMerge:matchingIntentRefines()
		local scheme = ColorHelper:getIntentColors(themeWith(), "danger", "focus", {
			primary = {
				default = {
					backgroundGradient = {
						colors = { RED, BLUE },
						offset = Vector2.new(0.5, 0),
					},
				},
			},
			danger = {
				focus = {
					backgroundGradient = {
						rotation = 180,
					},
				},
			},
		})
		local gradient = gradientOf(scheme)
		assertColors(gradient.colors, { RED, BLUE }, "primary colours")
		Assert:equal(gradient.offset, Vector2.new(0.5, 0))
		Assert:equal(gradient.rotation, 180)
	end
	local _decorator = DisplayName("A hover layer that sets only rotation keeps the default layer's colours and overrides its rotation")
	local _descriptor = Test(IntentGradientMerge, "hoverKeepsColors", {
		value = IntentGradientMerge.hoverKeepsColors,
	})
	if _descriptor then
		IntentGradientMerge.hoverKeepsColors = _descriptor.value
	end
	local _descriptor_1 = _decorator(IntentGradientMerge, "hoverKeepsColors", {
		value = IntentGradientMerge.hoverKeepsColors,
	})
	if _descriptor_1 then
		IntentGradientMerge.hoverKeepsColors = _descriptor_1.value
	end
	local _decorator_1 = DisplayName("The default state ignores the hover layer and keeps the default rotation")
	local _descriptor_2 = Test(IntentGradientMerge, "defaultStateRotation", {
		value = IntentGradientMerge.defaultStateRotation,
	})
	if _descriptor_2 then
		IntentGradientMerge.defaultStateRotation = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(IntentGradientMerge, "defaultStateRotation", {
		value = IntentGradientMerge.defaultStateRotation,
	})
	if _descriptor_3 then
		IntentGradientMerge.defaultStateRotation = _descriptor_3.value
	end
	local _decorator_2 = DisplayName("When no theme or component layer sets a gradient the merged backgroundGradient is undefined")
	local _descriptor_4 = Test(IntentGradientMerge, "noGradientLayer", {
		value = IntentGradientMerge.noGradientLayer,
	})
	if _descriptor_4 then
		IntentGradientMerge.noGradientLayer = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(IntentGradientMerge, "noGradientLayer", {
		value = IntentGradientMerge.noGradientLayer,
	})
	if _descriptor_5 then
		IntentGradientMerge.noGradientLayer = _descriptor_5.value
	end
	local _decorator_3 = DisplayName("A later layer's colours replace the earlier array outright instead of merging index by index")
	local _descriptor_6 = Test(IntentGradientMerge, "colorsReplaced", {
		value = IntentGradientMerge.colorsReplaced,
	})
	if _descriptor_6 then
		IntentGradientMerge.colorsReplaced = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(IntentGradientMerge, "colorsReplaced", {
		value = IntentGradientMerge.colorsReplaced,
	})
	if _descriptor_7 then
		IntentGradientMerge.colorsReplaced = _descriptor_7.value
	end
	local _decorator_4 = DisplayName("A later layer that sets colours but no stops drops the earlier stops so its colours space evenly")
	local _descriptor_8 = Test(IntentGradientMerge, "colorsResetStops", {
		value = IntentGradientMerge.colorsResetStops,
	})
	if _descriptor_8 then
		IntentGradientMerge.colorsResetStops = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(IntentGradientMerge, "colorsResetStops", {
		value = IntentGradientMerge.colorsResetStops,
	})
	if _descriptor_9 then
		IntentGradientMerge.colorsResetStops = _descriptor_9.value
	end
	local _decorator_5 = DisplayName("A later layer that sets both colours and stops keeps its own stops over the earlier ones")
	local _descriptor_10 = Test(IntentGradientMerge, "ownStopsKept", {
		value = IntentGradientMerge.ownStopsKept,
	})
	if _descriptor_10 then
		IntentGradientMerge.ownStopsKept = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_5(IntentGradientMerge, "ownStopsKept", {
		value = IntentGradientMerge.ownStopsKept,
	})
	if _descriptor_11 then
		IntentGradientMerge.ownStopsKept = _descriptor_11.value
	end
	local _decorator_6 = DisplayName("A later layer that sets only stops repositions the inherited colours")
	local _descriptor_12 = Test(IntentGradientMerge, "stopsRepositionColors", {
		value = IntentGradientMerge.stopsRepositionColors,
	})
	if _descriptor_12 then
		IntentGradientMerge.stopsRepositionColors = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_6(IntentGradientMerge, "stopsRepositionColors", {
		value = IntentGradientMerge.stopsRepositionColors,
	})
	if _descriptor_13 then
		IntentGradientMerge.stopsRepositionColors = _descriptor_13.value
	end
	local _decorator_7 = DisplayName("A later layer that sets only colours still inherits the earlier layer's rotation")
	local _descriptor_14 = Test(IntentGradientMerge, "colorsKeepRotation", {
		value = IntentGradientMerge.colorsKeepRotation,
	})
	if _descriptor_14 then
		IntentGradientMerge.colorsKeepRotation = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_7(IntentGradientMerge, "colorsKeepRotation", {
		value = IntentGradientMerge.colorsKeepRotation,
	})
	if _descriptor_15 then
		IntentGradientMerge.colorsKeepRotation = _descriptor_15.value
	end
	local _decorator_8 = DisplayName("An explicit undefined stops on a colourless layer counts as unset and keeps the inherited stops")
	local _descriptor_16 = Test(IntentGradientMerge, "undefinedStopsIgnored", {
		value = IntentGradientMerge.undefinedStopsIgnored,
	})
	if _descriptor_16 then
		IntentGradientMerge.undefinedStopsIgnored = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_8(IntentGradientMerge, "undefinedStopsIgnored", {
		value = IntentGradientMerge.undefinedStopsIgnored,
	})
	if _descriptor_17 then
		IntentGradientMerge.undefinedStopsIgnored = _descriptor_17.value
	end
	local _decorator_9 = DisplayName("A flat override setting only rotation refines the theme gradient and leaves the theme's own value untouched")
	local _descriptor_18 = Test(IntentGradientMerge, "overrideRefinesTheme", {
		value = IntentGradientMerge.overrideRefinesTheme,
	})
	if _descriptor_18 then
		IntentGradientMerge.overrideRefinesTheme = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_9(IntentGradientMerge, "overrideRefinesTheme", {
		value = IntentGradientMerge.overrideRefinesTheme,
	})
	if _descriptor_19 then
		IntentGradientMerge.overrideRefinesTheme = _descriptor_19.value
	end
	local _decorator_10 = DisplayName("A matching-intent state layer refines the gradient supplied by the primary intent's default layer")
	local _descriptor_20 = Test(IntentGradientMerge, "matchingIntentRefines", {
		value = IntentGradientMerge.matchingIntentRefines,
	})
	if _descriptor_20 then
		IntentGradientMerge.matchingIntentRefines = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_10(IntentGradientMerge, "matchingIntentRefines", {
		value = IntentGradientMerge.matchingIntentRefines,
	})
	if _descriptor_21 then
		IntentGradientMerge.matchingIntentRefines = _descriptor_21.value
	end
	IntentGradientMerge = Tag("Studio")(IntentGradientMerge) or IntentGradientMerge
end
return IntentGradientMerge
