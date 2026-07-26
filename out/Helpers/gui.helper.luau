-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local GuiHelper
do
	GuiHelper = setmetatable({}, {
		__tostring = function()
			return "GuiHelper"
		end,
	})
	GuiHelper.__index = GuiHelper
	function GuiHelper.new(...)
		local self = setmetatable({}, GuiHelper)
		return self:constructor(...) or self
	end
	function GuiHelper:constructor()
	end
	function GuiHelper:findHighestAncestorOfClass(instance, className)
		local current = instance
		local highest
		while current do
			if current:IsA(className) then
				highest = current
			end
			current = current.Parent
		end
		return highest
	end
	function GuiHelper:printParentTree(instance)
		local current = instance
		while current ~= nil do
			print(`{current.ClassName}: {current.Name}`)
			current = current.Parent
		end
	end
	function GuiHelper:isPointInsideGuiObject(guiObject, point)
		local position = guiObject.AbsolutePosition
		local size = guiObject.AbsoluteSize
		return point.X >= position.X and point.X <= position.X + size.X and point.Y >= position.Y and point.Y <= position.Y + size.Y
	end
	function GuiHelper:getGuiObjectsAtPosition(instance, point)
		local root = self:findHighestAncestorOfClass(instance, "Frame")
		if root == nil then
			return {}
		end
		local results = {}
		for _, descendant in root:GetDescendants() do
			if descendant:IsA("GuiObject") and descendant.Visible and self:isPointInsideGuiObject(descendant, point) then
				table.insert(results, descendant)
			end
		end
		table.sort(results, function(a, b)
			return a.ZIndex > b.ZIndex
		end)
		return results
	end
	function GuiHelper:getGuiRenderOrder(instance)
		local result = {}
		for _, surface in self:getRenderSurfaces(self:getGuiRoot(instance)) do
			self:appendGuiObjects(surface.root, result)
		end
		return result
	end
	function GuiHelper:getGuiRoot(instance)
		if RunService:IsRunning() then
			return Players.LocalPlayer:WaitForChild("PlayerGui")
		end
		local r = self:findHighestAncestorOfClass(instance, "PluginGuiService")
		if r == nil then
			error(`No root`)
		end
		return r
	end
	function GuiHelper:getRenderSurfaces(root)
		local surfaces = {}
		local visit
		visit = function(instance)
			for index, child in ipairs(instance:GetChildren()) do
				if child:IsA("LayerCollector") then
					local _arg0 = {
						root = child,
						rootIndex = index,
					}
					table.insert(surfaces, _arg0)
					-- Don't recurse into another render surface.
					continue
				end
				visit(child)
			end
		end
		visit(root)
		table.sort(surfaces, function(a, b)
			if a.root:IsA("ScreenGui") and b.root:IsA("ScreenGui") then
				if a.root.DisplayOrder ~= b.root.DisplayOrder then
					return a.root.DisplayOrder < b.root.DisplayOrder
				end
			end
			return a.rootIndex < b.rootIndex
		end)
		return surfaces
	end
	function GuiHelper:appendGuiObjects(parent, result)
		local children = {}
		for index, child in ipairs(parent:GetChildren()) do
			if not child:IsA("GuiObject") then
				continue
			end
			local _arg0 = {
				object = child,
				siblingIndex = index,
			}
			table.insert(children, _arg0)
		end
		table.sort(children, function(a, b)
			if a.object.ZIndex ~= b.object.ZIndex then
				return a.object.ZIndex < b.object.ZIndex
			end
			-- Preserve sibling order.
			return a.siblingIndex < b.siblingIndex
		end)
		for _, child in children do
			-- Parent renders before its children.
			local _result = result
			local _object = child.object
			table.insert(_result, _object)
			self:appendGuiObjects(child.object, result)
		end
	end
end
return {
	GuiHelper = GuiHelper,
}
