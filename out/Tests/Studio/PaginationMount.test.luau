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
local _binding = Decorators
local Skip = _binding.Skip
local Pagination = TS.import(script, script.Parent.Parent.Parent, "Components", "Layout", "Pagination").Pagination
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
	function PaginationMountValidation:rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow()
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
	function PaginationMountValidation:rendersTheStartWindowWithOneRightEllipsis()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 1,
			totalPages = 10,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		-- Near the start, the leading run of numbers extends (1..5) to keep the
		-- total item count constant with the middle/end windows.
		for _, page in { 1, 2, 3, 4, 5, 10 } do
			Assert:notUndefined(host:FindFirstChild(`PaginationItem-{page}`, true))
		end
		Assert:undefined(host:FindFirstChild("PaginationItem-6", true))
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 1)
		unmount(root, host)
	end
	function PaginationMountValidation:rendersTheEndWindowWithOneLeftEllipsis()
		local _binding_1 = renderPagination(React.createElement(Pagination, {
			page = 10,
			totalPages = 10,
			onPageChange = function() end,
		}))
		local host = _binding_1.host
		local root = _binding_1.root
		-- Near the end, the trailing run of numbers extends (6..10) to keep the
		-- total item count constant with the middle/start windows.
		for _, page in { 1, 6, 7, 8, 9, 10 } do
			Assert:notUndefined(host:FindFirstChild(`PaginationItem-{page}`, true))
		end
		Assert:undefined(host:FindFirstChild("PaginationItem-5", true))
		Assert:equal(#getNamedDescendants(host, "PaginationEllipsis"), 1)
		unmount(root, host)
	end
	function PaginationMountValidation:siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses()
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
	function PaginationMountValidation:siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage()
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
	function PaginationMountValidation:currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart()
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
		Assert:notEqual(selected.BackgroundColor3, unselected.BackgroundColor3)
		unmount(root, host)
	end
	function PaginationMountValidation:nextIsDisabledAtTheEndWhilePreviousRemainsInteractive()
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
	function PaginationMountValidation:suppliedChildrenReplaceTheDefaultLayout()
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
	function PaginationMountValidation:explicitListChildrenReplaceAutomaticallyComputedItems()
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
	function PaginationMountValidation:pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges()
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
	function PaginationMountValidation:windowedPaginationRendersTheSameTotalItemCountAtEveryPage()
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
	local _descriptor = Test(PaginationMountValidation, "rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow", {
		value = PaginationMountValidation.rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow,
	})
	if _descriptor then
		PaginationMountValidation.rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow = _descriptor.value
	end
	local _descriptor_1 = _decorator(PaginationMountValidation, "rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow", {
		value = PaginationMountValidation.rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow,
	})
	if _descriptor_1 then
		PaginationMountValidation.rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow = _descriptor_1.value
	end
	local _decorator_1 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_2 = Test(PaginationMountValidation, "rendersTheStartWindowWithOneRightEllipsis", {
		value = PaginationMountValidation.rendersTheStartWindowWithOneRightEllipsis,
	})
	if _descriptor_2 then
		PaginationMountValidation.rendersTheStartWindowWithOneRightEllipsis = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(PaginationMountValidation, "rendersTheStartWindowWithOneRightEllipsis", {
		value = PaginationMountValidation.rendersTheStartWindowWithOneRightEllipsis,
	})
	if _descriptor_3 then
		PaginationMountValidation.rendersTheStartWindowWithOneRightEllipsis = _descriptor_3.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_4 = Test(PaginationMountValidation, "rendersTheEndWindowWithOneLeftEllipsis", {
		value = PaginationMountValidation.rendersTheEndWindowWithOneLeftEllipsis,
	})
	if _descriptor_4 then
		PaginationMountValidation.rendersTheEndWindowWithOneLeftEllipsis = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(PaginationMountValidation, "rendersTheEndWindowWithOneLeftEllipsis", {
		value = PaginationMountValidation.rendersTheEndWindowWithOneLeftEllipsis,
	})
	if _descriptor_5 then
		PaginationMountValidation.rendersTheEndWindowWithOneLeftEllipsis = _descriptor_5.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_6 = Test(PaginationMountValidation, "siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses", {
		value = PaginationMountValidation.siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses,
	})
	if _descriptor_6 then
		PaginationMountValidation.siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(PaginationMountValidation, "siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses", {
		value = PaginationMountValidation.siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses,
	})
	if _descriptor_7 then
		PaginationMountValidation.siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses = _descriptor_7.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_8 = Test(PaginationMountValidation, "siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage", {
		value = PaginationMountValidation.siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage,
	})
	if _descriptor_8 then
		PaginationMountValidation.siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(PaginationMountValidation, "siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage", {
		value = PaginationMountValidation.siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage,
	})
	if _descriptor_9 then
		PaginationMountValidation.siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage = _descriptor_9.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_10 = Test(PaginationMountValidation, "currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart", {
		value = PaginationMountValidation.currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart,
	})
	if _descriptor_10 then
		PaginationMountValidation.currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_5(PaginationMountValidation, "currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart", {
		value = PaginationMountValidation.currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart,
	})
	if _descriptor_11 then
		PaginationMountValidation.currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart = _descriptor_11.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_12 = Test(PaginationMountValidation, "nextIsDisabledAtTheEndWhilePreviousRemainsInteractive", {
		value = PaginationMountValidation.nextIsDisabledAtTheEndWhilePreviousRemainsInteractive,
	})
	if _descriptor_12 then
		PaginationMountValidation.nextIsDisabledAtTheEndWhilePreviousRemainsInteractive = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_6(PaginationMountValidation, "nextIsDisabledAtTheEndWhilePreviousRemainsInteractive", {
		value = PaginationMountValidation.nextIsDisabledAtTheEndWhilePreviousRemainsInteractive,
	})
	if _descriptor_13 then
		PaginationMountValidation.nextIsDisabledAtTheEndWhilePreviousRemainsInteractive = _descriptor_13.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_14 = Test(PaginationMountValidation, "suppliedChildrenReplaceTheDefaultLayout", {
		value = PaginationMountValidation.suppliedChildrenReplaceTheDefaultLayout,
	})
	if _descriptor_14 then
		PaginationMountValidation.suppliedChildrenReplaceTheDefaultLayout = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_7(PaginationMountValidation, "suppliedChildrenReplaceTheDefaultLayout", {
		value = PaginationMountValidation.suppliedChildrenReplaceTheDefaultLayout,
	})
	if _descriptor_15 then
		PaginationMountValidation.suppliedChildrenReplaceTheDefaultLayout = _descriptor_15.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_16 = Test(PaginationMountValidation, "explicitListChildrenReplaceAutomaticallyComputedItems", {
		value = PaginationMountValidation.explicitListChildrenReplaceAutomaticallyComputedItems,
	})
	if _descriptor_16 then
		PaginationMountValidation.explicitListChildrenReplaceAutomaticallyComputedItems = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_8(PaginationMountValidation, "explicitListChildrenReplaceAutomaticallyComputedItems", {
		value = PaginationMountValidation.explicitListChildrenReplaceAutomaticallyComputedItems,
	})
	if _descriptor_17 then
		PaginationMountValidation.explicitListChildrenReplaceAutomaticallyComputedItems = _descriptor_17.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_18 = Test(PaginationMountValidation, "pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges", {
		value = PaginationMountValidation.pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges,
	})
	if _descriptor_18 then
		PaginationMountValidation.pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_9(PaginationMountValidation, "pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges", {
		value = PaginationMountValidation.pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges,
	})
	if _descriptor_19 then
		PaginationMountValidation.pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges = _descriptor_19.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	local _descriptor_20 = Test(PaginationMountValidation, "windowedPaginationRendersTheSameTotalItemCountAtEveryPage", {
		value = PaginationMountValidation.windowedPaginationRendersTheSameTotalItemCountAtEveryPage,
	})
	if _descriptor_20 then
		PaginationMountValidation.windowedPaginationRendersTheSameTotalItemCountAtEveryPage = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_10(PaginationMountValidation, "windowedPaginationRendersTheSameTotalItemCountAtEveryPage", {
		value = PaginationMountValidation.windowedPaginationRendersTheSameTotalItemCountAtEveryPage,
	})
	if _descriptor_21 then
		PaginationMountValidation.windowedPaginationRendersTheSameTotalItemCountAtEveryPage = _descriptor_21.value
	end
	PaginationMountValidation = Tag("Studio")(PaginationMountValidation) or PaginationMountValidation
end
return PaginationMountValidation
