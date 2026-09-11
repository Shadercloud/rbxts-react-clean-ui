-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local Assert = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out).Assert
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent, "Theme").DefaultTheme
local STUDIO_SKIP_MESSAGE = "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner."
local waitForLayout
local function mountInScreenGui(width, height, element)
	local coreGui = game:FindFirstChild("CoreGui")
	Assert:notUndefined(coreGui, "Expected CoreGui to be available to host the component under test")
	local gui = Instance.new("ScreenGui")
	gui.Name = "LayoutMountValidation"
	gui.Parent = coreGui
	local host = Instance.new("Frame")
	host.Name = "Host"
	host.BackgroundTransparency = 1
	host.Size = UDim2.fromOffset(width, height)
	host.Parent = gui
	local root = ReactRoblox.createRoot(host)
	local update = function(nextElement)
		root:render(React.createElement(ThemeProvider, {
			theme = DefaultTheme,
		}, nextElement))
		task.wait()
	end
	local resize = function(nextWidth, nextHeight)
		host.Size = UDim2.fromOffset(nextWidth, nextHeight)
		task.wait()
		waitForLayout(function()
			return if host.AbsoluteSize.X == nextWidth and host.AbsoluteSize.Y == nextHeight then true else nil
		end, `Timed out waiting for the host to resize to {nextWidth}x{nextHeight} (AbsoluteSize is {host.AbsoluteSize.X}x{host.AbsoluteSize.Y})`)
		task.wait()
	end
	local unmount = function()
		root:unmount()
		host:Destroy()
		gui:Destroy()
	end
	update(element)
	return {
		host = host,
		root = root,
		update = update,
		resize = resize,
		unmount = unmount,
	}
end
local function withMounted(width, height, element, fn)
	local mounted = mountInScreenGui(width, height, element)
	TS.try(function()
		fn(mounted)
	end, nil, function()
		mounted.unmount()
	end)
end
function waitForLayout(resolve, failureMessage)
	for attempt = 0, 29 do
		local value = resolve()
		if value ~= nil then
			return value
		end
		task.wait()
	end
	return Assert:fail(failureMessage)
end
local function waitForDescendant(root, name, predicate, failureMessage)
	local _exp = function()
		local found = root:FindFirstChild(name, true)
		return if found ~= nil and predicate(found) then found else nil
	end
	local _condition = failureMessage
	if _condition == nil then
		_condition = `Timed out waiting for a descendant named "{name}" to satisfy its predicate`
	end
	return waitForLayout(_exp, _condition)
end
local function waitForGuiObject(root, name, predicate, failureMessage)
	local test = predicate or (function(gui)
		return gui.AbsoluteSize.X > 0 and gui.AbsoluteSize.Y > 0
	end)
	local _exp = root
	local _exp_1 = name
	local _condition = failureMessage
	if _condition == nil then
		_condition = (if predicate == nil then `Timed out waiting for a GuiObject named "{name}" to render with a non-zero AbsoluteSize` else `Timed out waiting for a GuiObject named "{name}" to satisfy its predicate`)
	end
	return waitForDescendant(_exp, _exp_1, test, _condition)
end
local function findDescendant(root, name)
	local found = root:FindFirstChild(name, true)
	Assert:notUndefined(found, `Expected to find a descendant named "{name}" under {root:GetFullName()}`)
	return found
end
local function findDescendantOfClass(root, className)
	local found = root:FindFirstChildWhichIsA(className, true)
	Assert:notUndefined(found, `Expected to find a descendant of class "{className}" under {root:GetFullName()}`)
	return found
end
local function rect(gui)
	local position = gui.AbsolutePosition
	local size = gui.AbsoluteSize
	return {
		left = position.X,
		top = position.Y,
		right = position.X + size.X,
		bottom = position.Y + size.Y,
		width = size.X,
		height = size.Y,
		centerX = position.X + size.X / 2,
		centerY = position.Y + size.Y / 2,
	}
end
local function formatRect(r)
	return `[left={r.left}, top={r.top}, right={r.right}, bottom={r.bottom}, width={r.width}, height={r.height}]`
end
local function describeGui(gui)
	return `{gui:GetFullName()} ({gui.ClassName})`
end
local EDGE_EPSILON = 0.5
local function assertContained(child, parent, label)
	local childRect = rect(child)
	local parentRect = rect(parent)
	local contained = childRect.left >= parentRect.left - EDGE_EPSILON and childRect.top >= parentRect.top - EDGE_EPSILON and childRect.right <= parentRect.right + EDGE_EPSILON and childRect.bottom <= parentRect.bottom + EDGE_EPSILON
	Assert["true"](Assert, contained, `{label}: expected {describeGui(child)} {formatRect(childRect)} to be fully inside {describeGui(parent)} {formatRect(parentRect)}`)
