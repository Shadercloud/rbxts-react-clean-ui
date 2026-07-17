-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local function GroupMeasurement(props)
	if not props.enabled then
		return props.children
	end
	return React.createElement("frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Change = {
			AbsoluteSize = function(instance)
				local _result = props.group
				if _result ~= nil then
					local _exp = instance.AbsoluteSize.X
					local _result_1 = props.padding
					if _result_1 ~= nil then
						_result_1 = _result_1.left
					end
					local _condition = _result_1
					if _condition == nil then
						_condition = 0
					end
					local _exp_1 = _exp + _condition
					local _result_2 = props.padding
					if _result_2 ~= nil then
						_result_2 = _result_2.right
					end
					local _condition_1 = _result_2
					if _condition_1 == nil then
						_condition_1 = 0
					end
					local _exp_2 = _exp_1 + _condition_1
					local _exp_3 = instance.AbsoluteSize.Y
					local _result_3 = props.padding
					if _result_3 ~= nil then
						_result_3 = _result_3.top
					end
					local _condition_2 = _result_3
					if _condition_2 == nil then
						_condition_2 = 0
					end
					local _exp_4 = _exp_3 + _condition_2
					local _result_4 = props.padding
					if _result_4 ~= nil then
						_result_4 = _result_4.bottom
					end
					local _condition_3 = _result_4
					if _condition_3 == nil then
						_condition_3 = 0
					end
					_result.reportSize(Vector2.new(_exp_2, _exp_4 + _condition_3))
				end
			end,
		},
	}, props.children)
end
return {
	GroupMeasurement = GroupMeasurement,
}
