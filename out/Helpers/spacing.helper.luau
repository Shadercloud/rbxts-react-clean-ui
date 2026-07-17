-- Compiled with roblox-ts v3.0.0
local SpacingHelper
do
	SpacingHelper = setmetatable({}, {
		__tostring = function()
			return "SpacingHelper"
		end,
	})
	SpacingHelper.__index = SpacingHelper
	function SpacingHelper.new(...)
		local self = setmetatable({}, SpacingHelper)
		return self:constructor(...) or self
	end
	function SpacingHelper:constructor()
	end
	function SpacingHelper:GetResolvedPadding(theme, props)
		local amount = self:GetPadding(theme, props.spacing)
		return {
			top = if props.top then self:GetPadding(theme, props.top) else amount,
			bottom = if props.bottom then self:GetPadding(theme, props.bottom) else amount,
			left = if props.left then self:GetPadding(theme, props.left) else amount,
			right = if props.right then self:GetPadding(theme, props.right) else amount,
		}
	end
	function SpacingHelper:GetPadding(theme, spacing)
		if spacing == "None" then
			return 0
		end
		local resolveSpacing = if spacing ~= nil then spacing else theme.default.spacing
		local _condition = theme.spacing[resolveSpacing]
		if _condition == nil then
			_condition = 0
		end
		return _condition
	end
end
return {
	SpacingHelper = SpacingHelper,
}
