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
local _Toast = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "Toast")
local Toast = _Toast.Toast
local ToastContainer = _Toast.ToastContainer
local useToast = TS.import(script, script.Parent.Parent.Parent.Parent, "Contexts", "toast.context").useToast
local ToastProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "toast.provider").ToastProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertContained = _layout.assertContained
local findDescendant = _layout.findDescendant
local formatRect = _layout.formatRect
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local TITLE = "Saved"
local DESCRIPTION = "Your changes have been written to the datastore."
local latestController
local function ToastHarness()
	latestController = useToast()
	return nil
end
local function toastApp()
	return React.createElement(ToastProvider, nil, React.createElement(ToastHarness), React.createElement(ToastContainer))
end
local function waitForController()
	return waitForLayout(function()
		return latestController
	end, "Timed out waiting for ToastHarness to publish the ToastContext controller")
end
local function standaloneToast(dismissible)
	return React.createElement(Toast, {
		title = TITLE,
		description = DESCRIPTION,
		icon = "check",
		duration = math.huge,
		dismissible = dismissible,
		onDismiss = function() end,
	})
end
local ToastMountValidation
do
	ToastMountValidation = setmetatable({}, {
		__tostring = function()
			return "ToastMountValidation"
		end,
	})
	ToastMountValidation.__index = ToastMountValidation
	function ToastMountValidation.new(...)
		local self = setmetatable({}, ToastMountValidation)
		return self:constructor(...) or self
	end
	function ToastMountValidation:constructor()
	end
	function ToastMountValidation:rendersContentsContained()
		withMounted(400, 300, standaloneToast(true), function(mounted)
			local toast = waitForGuiObject(mounted.host, "Toast")
			local box = waitForGuiObject(toast, "ToastBox")
			local title = findDescendant(box, "ToastTitle")
			local description = findDescendant(box, "ToastDescription")
			local icon = findDescendant(box, "ToastIcon")
			local dismissButton = findDescendant(box, "ToastDismissButton")
			Assert:equal(title.Text, TITLE, "Expected the title prop to be rendered verbatim")
			Assert:equal(description.Text, DESCRIPTION, "Expected the description prop to be rendered verbatim")
			assertContained(box, toast, "box vs toast")
			assertContained(title, box, "title vs box")
			assertContained(description, box, "description vs box")
			assertContained(icon, box, "icon vs box")
			assertContained(dismissButton, box, "dismiss button vs box")
		end)
	end
	function ToastMountValidation:notDismissibleHidesButton()
		withMounted(400, 300, standaloneToast(false), function(mounted)
			local toast = waitForGuiObject(mounted.host, "Toast")
			findDescendant(toast, "ToastTitle")
			Assert:undefined(toast:FindFirstChild("ToastDismissButton", true), "Expected no ToastDismissButton when dismissible is false")
		end)
	end
	function ToastMountValidation:emptyContainerUnmounted()
		latestController = nil
		withMounted(400, 300, toastApp(), function(mounted)
			waitForController()
			task.wait()
			Assert:undefined(mounted.host:FindFirstChild("ToastContainer", true), "Expected ToastContainer to render nothing while the toast list is empty")
			Assert:undefined(mounted.host:FindFirstChild("Toast", true), "Expected no Toast while the toast list is empty")
		end)
	end
	function ToastMountValidation:showThenDismiss()
		latestController = nil
		withMounted(400, 300, toastApp(), function(mounted)
			local controller = waitForController()
			local id = controller.show({
				title = TITLE,
				duration = math.huge,
			})
			local container = waitForGuiObject(mounted.host, "ToastContainer", function(gui)
				return gui.AbsoluteSize.X > 0
			end, "Timed out waiting for ToastContainer to render with a non-zero width")
			local toast = waitForGuiObject(container, "Toast")
			local title = findDescendant(toast, "ToastTitle")
			Assert:equal(title.Text, TITLE, "Expected the shown toast to carry its title")
			local containerRect = rect(container)
			local toastRect = rect(toast)
			Assert["true"](Assert, toastRect.left >= containerRect.left - 1 and toastRect.right <= containerRect.right + 1, `Expected the Toast {formatRect(toastRect)} to stay within the ToastContainer's horizontal span {formatRect(containerRect)}`)
			assertContained(toast, mounted.host, "toast vs host")
			controller.dismiss(id)
			waitForLayout(function()
				return if mounted.host:FindFirstChild("Toast", true) == nil then true else nil
			end, "Timed out waiting for the dismissed Toast to unmount")
			Assert:undefined(mounted.host:FindFirstChild("ToastContainer", true), "Expected ToastContainer to unmount once its last toast was dismissed")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A standalone Toast renders its title, description, icon and dismiss button inside the ToastBox")
	local _descriptor = Test(ToastMountValidation, "rendersContentsContained", {
		value = ToastMountValidation.rendersContentsContained,
	})
	if _descriptor then
		ToastMountValidation.rendersContentsContained = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ToastMountValidation, "rendersContentsContained", {
		value = ToastMountValidation.rendersContentsContained,
	})
	if _descriptor_1 then
		ToastMountValidation.rendersContentsContained = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ToastMountValidation, "rendersContentsContained", {
		value = ToastMountValidation.rendersContentsContained,
	})
	if _descriptor_2 then
		ToastMountValidation.rendersContentsContained = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("dismissible={false} leaves the dismiss button out of the tree")
	local _descriptor_3 = Test(ToastMountValidation, "notDismissibleHidesButton", {
		value = ToastMountValidation.notDismissibleHidesButton,
	})
	if _descriptor_3 then
		ToastMountValidation.notDismissibleHidesButton = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ToastMountValidation, "notDismissibleHidesButton", {
		value = ToastMountValidation.notDismissibleHidesButton,
	})
	if _descriptor_4 then
		ToastMountValidation.notDismissibleHidesButton = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ToastMountValidation, "notDismissibleHidesButton", {
		value = ToastMountValidation.notDismissibleHidesButton,
	})
	if _descriptor_5 then
		ToastMountValidation.notDismissibleHidesButton = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("With no toasts queued the ToastContainer renders nothing")
	local _descriptor_6 = Test(ToastMountValidation, "emptyContainerUnmounted", {
		value = ToastMountValidation.emptyContainerUnmounted,
	})
	if _descriptor_6 then
		ToastMountValidation.emptyContainerUnmounted = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ToastMountValidation, "emptyContainerUnmounted", {
		value = ToastMountValidation.emptyContainerUnmounted,
	})
	if _descriptor_7 then
		ToastMountValidation.emptyContainerUnmounted = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ToastMountValidation, "emptyContainerUnmounted", {
		value = ToastMountValidation.emptyContainerUnmounted,
	})
	if _descriptor_8 then
		ToastMountValidation.emptyContainerUnmounted = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("show() mounts a Toast inside the ToastContainer and dismiss(id) removes it again")
	local _descriptor_9 = Test(ToastMountValidation, "showThenDismiss", {
		value = ToastMountValidation.showThenDismiss,
	})
	if _descriptor_9 then
		ToastMountValidation.showThenDismiss = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ToastMountValidation, "showThenDismiss", {
		value = ToastMountValidation.showThenDismiss,
	})
	if _descriptor_10 then
		ToastMountValidation.showThenDismiss = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ToastMountValidation, "showThenDismiss", {
		value = ToastMountValidation.showThenDismiss,
	})
	if _descriptor_11 then
		ToastMountValidation.showThenDismiss = _descriptor_11.value
	end
	ToastMountValidation = Tag("Studio")(ToastMountValidation) or ToastMountValidation
end
return ToastMountValidation
