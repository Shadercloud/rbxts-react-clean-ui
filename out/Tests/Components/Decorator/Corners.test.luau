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
local Corners = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Decorator", "Corners").Corners
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local function targetWith(decorator)
	return React.createElement("frame", {
		key = "Target",
		Size = UDim2.fromOffset(200, 100),
		BackgroundTransparency = 0,
	}, decorator)
end
local CornersMountValidation
do
	CornersMountValidation = setmetatable({}, {
		__tostring = function()
			return "CornersMountValidation"
		end,
	})
	CornersMountValidation.__index = CornersMountValidation
	function CornersMountValidation.new(...)
		local self = setmetatable({}, CornersMountValidation)
		return self:constructor(...) or self
	end
	function CornersMountValidation:constructor()
	end
	function CornersMountValidation:numericRadius()
		withMounted(300, 200, targetWith(React.createElement(Corners, {
			radius = 8,
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local corner = findDescendant(target, "Corners")
			Assert:equal(corner.ClassName, "UICorner")
			Assert:equal(corner.Parent, target, "Expected the UICorner to be a direct child of the decorated frame")
			Assert:equal(corner.CornerRadius, UDim.new(0, 8))
		end)
	end
	function CornersMountValidation:percentRadiusAndName()
		withMounted(300, 200, targetWith(React.createElement(Corners, {
			radius = "50%",
			name = "RoundCorners",
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local corner = findDescendant(target, "RoundCorners")
			Assert:equal(corner.CornerRadius, UDim.new(0.5, 0))
			Assert:undefined(target:FindFirstChild("Corners"), "Expected the default Corners name not to be used when name is set")
		end)
	end
	function CornersMountValidation:zeroRadiusEmitsNothing(radius)
		withMounted(300, 200, targetWith(React.createElement(Corners, {
			radius = radius,
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			Assert:undefined(target:FindFirstChildWhichIsA("UICorner"), `Expected no UICorner for radius {radius}`)
		end)
	end
	function CornersMountValidation:noRadiusEmitsNothing()
		withMounted(300, 200, targetWith(React.createElement(Corners)), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			Assert:undefined(target:FindFirstChildWhichIsA("UICorner"), "Expected no UICorner when radius is omitted")
		end)
	end
	function CornersMountValidation:tokenFromTheme(token)
		withMounted(300, 200, targetWith(React.createElement(Corners, {
			radius = token,
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local corner = findDescendant(target, "Corners")
			Assert:equal(corner.CornerRadius, UDim.new(0, DefaultTheme.radius[token]), `radius="{token}"`)
		end)
	end
	function CornersMountValidation:tokenFollowsTheme()
		local theme = extendTheme(DefaultTheme, {
			radius = {
				lg = 20,
			},
		})
		withMounted(300, 200, React.createElement(ThemeProvider, {
			theme = theme,
		}, targetWith(React.createElement(Corners, {
			radius = "lg",
		}))), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local corner = findDescendant(target, "Corners")
			Assert:equal(corner.CornerRadius, UDim.new(0, 20))
		end)
	end
	function CornersMountValidation:zeroTokenEmitsNothing()
		local theme = extendTheme(DefaultTheme, {
			radius = {
				sm = 0,
			},
		})
		withMounted(300, 200, React.createElement(ThemeProvider, {
			theme = theme,
		}, targetWith(React.createElement(Corners, {
			radius = "sm",
		}))), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			Assert:undefined(target:FindFirstChildWhichIsA("UICorner"), "Expected no UICorner for a zero-valued token")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A numeric radius emits a UICorner named Corners under the parent with an offset-only CornerRadius")
	local _descriptor = Test(CornersMountValidation, "numericRadius", {
		value = CornersMountValidation.numericRadius,
	})
	if _descriptor then
		CornersMountValidation.numericRadius = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(CornersMountValidation, "numericRadius", {
		value = CornersMountValidation.numericRadius,
	})
	if _descriptor_1 then
		CornersMountValidation.numericRadius = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(CornersMountValidation, "numericRadius", {
		value = CornersMountValidation.numericRadius,
	})
	if _descriptor_2 then
		CornersMountValidation.numericRadius = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("A percent radius maps to a scale-only CornerRadius, and the name prop renames the UICorner")
	local _descriptor_3 = Test(CornersMountValidation, "percentRadiusAndName", {
		value = CornersMountValidation.percentRadiusAndName,
	})
	if _descriptor_3 then
		CornersMountValidation.percentRadiusAndName = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(CornersMountValidation, "percentRadiusAndName", {
		value = CornersMountValidation.percentRadiusAndName,
	})
	if _descriptor_4 then
		CornersMountValidation.percentRadiusAndName = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(CornersMountValidation, "percentRadiusAndName", {
		value = CornersMountValidation.percentRadiusAndName,
	})
	if _descriptor_5 then
		CornersMountValidation.percentRadiusAndName = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = Each({ { 0 }, { "0px" } })
	local _decorator_6 = DisplayName("A zero radius emits no UICorner at all")
	local _descriptor_6 = Test(CornersMountValidation, "zeroRadiusEmitsNothing", {
		value = CornersMountValidation.zeroRadiusEmitsNothing,
	})
	if _descriptor_6 then
		CornersMountValidation.zeroRadiusEmitsNothing = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_6(CornersMountValidation, "zeroRadiusEmitsNothing", {
		value = CornersMountValidation.zeroRadiusEmitsNothing,
	})
	if _descriptor_7 then
		CornersMountValidation.zeroRadiusEmitsNothing = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(CornersMountValidation, "zeroRadiusEmitsNothing", {
		value = CornersMountValidation.zeroRadiusEmitsNothing,
	})
	if _descriptor_8 then
		CornersMountValidation.zeroRadiusEmitsNothing = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(CornersMountValidation, "zeroRadiusEmitsNothing", {
		value = CornersMountValidation.zeroRadiusEmitsNothing,
	})
	if _descriptor_9 then
		CornersMountValidation.zeroRadiusEmitsNothing = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Omitting the radius prop emits no UICorner at all")
	local _descriptor_10 = Test(CornersMountValidation, "noRadiusEmitsNothing", {
		value = CornersMountValidation.noRadiusEmitsNothing,
	})
	if _descriptor_10 then
		CornersMountValidation.noRadiusEmitsNothing = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(CornersMountValidation, "noRadiusEmitsNothing", {
		value = CornersMountValidation.noRadiusEmitsNothing,
	})
	if _descriptor_11 then
		CornersMountValidation.noRadiusEmitsNothing = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(CornersMountValidation, "noRadiusEmitsNothing", {
		value = CornersMountValidation.noRadiusEmitsNothing,
	})
	if _descriptor_12 then
		CornersMountValidation.noRadiusEmitsNothing = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = Each({ { "sm" }, { "md" }, { "lg" } })
	local _decorator_11 = DisplayName("A radius token resolves to the matching pixel value from the active theme's radius scale")
	local _descriptor_13 = Test(CornersMountValidation, "tokenFromTheme", {
		value = CornersMountValidation.tokenFromTheme,
	})
	if _descriptor_13 then
		CornersMountValidation.tokenFromTheme = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_11(CornersMountValidation, "tokenFromTheme", {
		value = CornersMountValidation.tokenFromTheme,
	})
	if _descriptor_14 then
		CornersMountValidation.tokenFromTheme = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_10(CornersMountValidation, "tokenFromTheme", {
		value = CornersMountValidation.tokenFromTheme,
	})
	if _descriptor_15 then
		CornersMountValidation.tokenFromTheme = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_9(CornersMountValidation, "tokenFromTheme", {
		value = CornersMountValidation.tokenFromTheme,
	})
	if _descriptor_16 then
		CornersMountValidation.tokenFromTheme = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("A radius token follows a ThemeProvider override of the radius scale rather than the default theme")
	local _descriptor_17 = Test(CornersMountValidation, "tokenFollowsTheme", {
		value = CornersMountValidation.tokenFollowsTheme,
	})
	if _descriptor_17 then
		CornersMountValidation.tokenFollowsTheme = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_13(CornersMountValidation, "tokenFollowsTheme", {
		value = CornersMountValidation.tokenFollowsTheme,
	})
	if _descriptor_18 then
		CornersMountValidation.tokenFollowsTheme = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(CornersMountValidation, "tokenFollowsTheme", {
		value = CornersMountValidation.tokenFollowsTheme,
	})
	if _descriptor_19 then
		CornersMountValidation.tokenFollowsTheme = _descriptor_19.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("A token whose theme value is zero emits no UICorner")
	local _descriptor_20 = Test(CornersMountValidation, "zeroTokenEmitsNothing", {
		value = CornersMountValidation.zeroTokenEmitsNothing,
	})
	if _descriptor_20 then
		CornersMountValidation.zeroTokenEmitsNothing = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_15(CornersMountValidation, "zeroTokenEmitsNothing", {
		value = CornersMountValidation.zeroTokenEmitsNothing,
	})
	if _descriptor_21 then
		CornersMountValidation.zeroTokenEmitsNothing = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(CornersMountValidation, "zeroTokenEmitsNothing", {
		value = CornersMountValidation.zeroTokenEmitsNothing,
	})
	if _descriptor_22 then
		CornersMountValidation.zeroTokenEmitsNothing = _descriptor_22.value
	end
	CornersMountValidation = Tag("Studio")(CornersMountValidation) or CornersMountValidation
end
return CornersMountValidation
