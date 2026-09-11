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
local Pie = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Chart", "Pie").Pie
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertContained = _layout.assertContained
local assertNonZeroSize = _layout.assertNonZeroSize
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local VALUES = { {
	value = 25,
	label = "Alpha",
}, {
	value = 25,
	label = "Beta",
}, {
	value = 50,
	label = "Gamma",
} }
local function getWedges(hitArea)
	local wedges = {}
	for _, child in hitArea:GetChildren() do
		if child:IsA("Frame") and child.Name == "SegmentWedge" then
			table.insert(wedges, child)
		end
	end
	return wedges
end
local function waitForHitArea(host)
	return waitForGuiObject(host, "HitArea")
end
local PieMountValidation
do
	PieMountValidation = setmetatable({}, {
		__tostring = function()
			return "PieMountValidation"
		end,
	})
	PieMountValidation.__index = PieMountValidation
	function PieMountValidation.new(...)
		local self = setmetatable({}, PieMountValidation)
		return self:constructor(...) or self
	end
	function PieMountValidation:constructor()
	end
	function PieMountValidation:slicePerDataPoint()
		withMounted(300, 300, React.createElement(Pie, {
			values = VALUES,
		}), function(mounted)
			local pie = waitForGuiObject(mounted.host, "Pie")
			assertNonZeroSize(pie, "mounted pie")
			local wedges = getWedges(waitForHitArea(pie))
			Assert:equal(#wedges, #VALUES, `Expected one SegmentWedge per value, got {#wedges} for {#VALUES} values`)
			for _, wedge in wedges do
				findDescendant(wedge, "SegmentFill")
			end
		end)
	end
	function PieMountValidation:slicesContained()
		withMounted(300, 300, React.createElement(Pie, {
			values = VALUES,
		}), function(mounted)
			local pie = waitForGuiObject(mounted.host, "Pie")
			local hitArea = waitForHitArea(pie)
			assertContained(hitArea, pie, "hit area")
			local wedges = getWedges(hitArea)
			for index = 0, #wedges - 1 do
				assertContained(wedges[index + 1], hitArea, `wedge {index}`)
			end
		end)
	end
	function PieMountValidation:labelPerValue()
		withMounted(300, 300, React.createElement(Pie, {
			values = VALUES,
		}), function(mounted)
			local pie = waitForGuiObject(mounted.host, "Pie")
			for index = 0, #VALUES - 1 do
				local label = waitForGuiObject(pie, `PieLabel-{index}`)
				local text = findDescendant(label, "PieLabelText")
				Assert:equal(text.Text, VALUES[index + 1].label, `Expected PieLabel-{index} to show "{VALUES[index + 1].label}"`)
				assertContained(label, pie, `pie label {index}`)
			end
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Mounts a Pie root with a non-zero size and exactly one SegmentWedge (with a SegmentFill) per value")
	local _descriptor = Test(PieMountValidation, "slicePerDataPoint", {
		value = PieMountValidation.slicePerDataPoint,
	})
	if _descriptor then
		PieMountValidation.slicePerDataPoint = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(PieMountValidation, "slicePerDataPoint", {
		value = PieMountValidation.slicePerDataPoint,
	})
	if _descriptor_1 then
		PieMountValidation.slicePerDataPoint = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(PieMountValidation, "slicePerDataPoint", {
		value = PieMountValidation.slicePerDataPoint,
	})
	if _descriptor_2 then
		PieMountValidation.slicePerDataPoint = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("The HitArea stays inside the Pie root and every SegmentWedge stays inside the HitArea")
	local _descriptor_3 = Test(PieMountValidation, "slicesContained", {
		value = PieMountValidation.slicesContained,
	})
	if _descriptor_3 then
		PieMountValidation.slicesContained = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(PieMountValidation, "slicesContained", {
		value = PieMountValidation.slicesContained,
	})
	if _descriptor_4 then
		PieMountValidation.slicesContained = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(PieMountValidation, "slicesContained", {
		value = PieMountValidation.slicesContained,
	})
	if _descriptor_5 then
		PieMountValidation.slicesContained = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("String labels render one PieLabel-N frame per value, each with text and inside the Pie root")
	local _descriptor_6 = Test(PieMountValidation, "labelPerValue", {
		value = PieMountValidation.labelPerValue,
	})
	if _descriptor_6 then
		PieMountValidation.labelPerValue = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(PieMountValidation, "labelPerValue", {
		value = PieMountValidation.labelPerValue,
	})
	if _descriptor_7 then
		PieMountValidation.labelPerValue = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(PieMountValidation, "labelPerValue", {
		value = PieMountValidation.labelPerValue,
	})
	if _descriptor_8 then
		PieMountValidation.labelPerValue = _descriptor_8.value
	end
	PieMountValidation = Tag("Studio")(PieMountValidation) or PieMountValidation
end
return PieMountValidation
