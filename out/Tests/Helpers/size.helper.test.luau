-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "size.helper").SizeHelper
local _binding = Decorators
local Each = _binding.Each
local RADIUS_THEME = {
	radius = {
		sm = 3,
		md = 7,
		lg = 11,
		default = "md",
	},
}
local RadiusTokenResolution
do
	RadiusTokenResolution = setmetatable({}, {
		__tostring = function()
			return "RadiusTokenResolution"
		end,
	})
	RadiusTokenResolution.__index = RadiusTokenResolution
	function RadiusTokenResolution.new(...)
		local self = setmetatable({}, RadiusTokenResolution)
		return self:constructor(...) or self
	end
	function RadiusTokenResolution:constructor()
	end
	function RadiusTokenResolution:tokenResolves(token, expected)
		Assert:equal(SizeHelper:resolveRadius(RADIUS_THEME, token), expected)
	end
	function RadiusTokenResolution:sizePassesThrough(radius)
		Assert:equal(SizeHelper:resolveRadius(RADIUS_THEME, radius), radius)
	end
	function RadiusTokenResolution:undefinedStaysUnset()
		Assert:undefined(SizeHelper:resolveRadius(RADIUS_THEME, nil))
	end
	local _decorator = Each({ { "sm", 3 }, { "md", 7 }, { "lg", 11 } })
	local _decorator_1 = DisplayName("A radius token resolves to the matching entry of the theme's radius scale")
	local _descriptor = Test(RadiusTokenResolution, "tokenResolves", {
		value = RadiusTokenResolution.tokenResolves,
	})
	if _descriptor then
		RadiusTokenResolution.tokenResolves = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(RadiusTokenResolution, "tokenResolves", {
		value = RadiusTokenResolution.tokenResolves,
	})
	if _descriptor_1 then
		RadiusTokenResolution.tokenResolves = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(RadiusTokenResolution, "tokenResolves", {
		value = RadiusTokenResolution.tokenResolves,
	})
	if _descriptor_2 then
		RadiusTokenResolution.tokenResolves = _descriptor_2.value
	end
	local _decorator_2 = Each({ { 8 }, { 0 }, { "50%" }, { "12px" } })
	local _decorator_3 = DisplayName("A pixel or percent radius is returned unchanged so the caller's own parser still handles it")
	local _descriptor_3 = Test(RadiusTokenResolution, "sizePassesThrough", {
		value = RadiusTokenResolution.sizePassesThrough,
	})
	if _descriptor_3 then
		RadiusTokenResolution.sizePassesThrough = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(RadiusTokenResolution, "sizePassesThrough", {
		value = RadiusTokenResolution.sizePassesThrough,
	})
	if _descriptor_4 then
		RadiusTokenResolution.sizePassesThrough = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(RadiusTokenResolution, "sizePassesThrough", {
		value = RadiusTokenResolution.sizePassesThrough,
	})
	if _descriptor_5 then
		RadiusTokenResolution.sizePassesThrough = _descriptor_5.value
	end
	local _decorator_4 = DisplayName("An unset radius stays undefined instead of falling back to a theme value")
	local _descriptor_6 = Test(RadiusTokenResolution, "undefinedStaysUnset", {
		value = RadiusTokenResolution.undefinedStaysUnset,
	})
	if _descriptor_6 then
		RadiusTokenResolution.undefinedStaysUnset = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_4(RadiusTokenResolution, "undefinedStaysUnset", {
		value = RadiusTokenResolution.undefinedStaysUnset,
	})
	if _descriptor_7 then
		RadiusTokenResolution.undefinedStaysUnset = _descriptor_7.value
	end
	RadiusTokenResolution = Tag("Lune")(RadiusTokenResolution) or RadiusTokenResolution
end
return RadiusTokenResolution
