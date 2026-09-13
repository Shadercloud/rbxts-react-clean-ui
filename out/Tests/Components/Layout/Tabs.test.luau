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
local Tabs = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Tabs").Tabs
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertStackedHorizontally = _layout.assertStackedHorizontally
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local TAB_VALUES = { "one", "two", "three" }
local DEFAULT_TEXT = Color3.fromRGB(10, 120, 30)
local HOVER_TEXT = Color3.fromRGB(90, 90, 200)
local FOCUS_TEXT = Color3.fromRGB(220, 40, 40)
local DEFAULT_BORDER = Color3.fromRGB(51, 29, 7)
local FOCUS_BORDER = Color3.fromRGB(250, 200, 20)
local GRADIENT_TOP = Color3.fromRGB(186, 133, 74)
local GRADIENT_BOTTOM = Color3.fromRGB(122, 74, 32)
local function tabsFixture(props)
	if props == nil then
		props = {}
	end
	return React.createElement(Tabs, {
		defaultValue = props.defaultValue,
		value = props.value,
		onValueChange = props.onValueChange,
	}, React.createElement(Tabs.List, {
		fill = props.fill,
	}, React.createElement(Tabs.Title, {
		value = "one",
		text = "One",
	}), React.createElement(Tabs.Title, {
		value = "two",
		text = "Two",
	}), React.createElement(Tabs.Title, {
		value = "three",
		text = "Three",
	})), React.createElement(Tabs.Body, nil, React.createElement(Tabs.Content, {
		value = "one",
	}, React.createElement(Text, {
		text = "Panel one",
	})), React.createElement(Tabs.Content, {
		value = "two",
	}, React.createElement(Text, {
		text = "Panel two",
	})), React.createElement(Tabs.Content, {
		value = "three",
	}, React.createElement(Text, {
		text = "Panel three",
	}))))
end
local function themed(theme, props)
	if props == nil then
		props = {}
	end
	return React.createElement(ThemeProvider, {
		theme = theme,
	}, tabsFixture(props))
end
local function stateTheme(buttonBorderThickness)
	return extendTheme(DefaultTheme, {
		components = {
			tabs = {
				button = {
					borderThickness = buttonBorderThickness,
					intents = {
						primary = {
							default = {
								textColor = DEFAULT_TEXT,
								borderColor = DEFAULT_BORDER,
							},
							hover = {
								textColor = HOVER_TEXT,
							},
							focus = {
								textColor = FOCUS_TEXT,
								borderColor = FOCUS_BORDER,
								backgroundColor = Color3.fromRGB(255, 255, 255),
								backgroundGradient = {
									colors = { GRADIENT_TOP, GRADIENT_BOTTOM },
									rotation = 90,
								},
							},
						},
					},
				},
			},
		},
	})
end
local function waitForSelectedContent(host, value)
	return waitForGuiObject(host, `TabContent_{value}`, function(gui)
		return gui.Visible and gui.AbsoluteSize.X > 0
	end, `Timed out waiting for TabContent_{value} to become the visible panel`)
end
local function getVisiblePanels(host)
	local visible = {}
	for _, value in TAB_VALUES do
		local panel = host:FindFirstChild(`TabContent_{value}`, true)
		if panel ~= nil and panel.Visible then
			table.insert(visible, value)
		end
	end
	return visible
end
local function assertOnlySelectedVisible(host, selected)
	for _, value in TAB_VALUES do
		local panel = findDescendant(host, `TabContent_{value}`)
		Assert:equal(panel.Visible, value == selected, `Expected TabContent_{value} Visible to be {value == selected} while "{selected}" is selected`)
	end
end
local function waitForButton(host, value)
	return waitForGuiObject(host, `TabButton-{value}`)
end
local function findHostFiber(mounted, instance)
	local internalRoot = (mounted.root)._internalRoot
	local pending = { internalRoot.current }
	while #pending > 0 do
		-- ▼ Array.pop ▼
		local _length = #pending
		local _result = pending[_length]
		pending[_length] = nil
		-- ▲ Array.pop ▲
		local fiber = _result
		if fiber.stateNode == instance then
			return fiber
		end
		if fiber.child ~= nil then
			local _child = fiber.child
			table.insert(pending, _child)
		end
		if fiber.sibling ~= nil then
			local _sibling = fiber.sibling
			table.insert(pending, _sibling)
		end
	end
	return Assert:fail(`Expected a mounted host fiber for {instance:GetFullName()}`)
