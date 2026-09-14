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
local Pagination = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Pagination").Pagination
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local createTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").createTheme
local function renderPagination(element)
	local host = Instance.new("Folder")
	local root = ReactRoblox.createRoot(host)
	root:render(element)
	task.wait()
	return {
		host = host,
		root = root,
	}
end
local function getNamedDescendants(host, name)
	local _exp = host:GetDescendants()
	-- ▼ ReadonlyArray.filter ▼
	local _newValue = {}
	local _callback = function(descendant)
		return descendant.Name == name
	end
	local _length = 0
	for _k, _v in _exp do
		if _callback(_v, _k - 1, _exp) == true then
			_length += 1
			_newValue[_length] = _v
		end
	end
	-- ▲ ReadonlyArray.filter ▲
	return _newValue
end
local function getButton(host, name)
	local button = host:FindFirstChild(name, true)
	Assert:notUndefined(button)
	Assert["true"](Assert, button:IsA("ImageButton"))
	return button
end
local function unmount(root, host)
	root:unmount()
	host:Destroy()
end
local function getOrderedPageLabels(host)
	local list = host:FindFirstChild("PaginationList", true)
	Assert:notUndefined(list)
	local entries = {}
	for _, child in list:GetChildren() do
		if child:IsA("GuiObject") then
			table.insert(entries, child)
		end
	end
	table.sort(entries, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#entries)
	local _callback = function(entry)
		return if entry.Name == "PaginationEllipsis" then "ellipsis" else string.sub(entry.Name, #"PaginationItem-" + 1)
	end
	for _k, _v in entries do
		_newValue[_k] = _callback(_v, _k - 1, entries)
	end
	-- ▲ ReadonlyArray.map ▲
	return _newValue
end
local PaginationMountValidation
do
	PaginationMountValidation = setmetatable({}, {
		__tostring = function()
			return "PaginationMountValidation"
		end,
	})
	PaginationMountValidation.__index = PaginationMountValidation
	function PaginationMountValidation.new(...)
		local self = setmetatable({}, PaginationMountValidation)
		return self:constructor(...) or self
	end
	function PaginationMountValidation:constructor()
	end
	function PaginationMountValidation:allPages()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 3,
			totalPages = 7,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		for page = 1, 7 do
			Assert:notUndefined(host:FindFirstChild(`PaginationItem-{page}`, true))
		end
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 0)
		unmount(root, host)
	end
	function PaginationMountValidation:startWindow()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 1,
			totalPages = 10,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		for _, page in { 1, 2, 3, 4, 5, 10 } do
			Assert:notUndefined(host:FindFirstChild(`PaginationItem-{page}`, true))
		end
		Assert:undefined(host:FindFirstChild("PaginationItem-6", true))
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 1)
		unmount(root, host)
	end
	function PaginationMountValidation:endWindow()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 10,
			totalPages = 10,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		for _, page in { 1, 6, 7, 8, 9, 10 } do
			Assert:notUndefined(host:FindFirstChild(`PaginationItem-{page}`, true))
		end
		Assert:undefined(host:FindFirstChild("PaginationItem-5", true))
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 1)
		unmount(root, host)
	end
	function PaginationMountValidation:zeroSiblings()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 5,
			totalPages = 10,
			siblingCount = 0,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		for _, page in { 1, 5, 10 } do
			Assert:notUndefined(host:FindFirstChild(`PaginationItem-{page}`, true))
		end
		Assert:undefined(host:FindFirstChild("PaginationItem-4", true))
		Assert:undefined(host:FindFirstChild("PaginationItem-6", true))
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 2)
		unmount(root, host)
	end
	function PaginationMountValidation:twoSiblings()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 6,
			totalPages = 12,
			siblingCount = 2,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		for _, page in { 1, 4, 5, 6, 7, 8, 12 } do
			Assert:notUndefined(host:FindFirstChild(`PaginationItem-{page}`, true))
		end
		Assert:undefined(host:FindFirstChild("PaginationItem-3", true))
		Assert:undefined(host:FindFirstChild("PaginationItem-9", true))
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 2)
		unmount(root, host)
	end
	function PaginationMountValidation:firstPageState()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 1,
			totalPages = 3,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		local previous = getButton(host, "PaginationPrev")
		local nextButton = getButton(host, "PaginationNext")
		local selected = getButton(host, "PaginationItem-1")
		local unselected = getButton(host, "PaginationItem-2")
		Assert["false"](Assert, previous.Active)
		Assert["false"](Assert, previous.Selectable)
		Assert["true"](Assert, nextButton.Active)
		Assert["true"](Assert, nextButton.Selectable)
		Assert["true"](Assert, selected.BackgroundTransparency < unselected.BackgroundTransparency)
		unmount(root, host)
	end
	function PaginationMountValidation:lastPageState()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 3,
			totalPages = 3,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		local previous = getButton(host, "PaginationPrev")
		local nextButton = getButton(host, "PaginationNext")
		Assert["true"](Assert, previous.Active)
		Assert["true"](Assert, previous.Selectable)
		Assert["false"](Assert, nextButton.Active)
		Assert["false"](Assert, nextButton.Selectable)
		unmount(root, host)
	end
	function PaginationMountValidation:noItemStrokeByDefault()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 1,
			totalPages = 3,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		for _, name in { "PaginationPrev", "PaginationItem-1", "PaginationItem-2", "PaginationNext" } do
			local button = getButton(host, name)
			Assert:equal(button.BorderSizePixel, 0, `{name} BorderSizePixel`)
			Assert:undefined(button:FindFirstChild("Stroke"), `{name} should have no Stroke`)
		end
		unmount(root, host)
	end
	function PaginationMountValidation:itemStrokeWhenThemed()
		local disabledBorder = Color3.fromHex("#FF0000")
		local theme = createTheme({
			components = {
				pagination = {
					item = {
						borderThickness = 2,
						intents = {
							primary = {
								disabled = {
									borderColor = disabledBorder,
								},
							},
						},
					},
				},
			},
		})
		local _binding_1 = renderPagination(React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(Pagination, {
			page = 1,
			totalPages = 3,
			onPageChange = function() end,
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		for _, name in { "PaginationPrev", "PaginationItem-1", "PaginationItem-2", "PaginationNext" } do
			local button = getButton(host, name)
			Assert:equal(button.BorderSizePixel, 0, `{name} BorderSizePixel`)
			local stroke = button:FindFirstChild("Stroke")
			Assert:notUndefined(stroke, `{name} should have a Stroke`)
			Assert["true"](Assert, stroke:IsA("UIStroke"))
			Assert:equal(stroke.Thickness, 2)
			Assert:equal(stroke.ApplyStrokeMode, Enum.ApplyStrokeMode.Border)
		end
		local previousStroke = getButton(host, "PaginationPrev"):FindFirstChild("Stroke")
		Assert:equal(string.upper(previousStroke.Color:ToHex()), "FF0000")
		unmount(root, host)
	end
	function PaginationMountValidation:customChildren()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 2,
			totalPages = 5,
			onPageChange = function() end,
		}, React.createElement(Pagination.Item, {
			value = 4,
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		Assert:notUndefined(host:FindFirstChild("PaginationItem-4", true))
		Assert:undefined(host:FindFirstChild("PaginationPrev", true))
		Assert:undefined(host:FindFirstChild("PaginationNext", true))
		Assert:undefined(host:FindFirstChild("PaginationList", true))
		unmount(root, host)
	end
	function PaginationMountValidation:customList()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 2,
			totalPages = 10,
			onPageChange = function() end,
		}, React.createElement(Pagination.List, nil, React.createElement(Pagination.Item, {
			value = 8,
		}), React.createElement(Pagination.Ellipsis))))
		local host = _binding_1.host
		local root = _binding_1.root
		Assert:notUndefined(host:FindFirstChild("PaginationList", true))
		Assert:notUndefined(host:FindFirstChild("PaginationItem-8", true))
		Assert:undefined(host:FindFirstChild("PaginationItem-1", true))
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 1)
		unmount(root, host)
	end
	function PaginationMountValidation:visualOrder()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 6,
			totalPages = 12,
			siblingCount = 1,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		Assert:deepEqual(getOrderedPageLabels(host), { "1", "ellipsis", "5", "6", "7", "ellipsis", "12" })
		root:render(React.createElement(Pagination, {
			page = 7,
			totalPages = 12,
			siblingCount = 1,
			onPageChange = function() end,
		}))
		task.wait()
		Assert:deepEqual(getOrderedPageLabels(host), { "1", "ellipsis", "6", "7", "8", "ellipsis", "12" })
		root:render(React.createElement(Pagination, {
			page = 8,
			totalPages = 12,
			siblingCount = 1,
			onPageChange = function() end,
		}))
		task.wait()
		Assert:deepEqual(getOrderedPageLabels(host), { "1", "ellipsis", "7", "8", "9", "ellipsis", "12" })
		unmount(root, host)
	end
	function PaginationMountValidation:constantItemCount()
		local totalPages = 12
		local siblingCount = 1
		local expectedItemCount = siblingCount * 2 + 5
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 1,
			totalPages = totalPages,
			siblingCount = siblingCount,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		local countRenderedItems = function()
			local _exp = #getNamedDescendants(host, "PaginationEllipsis")
			local _exp_1 = host:GetDescendants()
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _callback = function(descendant)
				return string.sub(descendant.Name, 1, #"PaginationItem-") == "PaginationItem-"
			end
			local _length = 0
			for _k, _v in _exp_1 do
				if _callback(_v, _k - 1, _exp_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			return _exp + #_newValue
		end
		for _, page in { 1, 2, 4, 6, 7, 8, 10, 11, 12 } do
			root:render(React.createElement(Pagination, {
				page = page,
				totalPages = totalPages,
				siblingCount = siblingCount,
				onPageChange = function() end,
			}))
			task.wait()
			Assert:equal(countRenderedItems(), expectedItemCount)
		end
		unmount(root, host)
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_1 = DisplayName("Seven pages at siblingCount 1 render every item with no ellipsis")
	local _descriptor = Test(PaginationMountValidation, "allPages", {
		value = PaginationMountValidation.allPages,
	})
	if _descriptor then
		PaginationMountValidation.allPages = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(PaginationMountValidation, "allPages", {
		value = PaginationMountValidation.allPages,
	})
	if _descriptor_1 then
		PaginationMountValidation.allPages = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(PaginationMountValidation, "allPages", {
		value = PaginationMountValidation.allPages,
	})
	if _descriptor_2 then
		PaginationMountValidation.allPages = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_3 = DisplayName("On page 1 of 10 the leading run extends to 1..5 followed by a single ellipsis and the last page")
	local _descriptor_3 = Test(PaginationMountValidation, "startWindow", {
		value = PaginationMountValidation.startWindow,
	})
	if _descriptor_3 then
		PaginationMountValidation.startWindow = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(PaginationMountValidation, "startWindow", {
		value = PaginationMountValidation.startWindow,
	})
	if _descriptor_4 then
		PaginationMountValidation.startWindow = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(PaginationMountValidation, "startWindow", {
		value = PaginationMountValidation.startWindow,
	})
	if _descriptor_5 then
		PaginationMountValidation.startWindow = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_5 = DisplayName("On page 10 of 10 the first page, a single ellipsis and the trailing run 6..10 are shown")
	local _descriptor_6 = Test(PaginationMountValidation, "endWindow", {
		value = PaginationMountValidation.endWindow,
	})
	if _descriptor_6 then
		PaginationMountValidation.endWindow = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(PaginationMountValidation, "endWindow", {
		value = PaginationMountValidation.endWindow,
	})
	if _descriptor_7 then
		PaginationMountValidation.endWindow = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(PaginationMountValidation, "endWindow", {
		value = PaginationMountValidation.endWindow,
	})
	if _descriptor_8 then
		PaginationMountValidation.endWindow = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_7 = DisplayName("With siblingCount 0 the middle window collapses to just the current page flanked by two ellipses")
	local _descriptor_9 = Test(PaginationMountValidation, "zeroSiblings", {
		value = PaginationMountValidation.zeroSiblings,
	})
	if _descriptor_9 then
		PaginationMountValidation.zeroSiblings = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(PaginationMountValidation, "zeroSiblings", {
		value = PaginationMountValidation.zeroSiblings,
	})
	if _descriptor_10 then
		PaginationMountValidation.zeroSiblings = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(PaginationMountValidation, "zeroSiblings", {
		value = PaginationMountValidation.zeroSiblings,
	})
	if _descriptor_11 then
		PaginationMountValidation.zeroSiblings = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_9 = DisplayName("With siblingCount 2 on page 6 of 12 the window spans 4..8 between two ellipses")
	local _descriptor_12 = Test(PaginationMountValidation, "twoSiblings", {
		value = PaginationMountValidation.twoSiblings,
	})
	if _descriptor_12 then
		PaginationMountValidation.twoSiblings = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(PaginationMountValidation, "twoSiblings", {
		value = PaginationMountValidation.twoSiblings,
	})
	if _descriptor_13 then
		PaginationMountValidation.twoSiblings = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(PaginationMountValidation, "twoSiblings", {
		value = PaginationMountValidation.twoSiblings,
	})
	if _descriptor_14 then
		PaginationMountValidation.twoSiblings = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_11 = DisplayName("On the first page Prev is inactive, Next is active and the current item has an opaque background")
	local _descriptor_15 = Test(PaginationMountValidation, "firstPageState", {
		value = PaginationMountValidation.firstPageState,
	})
	if _descriptor_15 then
		PaginationMountValidation.firstPageState = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(PaginationMountValidation, "firstPageState", {
		value = PaginationMountValidation.firstPageState,
	})
	if _descriptor_16 then
		PaginationMountValidation.firstPageState = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(PaginationMountValidation, "firstPageState", {
		value = PaginationMountValidation.firstPageState,
	})
	if _descriptor_17 then
		PaginationMountValidation.firstPageState = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_13 = DisplayName("On the last page Next is inactive and unselectable while Prev stays interactive")
	local _descriptor_18 = Test(PaginationMountValidation, "lastPageState", {
		value = PaginationMountValidation.lastPageState,
	})
	if _descriptor_18 then
		PaginationMountValidation.lastPageState = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(PaginationMountValidation, "lastPageState", {
		value = PaginationMountValidation.lastPageState,
	})
	if _descriptor_19 then
		PaginationMountValidation.lastPageState = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(PaginationMountValidation, "lastPageState", {
		value = PaginationMountValidation.lastPageState,
	})
	if _descriptor_20 then
		PaginationMountValidation.lastPageState = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_15 = DisplayName("With the default zero item border thickness buttons have no native border and no Stroke")
	local _descriptor_21 = Test(PaginationMountValidation, "noItemStrokeByDefault", {
		value = PaginationMountValidation.noItemStrokeByDefault,
	})
	if _descriptor_21 then
		PaginationMountValidation.noItemStrokeByDefault = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(PaginationMountValidation, "noItemStrokeByDefault", {
		value = PaginationMountValidation.noItemStrokeByDefault,
	})
	if _descriptor_22 then
		PaginationMountValidation.noItemStrokeByDefault = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(PaginationMountValidation, "noItemStrokeByDefault", {
		value = PaginationMountValidation.noItemStrokeByDefault,
	})
	if _descriptor_23 then
		PaginationMountValidation.noItemStrokeByDefault = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_17 = DisplayName("A positive item border thickness renders a Border-mode Stroke with the state colour instead of a native border")
	local _descriptor_24 = Test(PaginationMountValidation, "itemStrokeWhenThemed", {
		value = PaginationMountValidation.itemStrokeWhenThemed,
	})
	if _descriptor_24 then
		PaginationMountValidation.itemStrokeWhenThemed = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(PaginationMountValidation, "itemStrokeWhenThemed", {
		value = PaginationMountValidation.itemStrokeWhenThemed,
	})
	if _descriptor_25 then
		PaginationMountValidation.itemStrokeWhenThemed = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(PaginationMountValidation, "itemStrokeWhenThemed", {
		value = PaginationMountValidation.itemStrokeWhenThemed,
	})
	if _descriptor_26 then
		PaginationMountValidation.itemStrokeWhenThemed = _descriptor_26.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_19 = DisplayName("Passing a lone Pagination.Item child omits the default Prev, Next and List entirely")
	local _descriptor_27 = Test(PaginationMountValidation, "customChildren", {
		value = PaginationMountValidation.customChildren,
	})
	if _descriptor_27 then
		PaginationMountValidation.customChildren = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_19(PaginationMountValidation, "customChildren", {
		value = PaginationMountValidation.customChildren,
	})
	if _descriptor_28 then
		PaginationMountValidation.customChildren = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_18(PaginationMountValidation, "customChildren", {
		value = PaginationMountValidation.customChildren,
	})
	if _descriptor_29 then
		PaginationMountValidation.customChildren = _descriptor_29.value
	end
	local _decorator_20 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_21 = DisplayName("Items placed inside an explicit Pagination.List render as-is instead of the computed page window")
	local _descriptor_30 = Test(PaginationMountValidation, "customList", {
		value = PaginationMountValidation.customList,
	})
	if _descriptor_30 then
		PaginationMountValidation.customList = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_21(PaginationMountValidation, "customList", {
		value = PaginationMountValidation.customList,
	})
	if _descriptor_31 then
		PaginationMountValidation.customList = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_20(PaginationMountValidation, "customList", {
		value = PaginationMountValidation.customList,
	})
	if _descriptor_32 then
		PaginationMountValidation.customList = _descriptor_32.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_23 = DisplayName("Stepping from page 6 to 7 to 8 keeps LayoutOrder ascending with ellipses in the right slots")
	local _descriptor_33 = Test(PaginationMountValidation, "visualOrder", {
		value = PaginationMountValidation.visualOrder,
	})
	if _descriptor_33 then
		PaginationMountValidation.visualOrder = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_23(PaginationMountValidation, "visualOrder", {
		value = PaginationMountValidation.visualOrder,
	})
	if _descriptor_34 then
		PaginationMountValidation.visualOrder = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_22(PaginationMountValidation, "visualOrder", {
		value = PaginationMountValidation.visualOrder,
	})
	if _descriptor_35 then
		PaginationMountValidation.visualOrder = _descriptor_35.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _decorator_25 = DisplayName("Items plus ellipses always total siblingCount * 2 + 5 no matter which page is current")
	local _descriptor_36 = Test(PaginationMountValidation, "constantItemCount", {
		value = PaginationMountValidation.constantItemCount,
	})
	if _descriptor_36 then
		PaginationMountValidation.constantItemCount = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_25(PaginationMountValidation, "constantItemCount", {
		value = PaginationMountValidation.constantItemCount,
	})
	if _descriptor_37 then
		PaginationMountValidation.constantItemCount = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_24(PaginationMountValidation, "constantItemCount", {
		value = PaginationMountValidation.constantItemCount,
	})
	if _descriptor_38 then
		PaginationMountValidation.constantItemCount = _descriptor_38.value
	end
	PaginationMountValidation = Tag("Studio")(PaginationMountValidation) or PaginationMountValidation
end
return PaginationMountValidation
