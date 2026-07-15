-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local Box = TS.import(script, script.Parent, "Box").Box
local VStack = TS.import(script, script.Parent.Parent, "Layout", "VStack").VStack
local Panel
do
	local super = Component
	Panel = setmetatable({}, {
		__tostring = function()
			return "Panel"
		end,
		__index = super,
	})
	Panel.__index = Panel
	function Panel.new(...)
		local self = setmetatable({}, Panel)
		return self:constructor(...) or self
	end
	function Panel:constructor(...)
		super.constructor(self, ...)
	end
	function Panel:render()
		return React.createElement(Box, nil, React.createElement(VStack))
	end
	Panel = ReactComponent(Panel) or Panel
end
return {
	Panel = Panel,
}