end
local function activateButton(mounted, button)
	local activatedKey = React.Event.Activated
	local _result = findHostFiber(mounted, button).memoizedProps
	if _result ~= nil then
		_result = _result[activatedKey]
	end
	local handler = _result
	Assert:notUndefined(handler, `Expected {button.Name} to have an Activated handler`)
	handler(button, {}, 1)
	task.wait()
end
local function settleFrames(count)
	do
		local frame = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				frame += 1
			else
				_shouldIncrement = true
			end
			if not (frame < count) then
				break
			end
			task.wait()
		end
	end
end
local function titleTextOf(button)
	return findDescendant(button, "TabTitleText")
end
local TabsMountValidation
do
	TabsMountValidation = setmetatable({}, {
		__tostring = function()
			return "TabsMountValidation"
		end,
	})
	TabsMountValidation.__index = TabsMountValidation
	function TabsMountValidation.new(...)
		local self = setmetatable({}, TabsMountValidation)
		return self:constructor(...) or self
	end
	function TabsMountValidation:constructor()
	end
	function TabsMountValidation:firstTabSelectedByDefault()
		withMounted(400, 300, tabsFixture(), function(mounted)
			local visible = waitForLayout(function()
				local panels = getVisiblePanels(mounted.host)
				return if #panels == 1 then panels else nil
			end, "Timed out waiting for exactly one TabContent panel to become visible")
			Assert:equal(visible[1], "one", `Expected the first declared tab "one" to be selected without a defaultValue, but "{visible[1]}" was visible`)
			assertOnlySelectedVisible(mounted.host, "one")
		end)
	end
	function TabsMountValidation:defaultValueSelectsTab()
		withMounted(400, 300, tabsFixture({
			defaultValue = "two",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "two")
			assertOnlySelectedVisible(mounted.host, "two")
		end)
	end
	function TabsMountValidation:titlesInOrder()
		withMounted(400, 300, tabsFixture({
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local list = findDescendant(mounted.host, "TabsList")
			local buttons = {}
			for _, value in TAB_VALUES do
				local button = waitForGuiObject(list, `TabButton-{value}`)
				Assert:equal(button.Parent, list, `Expected TabButton-{value} to be a direct child of TabsList`)
				table.insert(buttons, button)
			end
			assertStackedHorizontally(buttons, "tab buttons")
		end)
	end
	function TabsMountValidation:contentsContained()
		withMounted(400, 300, tabsFixture({
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local list = waitForGuiObject(mounted.host, "TabsList")
			local body = waitForGuiObject(mounted.host, "TabsBody")
			assertContained(list, mounted.host, "list vs host")
			assertContained(body, mounted.host, "body vs host")
			assertAllDescendantsContained(list, "tabs list")
			assertAllDescendantsContained(body, "tabs body")
		end)
	end
	function TabsMountValidation:controlledFollowsValue()
		withMounted(400, 300, tabsFixture({
			value = "two",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "two")
			assertOnlySelectedVisible(mounted.host, "two")
			mounted.update(tabsFixture({
				value = "three",
			}))
			waitForSelectedContent(mounted.host, "three")
			assertOnlySelectedVisible(mounted.host, "three")
		end)
	end
	function TabsMountValidation:controlledClickOnlyReports()
		local reported = {}
		local onValueChange = function(value)
			local _value = value
			table.insert(reported, _value)
		end
		withMounted(400, 300, tabsFixture({
			value = "one",
			onValueChange = onValueChange,
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			activateButton(mounted, waitForButton(mounted.host, "two"))
			waitForLayout(function()
				return if #reported > 0 then true else nil
			end, "Timed out waiting for onValueChange to fire after clicking TabButton-two")
			Assert:deepEqual(reported, { "two" })
			settleFrames(5)
			assertOnlySelectedVisible(mounted.host, "one")
			mounted.update(tabsFixture({
				value = "two",
				onValueChange = onValueChange,
			}))
			waitForSelectedContent(mounted.host, "two")
			assertOnlySelectedVisible(mounted.host, "two")
		end)
	end
	function TabsMountValidation:controlledUnknownValue()
		withMounted(400, 300, tabsFixture({
			value = "missing",
		}), function(mounted)
			waitForGuiObject(mounted.host, "TabButton-one")
			settleFrames(5)
			Assert:deepEqual(getVisiblePanels(mounted.host), {})
		end)
	end
	function TabsMountValidation:uncontrolledClickSwitches()
		local reported = {}
		withMounted(400, 300, tabsFixture({
			defaultValue = "one",
			onValueChange = function(value)
				local _value = value
				table.insert(reported, _value)
				return #reported
			end,
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			activateButton(mounted, waitForButton(mounted.host, "three"))
			waitForSelectedContent(mounted.host, "three")
			assertOnlySelectedVisible(mounted.host, "three")
			Assert:deepEqual(reported, { "three" })
		end)
	end
	function TabsMountValidation:textColorPerState()
		withMounted(400, 300, themed(stateTheme(0), {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			Assert:equal(titleTextOf(waitForButton(mounted.host, "one")).TextColor3, FOCUS_TEXT)
			Assert:equal(titleTextOf(waitForButton(mounted.host, "two")).TextColor3, DEFAULT_TEXT)
			Assert:equal(titleTextOf(waitForButton(mounted.host, "three")).TextColor3, DEFAULT_TEXT)
		end)
	end
	function TabsMountValidation:noStrokeAtZero()
		withMounted(400, 300, themed(stateTheme(0), {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			for _, value in TAB_VALUES do
				Assert:undefined(waitForButton(mounted.host, value):FindFirstChild("Stroke"), `Expected TabButton-{value} to have no Stroke when borderThickness is 0`)
			end
		end)
	end
	function TabsMountValidation:strokePerState()
		withMounted(400, 300, themed(stateTheme(3), {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local selectedStroke = findDescendant(waitForButton(mounted.host, "one"), "Stroke")
			local unselectedStroke = findDescendant(waitForButton(mounted.host, "two"), "Stroke")
			Assert:equal(selectedStroke.Thickness, 3)
			Assert:equal(selectedStroke.Color, FOCUS_BORDER)
			Assert:equal(selectedStroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner)
			Assert:equal(unselectedStroke.Thickness, 3)
			Assert:equal(unselectedStroke.Color, DEFAULT_BORDER)
		end)
	end
	function TabsMountValidation:stateBorderThickness()
		local theme = extendTheme(stateTheme(0), {
			components = {
				tabs = {
					button = {
						intents = {
							primary = {
								focus = {
									borderThickness = 2,
								},
							},
						},
					},
				},
			},
		})
		withMounted(400, 300, themed(theme, {
			defaultValue = "two",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "two")
			local selectedStroke = findDescendant(waitForButton(mounted.host, "two"), "Stroke")
			Assert:equal(selectedStroke.Thickness, 2)
			Assert:equal(selectedStroke.Color, FOCUS_BORDER)
			Assert:undefined(waitForButton(mounted.host, "one"):FindFirstChild("Stroke"))
		end)
	end
	function TabsMountValidation:gradientPerState()
		withMounted(400, 300, themed(stateTheme(0), {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local gradient = findDescendant(waitForButton(mounted.host, "one"), "Gradient")
			Assert["true"](Assert, gradient:IsA("UIGradient"), "Expected the selected tab's Gradient to be a UIGradient")
			Assert:equal(gradient.Rotation, 90)
			Assert:equal(gradient.Color.Keypoints[1].Value, GRADIENT_TOP)
			Assert:equal(gradient.Color.Keypoints[#gradient.Color.Keypoints].Value, GRADIENT_BOTTOM)
			Assert:undefined(waitForButton(mounted.host, "two"):FindFirstChild("Gradient"))
			mounted.update(themed(stateTheme(0), {
				value = "two",
			}))
			waitForDescendant(waitForButton(mounted.host, "two"), "Gradient", function()
				return true
			end, "Timed out waiting for the newly selected tab to render its Gradient")
			waitForLayout(function()
				return if waitForButton(mounted.host, "one"):FindFirstChild("Gradient") == nil then true else nil
			end, "Timed out waiting for the deselected tab to drop its Gradient")
		end)
	end
	function TabsMountValidation:perCornerRadius()
		local theme = extendTheme(DefaultTheme, {
			components = {
				tabs = {
					list = {
						cornerRadius = 6,
					},
					button = {
						cornerRadius = {
							topLeft = 8,
							topRight = 10,
							bottomLeft = 0,
						},
					},
				},
			},
		})
		withMounted(400, 300, themed(theme, {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local corners = findDescendant(waitForButton(mounted.host, "two"), "Corners")
			Assert:equal(corners.TopLeftRadius, UDim.new(0, 8))
			Assert:equal(corners.TopRightRadius, UDim.new(0, 10))
			Assert:equal(corners.BottomLeftRadius, UDim.new(0, 0))
			Assert:equal(corners.BottomRightRadius, UDim.new(0, 6))
		end)
	end
	function TabsMountValidation:allZeroCorners()
		local theme = extendTheme(DefaultTheme, {
			components = {
				tabs = {
					list = {
						cornerRadius = 0,
					},
					button = {
						cornerRadius = {
							topLeft = 0,
						},
					},
				},
			},
		})
		withMounted(400, 300, themed(theme, {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			Assert:undefined(waitForButton(mounted.host, "two"):FindFirstChild("Corners"))
		end)
	end
	function TabsMountValidation:listFillShares()
		withMounted(400, 300, tabsFixture({
			defaultValue = "one",
			fill = true,
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local list = findDescendant(mounted.host, "TabsList")
			local layout = list:FindFirstChild("HStack")
			Assert:notUndefined(layout, "Expected TabsList to hold its HStack UIListLayout directly")
			Assert:equal(layout.HorizontalFlex, Enum.UIFlexAlignment.Fill)
			Assert["false"](Assert, layout.Wraps, "Expected a fill list not to wrap")
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#TAB_VALUES)
			local _callback = function(value)
				return waitForButton(list, value)
			end
			for _k, _v in TAB_VALUES do
				_newValue[_k] = _callback(_v, _k - 1, TAB_VALUES)
			end
			-- ▲ ReadonlyArray.map ▲
			local buttons = _newValue
			for _, button in buttons do
				Assert:equal(button.AutomaticSize, Enum.AutomaticSize.Y)
				Assert:notUndefined(button:FindFirstChild("TitleLayout"), `Expected {button.Name} to centre its text with TitleLayout`)
			end
			waitForLayout(function()
				return if math.abs(rect(buttons[1]).width - rect(buttons[3]).width) <= 1 then true else nil
			end, `Timed out waiting for fill titles to share a width (one={rect(buttons[1]).width}, three={rect(buttons[3]).width})`)
			Assert["true"](Assert, math.abs(rect(buttons[2]).width - rect(buttons[1]).width) <= 1, "Expected every fill title to be the same width")
		end)
	end
	function TabsMountValidation:listWithoutFill()
		withMounted(400, 300, tabsFixture({
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local list = findDescendant(mounted.host, "TabsList")
			local layout = findDescendant(list, "HStack")
			Assert:equal(layout.HorizontalFlex, Enum.UIFlexAlignment.None)
			local button = waitForButton(list, "one")
			Assert:equal(button.AutomaticSize, Enum.AutomaticSize.XY)
			Assert:undefined(button:FindFirstChild("TitleLayout"))
		end)
	end
	function TabsMountValidation:listGap()
		local theme = extendTheme(DefaultTheme, {
			components = {
				tabs = {
					list = {
						gap = 11,
					},
				},
			},
		})
		withMounted(400, 300, themed(theme, {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local list = findDescendant(mounted.host, "TabsList")
			Assert:equal(findDescendant(list, "HStack").Padding, UDim.new(0, 11))
		end)
	end
	function TabsMountValidation:tabsGap()
		local theme = extendTheme(DefaultTheme, {
			components = {
				tabs = {
					gap = -3,
				},
			},
		})
		withMounted(400, 300, themed(theme, {
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local layout = mounted.host:FindFirstChild("VStack")
			Assert:notUndefined(layout, "Expected the Tabs root VStack layout directly under the host")
			Assert:equal(layout.Padding, UDim.new(0, -3))
		end)
	end
	function TabsMountValidation:bodyStrokeGated()
		withMounted(400, 300, tabsFixture({
			defaultValue = "one",
		}), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local body = findDescendant(mounted.host, "TabsBody")
			local stroke = body:FindFirstChild("Stroke")
			Assert:notUndefined(stroke, "Expected the default theme's TabsBody to carry a Stroke")
			Assert:equal(stroke.Thickness, DefaultTheme.components.tabs.borderThickness)
			mounted.update(themed(extendTheme(DefaultTheme, {
				components = {
					tabs = {
						borderThickness = 0,
					},
				},
			}), {
				defaultValue = "one",
			}))
			waitForLayout(function()
				return if body:FindFirstChild("Stroke") == nil then true else nil
			end, "Timed out waiting for TabsBody to drop its Stroke with borderThickness 0")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without defaultValue the first declared tab claims the selection, so only its panel is visible and the rest stay mounted but hidden")
	local _descriptor = Test(TabsMountValidation, "firstTabSelectedByDefault", {
		value = TabsMountValidation.firstTabSelectedByDefault,
	})
	if _descriptor then
		TabsMountValidation.firstTabSelectedByDefault = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TabsMountValidation, "firstTabSelectedByDefault", {
		value = TabsMountValidation.firstTabSelectedByDefault,
	})
	if _descriptor_1 then
		TabsMountValidation.firstTabSelectedByDefault = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TabsMountValidation, "firstTabSelectedByDefault", {
		value = TabsMountValidation.firstTabSelectedByDefault,
	})
	if _descriptor_2 then
		TabsMountValidation.firstTabSelectedByDefault = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("defaultValue seeds the selection so a non-first tab's panel is the one shown")
	local _descriptor_3 = Test(TabsMountValidation, "defaultValueSelectsTab", {
		value = TabsMountValidation.defaultValueSelectsTab,
	})
	if _descriptor_3 then
		TabsMountValidation.defaultValueSelectsTab = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TabsMountValidation, "defaultValueSelectsTab", {
		value = TabsMountValidation.defaultValueSelectsTab,
	})
	if _descriptor_4 then
		TabsMountValidation.defaultValueSelectsTab = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TabsMountValidation, "defaultValueSelectsTab", {
		value = TabsMountValidation.defaultValueSelectsTab,
	})
	if _descriptor_5 then
		TabsMountValidation.defaultValueSelectsTab = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Tab buttons are laid out left-to-right in declaration order inside the list")
	local _descriptor_6 = Test(TabsMountValidation, "titlesInOrder", {
		value = TabsMountValidation.titlesInOrder,
	})
	if _descriptor_6 then
		TabsMountValidation.titlesInOrder = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TabsMountValidation, "titlesInOrder", {
		value = TabsMountValidation.titlesInOrder,
	})
	if _descriptor_7 then
		TabsMountValidation.titlesInOrder = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TabsMountValidation, "titlesInOrder", {
		value = TabsMountValidation.titlesInOrder,
	})
	if _descriptor_8 then
		TabsMountValidation.titlesInOrder = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("The list, the body and every visible descendant of each stay inside their container and the host")
	local _descriptor_9 = Test(TabsMountValidation, "contentsContained", {
		value = TabsMountValidation.contentsContained,
	})
	if _descriptor_9 then
		TabsMountValidation.contentsContained = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TabsMountValidation, "contentsContained", {
		value = TabsMountValidation.contentsContained,
	})
	if _descriptor_10 then
		TabsMountValidation.contentsContained = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TabsMountValidation, "contentsContained", {
		value = TabsMountValidation.contentsContained,
	})
	if _descriptor_11 then
		TabsMountValidation.contentsContained = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("In controlled mode the visible panel is whatever value says, and re-rendering with a new value moves it")
	local _descriptor_12 = Test(TabsMountValidation, "controlledFollowsValue", {
		value = TabsMountValidation.controlledFollowsValue,
	})
	if _descriptor_12 then
		TabsMountValidation.controlledFollowsValue = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(TabsMountValidation, "controlledFollowsValue", {
		value = TabsMountValidation.controlledFollowsValue,
	})
	if _descriptor_13 then
		TabsMountValidation.controlledFollowsValue = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TabsMountValidation, "controlledFollowsValue", {
		value = TabsMountValidation.controlledFollowsValue,
	})
	if _descriptor_14 then
		TabsMountValidation.controlledFollowsValue = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("Clicking another title in controlled mode reports it through onValueChange but keeps the panel until value is fed back")
	local _descriptor_15 = Test(TabsMountValidation, "controlledClickOnlyReports", {
		value = TabsMountValidation.controlledClickOnlyReports,
	})
	if _descriptor_15 then
		TabsMountValidation.controlledClickOnlyReports = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(TabsMountValidation, "controlledClickOnlyReports", {
		value = TabsMountValidation.controlledClickOnlyReports,
	})
	if _descriptor_16 then
		TabsMountValidation.controlledClickOnlyReports = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(TabsMountValidation, "controlledClickOnlyReports", {
		value = TabsMountValidation.controlledClickOnlyReports,
	})
	if _descriptor_17 then
		TabsMountValidation.controlledClickOnlyReports = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("A controlled value that matches no title shows no panel, because titles make no mount-time claim")
	local _descriptor_18 = Test(TabsMountValidation, "controlledUnknownValue", {
		value = TabsMountValidation.controlledUnknownValue,
	})
	if _descriptor_18 then
		TabsMountValidation.controlledUnknownValue = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(TabsMountValidation, "controlledUnknownValue", {
		value = TabsMountValidation.controlledUnknownValue,
	})
	if _descriptor_19 then
		TabsMountValidation.controlledUnknownValue = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(TabsMountValidation, "controlledUnknownValue", {
		value = TabsMountValidation.controlledUnknownValue,
	})
	if _descriptor_20 then
		TabsMountValidation.controlledUnknownValue = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("In uncontrolled mode clicking a title switches the panel immediately and still fires onValueChange")
	local _descriptor_21 = Test(TabsMountValidation, "uncontrolledClickSwitches", {
		value = TabsMountValidation.uncontrolledClickSwitches,
	})
	if _descriptor_21 then
		TabsMountValidation.uncontrolledClickSwitches = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(TabsMountValidation, "uncontrolledClickSwitches", {
		value = TabsMountValidation.uncontrolledClickSwitches,
	})
	if _descriptor_22 then
		TabsMountValidation.uncontrolledClickSwitches = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(TabsMountValidation, "uncontrolledClickSwitches", {
		value = TabsMountValidation.uncontrolledClickSwitches,
	})
	if _descriptor_23 then
		TabsMountValidation.uncontrolledClickSwitches = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("The selected title's text uses the focus textColor and unselected titles use the default textColor")
	local _descriptor_24 = Test(TabsMountValidation, "textColorPerState", {
		value = TabsMountValidation.textColorPerState,
	})
	if _descriptor_24 then
		TabsMountValidation.textColorPerState = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(TabsMountValidation, "textColorPerState", {
		value = TabsMountValidation.textColorPerState,
	})
	if _descriptor_25 then
		TabsMountValidation.textColorPerState = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(TabsMountValidation, "textColorPerState", {
		value = TabsMountValidation.textColorPerState,
	})
	if _descriptor_26 then
		TabsMountValidation.textColorPerState = _descriptor_26.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = DisplayName("With button.borderThickness 0 no tab button carries a Stroke")
	local _descriptor_27 = Test(TabsMountValidation, "noStrokeAtZero", {
		value = TabsMountValidation.noStrokeAtZero,
	})
	if _descriptor_27 then
		TabsMountValidation.noStrokeAtZero = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_19(TabsMountValidation, "noStrokeAtZero", {
		value = TabsMountValidation.noStrokeAtZero,
	})
	if _descriptor_28 then
		TabsMountValidation.noStrokeAtZero = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_18(TabsMountValidation, "noStrokeAtZero", {
		value = TabsMountValidation.noStrokeAtZero,
	})
	if _descriptor_29 then
		TabsMountValidation.noStrokeAtZero = _descriptor_29.value
	end
	local _decorator_20 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_21 = DisplayName("With a positive button.borderThickness each tab gets an inner Stroke coloured by its own state's borderColor")
	local _descriptor_30 = Test(TabsMountValidation, "strokePerState", {
		value = TabsMountValidation.strokePerState,
	})
	if _descriptor_30 then
		TabsMountValidation.strokePerState = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_21(TabsMountValidation, "strokePerState", {
		value = TabsMountValidation.strokePerState,
	})
	if _descriptor_31 then
		TabsMountValidation.strokePerState = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_20(TabsMountValidation, "strokePerState", {
		value = TabsMountValidation.strokePerState,
	})
	if _descriptor_32 then
		TabsMountValidation.strokePerState = _descriptor_32.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("A state-level borderThickness overrides button.borderThickness and can add a Stroke to that state alone")
	local _descriptor_33 = Test(TabsMountValidation, "stateBorderThickness", {
		value = TabsMountValidation.stateBorderThickness,
	})
	if _descriptor_33 then
		TabsMountValidation.stateBorderThickness = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_23(TabsMountValidation, "stateBorderThickness", {
		value = TabsMountValidation.stateBorderThickness,
	})
	if _descriptor_34 then
		TabsMountValidation.stateBorderThickness = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_22(TabsMountValidation, "stateBorderThickness", {
		value = TabsMountValidation.stateBorderThickness,
	})
	if _descriptor_35 then
		TabsMountValidation.stateBorderThickness = _descriptor_35.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_25 = DisplayName("Only the state that defines a backgroundGradient renders a UIGradient, and it moves with the selection")
	local _descriptor_36 = Test(TabsMountValidation, "gradientPerState", {
		value = TabsMountValidation.gradientPerState,
	})
	if _descriptor_36 then
		TabsMountValidation.gradientPerState = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_25(TabsMountValidation, "gradientPerState", {
		value = TabsMountValidation.gradientPerState,
	})
	if _descriptor_37 then
		TabsMountValidation.gradientPerState = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_24(TabsMountValidation, "gradientPerState", {
		value = TabsMountValidation.gradientPerState,
	})
	if _descriptor_38 then
		TabsMountValidation.gradientPerState = _descriptor_38.value
	end
	local _decorator_26 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_27 = DisplayName("A per-corner button.cornerRadius sets each UICorner corner, falling back to list.cornerRadius for unset corners")
	local _descriptor_39 = Test(TabsMountValidation, "perCornerRadius", {
		value = TabsMountValidation.perCornerRadius,
	})
	if _descriptor_39 then
		TabsMountValidation.perCornerRadius = _descriptor_39.value
	end
	local _descriptor_40 = _decorator_27(TabsMountValidation, "perCornerRadius", {
		value = TabsMountValidation.perCornerRadius,
	})
	if _descriptor_40 then
		TabsMountValidation.perCornerRadius = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_26(TabsMountValidation, "perCornerRadius", {
		value = TabsMountValidation.perCornerRadius,
	})
	if _descriptor_41 then
		TabsMountValidation.perCornerRadius = _descriptor_41.value
	end
	local _decorator_28 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_29 = DisplayName("A per-corner button.cornerRadius that resolves to zero on every corner renders no Corners")
	local _descriptor_42 = Test(TabsMountValidation, "allZeroCorners", {
		value = TabsMountValidation.allZeroCorners,
	})
	if _descriptor_42 then
		TabsMountValidation.allZeroCorners = _descriptor_42.value
	end
	local _descriptor_43 = _decorator_29(TabsMountValidation, "allZeroCorners", {
		value = TabsMountValidation.allZeroCorners,
	})
	if _descriptor_43 then
		TabsMountValidation.allZeroCorners = _descriptor_43.value
	end
	local _descriptor_44 = _decorator_28(TabsMountValidation, "allZeroCorners", {
		value = TabsMountValidation.allZeroCorners,
	})
	if _descriptor_44 then
		TabsMountValidation.allZeroCorners = _descriptor_44.value
	end
	local _decorator_30 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_31 = DisplayName("Tabs.List fill switches the title row to a non-wrapping Fill layout and gives every title the same width")
	local _descriptor_45 = Test(TabsMountValidation, "listFillShares", {
		value = TabsMountValidation.listFillShares,
	})
	if _descriptor_45 then
		TabsMountValidation.listFillShares = _descriptor_45.value
	end
	local _descriptor_46 = _decorator_31(TabsMountValidation, "listFillShares", {
		value = TabsMountValidation.listFillShares,
	})
	if _descriptor_46 then
		TabsMountValidation.listFillShares = _descriptor_46.value
	end
	local _descriptor_47 = _decorator_30(TabsMountValidation, "listFillShares", {
		value = TabsMountValidation.listFillShares,
	})
	if _descriptor_47 then
		TabsMountValidation.listFillShares = _descriptor_47.value
	end
	local _decorator_32 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_33 = DisplayName("Without fill the title row keeps no flex, and titles hug their text with no TitleLayout")
	local _descriptor_48 = Test(TabsMountValidation, "listWithoutFill", {
		value = TabsMountValidation.listWithoutFill,
	})
	if _descriptor_48 then
		TabsMountValidation.listWithoutFill = _descriptor_48.value
	end
	local _descriptor_49 = _decorator_33(TabsMountValidation, "listWithoutFill", {
		value = TabsMountValidation.listWithoutFill,
	})
	if _descriptor_49 then
		TabsMountValidation.listWithoutFill = _descriptor_49.value
	end
	local _descriptor_50 = _decorator_32(TabsMountValidation, "listWithoutFill", {
		value = TabsMountValidation.listWithoutFill,
	})
	if _descriptor_50 then
		TabsMountValidation.listWithoutFill = _descriptor_50.value
	end
	local _decorator_34 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_35 = DisplayName("tabs.list.gap sets the pixel Padding of the title row layout")
	local _descriptor_51 = Test(TabsMountValidation, "listGap", {
		value = TabsMountValidation.listGap,
	})
	if _descriptor_51 then
		TabsMountValidation.listGap = _descriptor_51.value
	end
	local _descriptor_52 = _decorator_35(TabsMountValidation, "listGap", {
		value = TabsMountValidation.listGap,
	})
	if _descriptor_52 then
		TabsMountValidation.listGap = _descriptor_52.value
	end
	local _descriptor_53 = _decorator_34(TabsMountValidation, "listGap", {
		value = TabsMountValidation.listGap,
	})
	if _descriptor_53 then
		TabsMountValidation.listGap = _descriptor_53.value
	end
	local _decorator_36 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_37 = DisplayName("tabs.gap sets the Padding of the root VStack between the list and the body, including negative overlap")
	local _descriptor_54 = Test(TabsMountValidation, "tabsGap", {
		value = TabsMountValidation.tabsGap,
	})
	if _descriptor_54 then
		TabsMountValidation.tabsGap = _descriptor_54.value
	end
	local _descriptor_55 = _decorator_37(TabsMountValidation, "tabsGap", {
		value = TabsMountValidation.tabsGap,
	})
	if _descriptor_55 then
		TabsMountValidation.tabsGap = _descriptor_55.value
	end
	local _descriptor_56 = _decorator_36(TabsMountValidation, "tabsGap", {
		value = TabsMountValidation.tabsGap,
	})
	if _descriptor_56 then
		TabsMountValidation.tabsGap = _descriptor_56.value
	end
	local _decorator_38 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_39 = DisplayName("TabsBody renders its Stroke from tabs.borderThickness and renders none when it is 0")
	local _descriptor_57 = Test(TabsMountValidation, "bodyStrokeGated", {
		value = TabsMountValidation.bodyStrokeGated,
	})
	if _descriptor_57 then
		TabsMountValidation.bodyStrokeGated = _descriptor_57.value
	end
	local _descriptor_58 = _decorator_39(TabsMountValidation, "bodyStrokeGated", {
		value = TabsMountValidation.bodyStrokeGated,
	})
	if _descriptor_58 then
		TabsMountValidation.bodyStrokeGated = _descriptor_58.value
	end
	local _descriptor_59 = _decorator_38(TabsMountValidation, "bodyStrokeGated", {
		value = TabsMountValidation.bodyStrokeGated,
	})
	if _descriptor_59 then
		TabsMountValidation.bodyStrokeGated = _descriptor_59.value
	end
	TabsMountValidation = Tag("Studio")(TabsMountValidation) or TabsMountValidation
end
return TabsMountValidation
