-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local HttpService = TS.import(script, TS.getModule(script, "@rbxts", "services")).HttpService
local GroupContext = React.createContext(nil)
local function useGroupElement(enabled)
	if not enabled then
		return nil
	end
	local context = React.useContext(GroupContext)
	local id = React.useRef(HttpService:GenerateGUID(false)).current
	local _result = context
	if _result ~= nil then
		_result = _result.removeElement
	end
	local removeElementRef = React.useRef(_result)
	local _result_1 = context
	if _result_1 ~= nil then
		_result_1 = _result_1.removeElement
	end
	removeElementRef.current = _result_1
	React.useEffect(function()
		return function()
			local _result_2 = removeElementRef.current
			if _result_2 ~= nil then
				_result_2(id)
			end
		end
	end, {})
	local _exp = function(size)
		local _result_2 = context
		if _result_2 ~= nil then
			_result_2.reportSize(id, size)
		end
	end
	local _result_2 = context
	if _result_2 ~= nil then
		_result_2 = _result_2.size
	end
	local reportSize = React.useCallback(_exp, { _result_2, id })
	local _object = {}
	local _left = "groupSize"
	local _result_3 = context
	if _result_3 ~= nil then
		_result_3 = _result_3.size
	end
	_object[_left] = _result_3
	_object.reportSize = reportSize
	return _object
end
return {
	useGroupElement = useGroupElement,
	GroupContext = GroupContext,
}
