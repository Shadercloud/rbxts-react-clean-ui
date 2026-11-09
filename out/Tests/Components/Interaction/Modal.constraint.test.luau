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
local Modal = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "Modal").Modal
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local ModalProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "modal.provider").ModalProvider
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local RegistryProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "registry.provider").RegistryProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local waitForWidth = _layout.waitForWidth
local withMounted = _layout.withMounted
local HOST_WIDTH = 800
local HOST_HEIGHT = 600
local function modalApp(modal)
	return React.createElement(RegistryProvider, nil, React.createElement(OverlayProvider, nil, React.createElement(ModalProvider, nil, modal)))
end
local ModalSizeConstraint
do
	ModalSizeConstraint = setmetatable({}, {
		__tostring = function()
			return "ModalSizeConstraint"
		end,
	})
	ModalSizeConstraint.__index = ModalSizeConstraint
	function ModalSizeConstraint.new(...)
		local self = setmetatable({}, ModalSizeConstraint)
		return self:constructor(...) or self
	end
	function ModalSizeConstraint:constructor()
	end
	function ModalSizeConstraint:noConstraintWhenUnset()
		withMounted(HOST_WIDTH, HOST_HEIGHT, modalApp(React.createElement(Modal, {
			open = true,
		}, React.createElement(Text, {
			text = "Body",
		}))), function(mounted)
			local shield = waitForGuiObject(mounted.host, "ModalPanelInputShield")
			Assert:equal(#sizeConstraintsOf(shield), 0)
		end)
	end
	function ModalSizeConstraint:shieldClamped()
		withMounted(HOST_WIDTH, HOST_HEIGHT, modalApp(React.createElement(Modal, {
			open = true,
			maxWidth = 240,
		}, React.createElement(Text, {
			text = "Body",
		}))), function(mounted)
			local shield = waitForGuiObject(mounted.host, "ModalPanelInputShield")
			local panel = waitForGuiObject(shield, "Modal")
			Assert:equal(soleSizeConstraint(shield).MaxSize.X, 240)
			waitForWidth(shield, 240)
			waitForWidth(panel, 240)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without min or max props the panel shield renders no UISizeConstraint")
	local _descriptor = Test(ModalSizeConstraint, "noConstraintWhenUnset", {
		value = ModalSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor then
		ModalSizeConstraint.noConstraintWhenUnset = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ModalSizeConstraint, "noConstraintWhenUnset", {
		value = ModalSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_1 then
		ModalSizeConstraint.noConstraintWhenUnset = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ModalSizeConstraint, "noConstraintWhenUnset", {
		value = ModalSizeConstraint.noConstraintWhenUnset,
	})
	if _descriptor_2 then
		ModalSizeConstraint.noConstraintWhenUnset = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("A maxWidth below the theme's modal width clamps the input shield and the panel Card together")
	local _descriptor_3 = Test(ModalSizeConstraint, "shieldClamped", {
		value = ModalSizeConstraint.shieldClamped,
	})
	if _descriptor_3 then
		ModalSizeConstraint.shieldClamped = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ModalSizeConstraint, "shieldClamped", {
		value = ModalSizeConstraint.shieldClamped,
	})
	if _descriptor_4 then
		ModalSizeConstraint.shieldClamped = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ModalSizeConstraint, "shieldClamped", {
		value = ModalSizeConstraint.shieldClamped,
	})
	if _descriptor_5 then
		ModalSizeConstraint.shieldClamped = _descriptor_5.value
	end
	ModalSizeConstraint = Tag("Studio")(ModalSizeConstraint) or ModalSizeConstraint
end
return ModalSizeConstraint