end
local function assertAllDescendantsContained(container, label, ignore)
	local walk
	walk = function(parent, clipAncestor)
		for _, child in parent:GetChildren() do
			if not child:IsA("GuiObject") then
				walk(child, clipAncestor)
				continue
			end
			if not child.Visible then
				continue
			end
			if ignore ~= nil and ignore(child) then
				walk(child, clipAncestor)
				continue
			end
			assertContained(child, clipAncestor, label)
			walk(child, if child.ClipsDescendants then child else clipAncestor)
		end
	end
	walk(container, container)
end
local function intersects(a, b)
	return a.left + EDGE_EPSILON < b.right and b.left + EDGE_EPSILON < a.right and a.top + EDGE_EPSILON < b.bottom and b.top + EDGE_EPSILON < a.bottom
end
local function assertNoSiblingOverlap(parent, label)
	local siblings = {}
	for _, child in parent:GetChildren() do
		if child:IsA("GuiObject") and child.Visible then
			table.insert(siblings, child)
		end
	end
	for i = 0, #siblings - 1 do
		do
			local j = i + 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					j += 1
				else
					_shouldIncrement = true
				end
				if not (j < #siblings) then
					break
				end
				local a = siblings[i + 1]
				local b = siblings[j + 1]
				local aRect = rect(a)
				local bRect = rect(b)
				Assert["false"](Assert, intersects(aRect, bRect), `{label}: expected siblings {describeGui(a)} {formatRect(aRect)} and {describeGui(b)} {formatRect(bRect)} not to overlap`)
			end
		end
	end
end
local function assertTextFits(textObject, name)
	if textObject.TextFits then
		return nil
	end
	local bounds = textObject.TextBounds
	local size = textObject.AbsoluteSize
	local message = `{name}: text does not fit its {describeGui(textObject)} - TextFits=false, ` .. `TextBounds=({bounds.X}, {bounds.Y}) vs AbsoluteSize=({size.X}, {size.Y}), TextWrapped={textObject.TextWrapped}`
	if not textObject.TextWrapped then
		Assert:fail(message)
	end
	Assert["true"](Assert, bounds.X <= size.X + 1 and bounds.Y <= size.Y + 1, message)
end
local function assertCenteredIn(child, parent, axis, tolerance, label)
	if tolerance == nil then
		tolerance = 1
	end
	if label == nil then
		label = ""
	end
	local childRect = rect(child)
	local parentRect = rect(parent)
	local prefix = if label ~= "" then `{label}: ` else ""
	if axis == "x" or axis == "both" then
		Assert["true"](Assert, math.abs(childRect.centerX - parentRect.centerX) <= tolerance, `{prefix}expected {describeGui(child)} {formatRect(childRect)} to be horizontally centered in {describeGui(parent)} {formatRect(parentRect)} (centerX {childRect.centerX} vs {parentRect.centerX}, tolerance {tolerance})`)
	end
	if axis == "y" or axis == "both" then
		Assert["true"](Assert, math.abs(childRect.centerY - parentRect.centerY) <= tolerance, `{prefix}expected {describeGui(child)} {formatRect(childRect)} to be vertically centered in {describeGui(parent)} {formatRect(parentRect)} (centerY {childRect.centerY} vs {parentRect.centerY}, tolerance {tolerance})`)
	end
end
local function assertSizeApprox(gui, expectedWidth, expectedHeight, tolerance, label)
	if tolerance == nil then
		tolerance = 1
	end
	if label == nil then
		label = ""
	end
	local guiRect = rect(gui)
	local prefix = if label ~= "" then `{label}: ` else ""
	if expectedWidth ~= nil then
		Assert["true"](Assert, math.abs(guiRect.width - expectedWidth) <= tolerance, `{prefix}expected {describeGui(gui)} width {guiRect.width} to be within {tolerance} of {expectedWidth}`)
	end
	if expectedHeight ~= nil then
		Assert["true"](Assert, math.abs(guiRect.height - expectedHeight) <= tolerance, `{prefix}expected {describeGui(gui)} height {guiRect.height} to be within {tolerance} of {expectedHeight}`)
	end
end
local function assertNonZeroSize(gui, label)
	local guiRect = rect(gui)
	Assert["true"](Assert, guiRect.width > 0 and guiRect.height > 0, `{label}: expected {describeGui(gui)} to have a non-zero AbsoluteSize, got {guiRect.width}x{guiRect.height}`)
end
local function assertMinSize(gui, minWidth, minHeight, label)
	local guiRect = rect(gui)
	if minWidth ~= nil then
		Assert["true"](Assert, guiRect.width >= minWidth, `{label}: expected {describeGui(gui)} width {guiRect.width} to be at least {minWidth}`)
	end
	if minHeight ~= nil then
		Assert["true"](Assert, guiRect.height >= minHeight, `{label}: expected {describeGui(gui)} height {guiRect.height} to be at least {minHeight}`)
	end
end
local function assertStackedVertically(children, label)
	for index = 1, #children - 1 do
		local above = children[index]
		local below = children[index + 1]
		local aboveRect = rect(above)
		local belowRect = rect(below)
		Assert["true"](Assert, aboveRect.bottom <= belowRect.top, `{label}: expected {describeGui(above)} {formatRect(aboveRect)} to end at or above the top of {describeGui(below)} {formatRect(belowRect)}`)
	end
end
local function assertStackedHorizontally(children, label)
	for index = 1, #children - 1 do
		local leading = children[index]
		local trailing = children[index + 1]
		local leadingRect = rect(leading)
		local trailingRect = rect(trailing)
		Assert["true"](Assert, leadingRect.right <= trailingRect.left, `{label}: expected {describeGui(leading)} {formatRect(leadingRect)} to end at or before the left edge of {describeGui(trailing)} {formatRect(trailingRect)}`)
	end
end
local function assertAlignedLeft(child, parent, tolerance, label)
	if tolerance == nil then
		tolerance = 1
	end
	if label == nil then
		label = ""
	end
	local childRect = rect(child)
	local parentRect = rect(parent)
	local prefix = if label ~= "" then `{label}: ` else ""
	Assert["true"](Assert, math.abs(childRect.left - parentRect.left) <= tolerance, `{prefix}expected {describeGui(child)} {formatRect(childRect)} to be left-aligned with {describeGui(parent)} {formatRect(parentRect)} (tolerance {tolerance})`)
end
local function assertAlignedRight(child, parent, tolerance, label)
	if tolerance == nil then
		tolerance = 1
	end
	if label == nil then
		label = ""
	end
	local childRect = rect(child)
	local parentRect = rect(parent)
	local prefix = if label ~= "" then `{label}: ` else ""
	Assert["true"](Assert, math.abs(childRect.right - parentRect.right) <= tolerance, `{prefix}expected {describeGui(child)} {formatRect(childRect)} to be right-aligned with {describeGui(parent)} {formatRect(parentRect)} (tolerance {tolerance})`)
end
local function assertAlignedTop(child, parent, tolerance, label)
	if tolerance == nil then
		tolerance = 1
	end
	if label == nil then
		label = ""
	end
	local childRect = rect(child)
	local parentRect = rect(parent)
	local prefix = if label ~= "" then `{label}: ` else ""
	Assert["true"](Assert, math.abs(childRect.top - parentRect.top) <= tolerance, `{prefix}expected {describeGui(child)} {formatRect(childRect)} to be top-aligned with {describeGui(parent)} {formatRect(parentRect)} (tolerance {tolerance})`)
end
return {
	mountInScreenGui = mountInScreenGui,
	withMounted = withMounted,
	waitForLayout = waitForLayout,
	waitForDescendant = waitForDescendant,
	waitForGuiObject = waitForGuiObject,
	findDescendant = findDescendant,
	findDescendantOfClass = findDescendantOfClass,
	rect = rect,
	formatRect = formatRect,
	describeGui = describeGui,
	assertContained = assertContained,
	assertAllDescendantsContained = assertAllDescendantsContained,
	assertNoSiblingOverlap = assertNoSiblingOverlap,
	assertTextFits = assertTextFits,
	assertCenteredIn = assertCenteredIn,
	assertSizeApprox = assertSizeApprox,
	assertNonZeroSize = assertNonZeroSize,
	assertMinSize = assertMinSize,
	assertStackedVertically = assertStackedVertically,
	assertStackedHorizontally = assertStackedHorizontally,
	assertAlignedLeft = assertAlignedLeft,
	assertAlignedRight = assertAlignedRight,
	assertAlignedTop = assertAlignedTop,
	STUDIO_SKIP_MESSAGE = STUDIO_SKIP_MESSAGE,
}
