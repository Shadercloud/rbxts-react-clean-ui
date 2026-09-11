import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Toast, ToastContainer } from "../../../Components/Interaction/Toast";
import { ToastContextValue, useToast } from "../../../Contexts/toast.context";
import { ToastProvider } from "../../../Providers/toast.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertContained,
	findDescendant,
	formatRect,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const TITLE = "Saved";
const DESCRIPTION = "Your changes have been written to the datastore.";

let latestController: ToastContextValue | undefined;

function ToastHarness() {
	latestController = useToast();
	return undefined;
}

function toastApp() {
	return (
		<ToastProvider>
			<ToastHarness />
			<ToastContainer />
		</ToastProvider>
	);
}

function waitForController(): ToastContextValue {
	return waitForLayout(() => latestController, "Timed out waiting for ToastHarness to publish the ToastContext controller");
}

function standaloneToast(dismissible: boolean) {
	return (
		<Toast
			title={TITLE}
			description={DESCRIPTION}
			icon="check"
			duration={math.huge}
			dismissible={dismissible}
			onDismiss={() => {}}
		/>
	);
}

@Tag("Studio")
class ToastMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A standalone Toast renders its title, description, icon and dismiss button inside the ToastBox")
	@Test
	public rendersContentsContained() {
		withMounted(400, 300, standaloneToast(true), (mounted) => {
			const toast = waitForGuiObject<CanvasGroup>(mounted.host, "Toast");
			const box = waitForGuiObject<ImageLabel>(toast, "ToastBox");
			const title = findDescendant<TextLabel>(box, "ToastTitle");
			const description = findDescendant<TextLabel>(box, "ToastDescription");
			const icon = findDescendant<ImageLabel>(box, "ToastIcon");
			const dismissButton = findDescendant<GuiObject>(box, "ToastDismissButton");

			Assert.equal(title.Text, TITLE, "Expected the title prop to be rendered verbatim");
			Assert.equal(description.Text, DESCRIPTION, "Expected the description prop to be rendered verbatim");

			assertContained(box, toast, "box vs toast");
			assertContained(title, box, "title vs box");
			assertContained(description, box, "description vs box");
			assertContained(icon, box, "icon vs box");
			assertContained(dismissButton, box, "dismiss button vs box");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("dismissible={false} leaves the dismiss button out of the tree")
	@Test
	public notDismissibleHidesButton() {
		withMounted(400, 300, standaloneToast(false), (mounted) => {
			const toast = waitForGuiObject<CanvasGroup>(mounted.host, "Toast");
			findDescendant<TextLabel>(toast, "ToastTitle");

			Assert.undefined(
				toast.FindFirstChild("ToastDismissButton", true),
				"Expected no ToastDismissButton when dismissible is false",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no toasts queued the ToastContainer renders nothing")
	@Test
	public emptyContainerUnmounted() {
		latestController = undefined;

		withMounted(400, 300, toastApp(), (mounted) => {
			waitForController();
			task.wait();

			Assert.undefined(
				mounted.host.FindFirstChild("ToastContainer", true),
				"Expected ToastContainer to render nothing while the toast list is empty",
			);
			Assert.undefined(mounted.host.FindFirstChild("Toast", true), "Expected no Toast while the toast list is empty");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("show() mounts a Toast inside the ToastContainer and dismiss(id) removes it again")
	@Test
	public showThenDismiss() {
		latestController = undefined;

		withMounted(400, 300, toastApp(), (mounted) => {
			const controller = waitForController();

			const id = controller.show({ title: TITLE, duration: math.huge });

			const container = waitForGuiObject<ImageLabel>(
				mounted.host,
				"ToastContainer",
				(gui) => gui.AbsoluteSize.X > 0,
				"Timed out waiting for ToastContainer to render with a non-zero width",
			);
			const toast = waitForGuiObject<CanvasGroup>(container, "Toast");
			const title = findDescendant<TextLabel>(toast, "ToastTitle");

			Assert.equal(title.Text, TITLE, "Expected the shown toast to carry its title");

			const containerRect = rect(container);
			const toastRect = rect(toast);
			Assert.true(
				toastRect.left >= containerRect.left - 1 && toastRect.right <= containerRect.right + 1,
				`Expected the Toast ${formatRect(toastRect)} to stay within the ToastContainer's horizontal span ${formatRect(containerRect)}`,
			);
			assertContained(toast, mounted.host, "toast vs host");

			controller.dismiss(id);

			waitForLayout(
				() => (mounted.host.FindFirstChild("Toast", true) === undefined ? true : undefined),
				"Timed out waiting for the dismissed Toast to unmount",
			);
			Assert.undefined(
				mounted.host.FindFirstChild("ToastContainer", true),
				"Expected ToastContainer to unmount once its last toast was dismissed",
			);
		});
	}
}

export = ToastMountValidation;
