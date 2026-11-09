-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "size.helper").SizeHelper
local STUDIO_SKIP_MESSAGE = TS.import(script, script.Parent, "layout").STUDIO_SKIP_MESSAGE
local _binding = Decorators
local Each = _binding.Each
local Skip = _binding.Skip
local function constraintOf(props)
	local constraint = SizeHelper:GetSizeConstraint(props)
	Assert:notUndefined(constraint, "Expected a size constraint when a min or max prop is set")
	return constraint
end
local SizeConstraintResolution
do
	SizeConstraintResolution = setmetatable({}, {
		__tostring = function()
			return "SizeConstraintResolution"
		end,
	})
	SizeConstraintResolution.__index = SizeConstraintResolution
	function SizeConstraintResolution.new(...)
		local self = setmetatable({}, SizeConstraintResolution)
		return self:constructor(...) or self
	end
	function SizeConstraintResolution:constructor()
	end
	function SizeConstraintResolution:unsetIsUndefined()
		Assert:undefined(SizeHelper:GetSizeConstraint({}))
		Assert:undefined(SizeHelper:GetSizeConstraint({
			width = 100,
			height = "50%",
		}))
	end
	function SizeConstraintResolution:unsetDefaults()
		local constraint = constraintOf({
			maxWidth = 200,
		})
		Assert:equal(constraint.MinSize, Vector2.new(0, 0))
		Assert:equal(constraint.MaxSize.X, 200)
		Assert:equal(constraint.MaxSize.Y, math.huge)
	end
	function SizeConstraintResolution:minOnlyUnbounded()
		local constraint = constraintOf({
			minHeight = 10,
		})
		Assert:equal(constraint.MinSize, Vector2.new(0, 10))
		Assert:equal(constraint.MaxSize.X, math.huge)
		Assert:equal(constraint.MaxSize.Y, math.huge)
	end
	function SizeConstraintResolution:allFourMapped()
		local constraint = constraintOf({
			minWidth = 10,
			maxWidth = 300,
			minHeight = 20,
			maxHeight = 400,
		})
		Assert:equal(constraint.MinSize, Vector2.new(10, 20))
		Assert:equal(constraint.MaxSize, Vector2.new(300, 400))
	end
	function SizeConstraintResolution:negativeMinZero()
		local constraint = constraintOf({
			minWidth = -5,
			minHeight = "-12px",
		})
		Assert:equal(constraint.MinSize, Vector2.new(0, 0))
	end
	function SizeConstraintResolution:maxRaisedToMin()
		local constraint = constraintOf({
			minWidth = 100,
			maxWidth = 50,
			minHeight = 40,
			maxHeight = 10,
		})
		Assert:equal(constraint.MinSize, Vector2.new(100, 40))
		Assert:equal(constraint.MaxSize, Vector2.new(100, 40))
	end
	function SizeConstraintResolution:negativeMaxZero()
		local constraint = constraintOf({
			maxWidth = -10,
		})
		Assert:equal(constraint.MaxSize.X, 0)
	end
	function SizeConstraintResolution:pixelParsing(value)
		local constraint = constraintOf({
			minWidth = value,
			maxWidth = value,
			minHeight = value,
			maxHeight = value,
		})
		Assert:equal(constraint.MinSize, Vector2.new(25, 25))
		Assert:equal(constraint.MaxSize, Vector2.new(25, 25))
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With no min or max prop the helper returns undefined so no UISizeConstraint is rendered")
	local _descriptor = Test(SizeConstraintResolution, "unsetIsUndefined", {
		value = SizeConstraintResolution.unsetIsUndefined,
	})
	if _descriptor then
		SizeConstraintResolution.unsetIsUndefined = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(SizeConstraintResolution, "unsetIsUndefined", {
		value = SizeConstraintResolution.unsetIsUndefined,
	})
	if _descriptor_1 then
		SizeConstraintResolution.unsetIsUndefined = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(SizeConstraintResolution, "unsetIsUndefined", {
		value = SizeConstraintResolution.unsetIsUndefined,
	})
	if _descriptor_2 then
		SizeConstraintResolution.unsetIsUndefined = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Only a maxWidth leaves both minimums at 0 and the other maximum unbounded")
	local _descriptor_3 = Test(SizeConstraintResolution, "unsetDefaults", {
		value = SizeConstraintResolution.unsetDefaults,
	})
	if _descriptor_3 then
		SizeConstraintResolution.unsetDefaults = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(SizeConstraintResolution, "unsetDefaults", {
		value = SizeConstraintResolution.unsetDefaults,
	})
	if _descriptor_4 then
		SizeConstraintResolution.unsetDefaults = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(SizeConstraintResolution, "unsetDefaults", {
		value = SizeConstraintResolution.unsetDefaults,
	})
	if _descriptor_5 then
		SizeConstraintResolution.unsetDefaults = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Only a minHeight leaves both maximums unbounded")
	local _descriptor_6 = Test(SizeConstraintResolution, "minOnlyUnbounded", {
		value = SizeConstraintResolution.minOnlyUnbounded,
	})
	if _descriptor_6 then
		SizeConstraintResolution.minOnlyUnbounded = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(SizeConstraintResolution, "minOnlyUnbounded", {
		value = SizeConstraintResolution.minOnlyUnbounded,
	})
	if _descriptor_7 then
		SizeConstraintResolution.minOnlyUnbounded = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(SizeConstraintResolution, "minOnlyUnbounded", {
		value = SizeConstraintResolution.minOnlyUnbounded,
	})
	if _descriptor_8 then
		SizeConstraintResolution.minOnlyUnbounded = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("All four props map straight onto MinSize and MaxSize")
	local _descriptor_9 = Test(SizeConstraintResolution, "allFourMapped", {
		value = SizeConstraintResolution.allFourMapped,
	})
	if _descriptor_9 then
		SizeConstraintResolution.allFourMapped = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(SizeConstraintResolution, "allFourMapped", {
		value = SizeConstraintResolution.allFourMapped,
	})
	if _descriptor_10 then
		SizeConstraintResolution.allFourMapped = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(SizeConstraintResolution, "allFourMapped", {
		value = SizeConstraintResolution.allFourMapped,
	})
	if _descriptor_11 then
		SizeConstraintResolution.allFourMapped = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A negative minimum is clamped to 0 on both axes")
	local _descriptor_12 = Test(SizeConstraintResolution, "negativeMinZero", {
		value = SizeConstraintResolution.negativeMinZero,
	})
	if _descriptor_12 then
		SizeConstraintResolution.negativeMinZero = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(SizeConstraintResolution, "negativeMinZero", {
		value = SizeConstraintResolution.negativeMinZero,
	})
	if _descriptor_13 then
		SizeConstraintResolution.negativeMinZero = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(SizeConstraintResolution, "negativeMinZero", {
		value = SizeConstraintResolution.negativeMinZero,
	})
	if _descriptor_14 then
		SizeConstraintResolution.negativeMinZero = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A maximum below its minimum is raised to the minimum on each axis")
	local _descriptor_15 = Test(SizeConstraintResolution, "maxRaisedToMin", {
		value = SizeConstraintResolution.maxRaisedToMin,
	})
	if _descriptor_15 then
		SizeConstraintResolution.maxRaisedToMin = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(SizeConstraintResolution, "maxRaisedToMin", {
		value = SizeConstraintResolution.maxRaisedToMin,
	})
	if _descriptor_16 then
		SizeConstraintResolution.maxRaisedToMin = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(SizeConstraintResolution, "maxRaisedToMin", {
		value = SizeConstraintResolution.maxRaisedToMin,
	})
	if _descriptor_17 then
		SizeConstraintResolution.maxRaisedToMin = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("A negative maximum with no minimum is raised to the 0 minimum")
	local _descriptor_18 = Test(SizeConstraintResolution, "negativeMaxZero", {
		value = SizeConstraintResolution.negativeMaxZero,
	})
	if _descriptor_18 then
		SizeConstraintResolution.negativeMaxZero = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(SizeConstraintResolution, "negativeMaxZero", {
		value = SizeConstraintResolution.negativeMaxZero,
	})
	if _descriptor_19 then
		SizeConstraintResolution.negativeMaxZero = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(SizeConstraintResolution, "negativeMaxZero", {
		value = SizeConstraintResolution.negativeMaxZero,
	})
	if _descriptor_20 then
		SizeConstraintResolution.negativeMaxZero = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = Each({ { 25 }, { "25" }, { "25px" }, { " 25 px " } })
	local _decorator_16 = DisplayName("Numbers, bare numeric strings and px strings all resolve to the same pixel value")
	local _descriptor_21 = Test(SizeConstraintResolution, "pixelParsing", {
		value = SizeConstraintResolution.pixelParsing,
	})
	if _descriptor_21 then
		SizeConstraintResolution.pixelParsing = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_16(SizeConstraintResolution, "pixelParsing", {
		value = SizeConstraintResolution.pixelParsing,
	})
	if _descriptor_22 then
		SizeConstraintResolution.pixelParsing = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_15(SizeConstraintResolution, "pixelParsing", {
		value = SizeConstraintResolution.pixelParsing,
	})
	if _descriptor_23 then
		SizeConstraintResolution.pixelParsing = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_14(SizeConstraintResolution, "pixelParsing", {
		value = SizeConstraintResolution.pixelParsing,
	})
	if _descriptor_24 then
		SizeConstraintResolution.pixelParsing = _descriptor_24.value
	end
	SizeConstraintResolution = Tag("Studio")(SizeConstraintResolution) or SizeConstraintResolution
end
return SizeConstraintResolution
