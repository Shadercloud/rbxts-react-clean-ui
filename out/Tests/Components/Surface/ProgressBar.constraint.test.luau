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
local ProgressBar = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "ProgressBar").ProgressBar
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local waitForWidth = _layout.waitForWidth
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 100
local ProgressBarSizeConstraint
do
	ProgressBarSizeConstraint = setmetatable({}, {
		__tostring = function()
			return "ProgressBarSizeConstraint"
		end,
	})
	ProgressBarSizeConstraint.__index = ProgressBarSizeConstraint
	function ProgressBarSizeConstraint.new(...)
		local self = setmetatable({}, ProgressBarSizeConstraint)
		return self:constructor(...) or self
	end
	function ProgressBarSizeConstraint:constructor()
	end
	function ProgressBarSizeConstraint:noConstraintWhenUnset()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(ProgressBar, {
			value = 50,
			label = "Loading",
			striped = false,
		}), function(mounted)
			local header = waitForGuiObject(mounted.host, "ProgressBar")
			local track = waitForGuiObject(header, "ProgressBar")
			Assert:equal(#sizeConstraintsOf(header), 0)
			Assert:equal(#sizeConstraintsOf(track), 0)
		end)
	end
	function ProgressBarSizeConstraint:trackClamped()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(ProgressBar, {
			value = 50,
			maxWidth = 150,
			striped = false,
		}), function(mounted)
			local track = waitForGuiObject(mounted.host, "ProgressBar")
			Assert["true"](Assert, track:IsA("ImageLabel"), "Expected the unlabelled ProgressBar root to be the track")
			Assert:equal(soleSizeConstraint(track).MaxSize.X, 150)
			waitForWidth(track, 150)
		end)
	end
	function ProgressBarSizeConstraint:headerWrapperClamped()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(ProgressBar, {
			value = 50,
			label = "Loading",
			showValue = true,
			maxWidth = 200,
			striped = false,
		}), function(mounted)
			local header = waitForGuiObject(mounted.host, "ProgressBar")
			local track = waitForGuiObject(header, "ProgressBar")
			Assert["true"](Assert, header:IsA("Frame"), "Expected the labelled ProgressBar root to be the header wrapper")
			Assert:equal(soleSizeConstraint(header).MaxSize.X, 200)
			Assert:equal(soleSizeConstraint(track).MaxSize.X, 200)
			waitForWidth(header, 200)
			waitForWidth(track, 200)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without min or max props a labelled bar renders no UISizeConstraint on the wrapper or the track")
	local _descriptor = Test(ProgressBarSizeConstraint, "noConstraintWhenUnset", {
		value = ProgressBarSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor then
		ProgressBarSizeConstraint.noConstraintWhenUnset = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ProgressBarSizeConstraint, "noConstraintWhenUnset", {
		value = ProgressBarSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_1 then
		ProgressBarSizeConstraint.noConstraintWhenUnset = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ProgressBarSizeConstraint, "noConstraintWhenUnset", {
		value = ProgressBarSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_2 then
		ProgressBarSizeConstraint.noConstraintWhenUnset = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("An unlabelled bar puts the constraint on its track and clamps it")
	local _descriptor_3 = Test(ProgressBarSizeConstraint, "trackClamped", {
		value = ProgressBarSizeConstraint.trackClamped,
	})
	if _descriptor_3 then
		ProgressBarSizeConstraint.trackClamped = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ProgressBarSizeConstraint, "trackClamped", {
		value = ProgressBarSizeConstraint.trackClamped,
	})
	if _descriptor_4 then
		ProgressBarSizeConstraint.trackClamped = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ProgressBarSizeConstraint, "trackClamped", {
		value = ProgressBarSizeConstraint.trackClamped,
	})
	if _descriptor_5 then
		ProgressBarSizeConstraint.trackClamped = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A labelled bar clamps both the header wrapper and the track so the header row matches the track width")
	local _descriptor_6 = Test(ProgressBarSizeConstraint, "headerWrapperClamped", {
		value = ProgressBarSizeConstraint.headerWrapperClamped,
	})
	if _descriptor_6 then
		ProgressBarSizeConstraint.headerWrapperClamped = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ProgressBarSizeConstraint, "headerWrapperClamped", {
		value = ProgressBarSizeConstraint.headerWrapperClamped,
	})
	if _descriptor_7 then
		ProgressBarSizeConstraint.headerWrapperClamped = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ProgressBarSizeConstraint, "headerWrapperClamped", {
		value = ProgressBarSizeConstraint.headerWrapperClamped,
	})
	if _descriptor_8 then
		ProgressBarSizeConstraint.headerWrapperClamped = _descriptor_8.value
	end
	ProgressBarSizeConstraint = Tag("Studio")(ProgressBarSizeConstraint) or ProgressBarSizeConstraint
end
return ProgressBarSizeConstraint
