import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Tooltip } from "../../../Components/Interaction/Tooltip";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertCenteredIn,
	assertContained,
	findDescendant,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const CONTENT = "Helpful hint";

type HoverEvents = NonNullable<React.InstanceProps<Frame>["Event"]>;

let hoverEvents: HoverEvents | undefined;

const HoverTarget = React.forwardRef<Frame, React.InstanceProps<Frame>>((props, ref) => {
	hoverEvents = props.Event;

	return (
		<frame
			key="HoverTarget"
			ref={ref}
			BackgroundTransparency={1}
			Size={UDim2.fromOffset(100, 40)}
			Position={UDim2.fromOffset(150, 130)}
			Event={props.Event}
		/>
	);
});

function tooltipApp(placement?: "Top" | "Bottom") {
	return (
		<OverlayProvider>
			<Tooltip content={CONTENT} placement={placement}>
				<HoverTarget />
			</Tooltip>
		</OverlayProvider>
	);
}

function waitForTarget(host: Instance): Frame {
	waitForGuiObject<Frame>(host, "OverlayProvider");
	return waitForGuiObject<Frame>(host, "HoverTarget");
}

function hover(target: Frame) {
	const events = waitForLayout(() => hoverEvents, "Timed out waiting for Tooltip to inject hover handlers into HoverTarget");
	Assert.notUndefined(events.MouseEnter, "Expected Tooltip to inject a MouseEnter handler");
	events.MouseEnter!(target, 0, 0);
}

function unhover(target: Frame) {
	const events = waitForLayout(() => hoverEvents, "Timed out waiting for Tooltip to inject hover handlers into HoverTarget");
	Assert.notUndefined(events.MouseLeave, "Expected Tooltip to inject a MouseLeave handler");
	events.MouseLeave!(target, 0, 0);
}

function waitForRemoval(host: Instance, name: string) {
	for (let attempt = 0; attempt < 120; attempt++) {
		if (host.FindFirstChild(name, true) === undefined) return;
		task.wait();
	}

	Assert.fail(`Timed out waiting for "${name}" to be removed from ${host.GetFullName()}`);
}

@Tag("Studio")
class TooltipMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Before any hover the target is rendered but no Tooltip popup exists in the overlay")
	@Test
	public hiddenUntilHover() {
		hoverEvents = undefined;

		withMounted(400, 300, tooltipApp(), (mounted) => {
			waitForTarget(mounted.host);
			task.wait();

			Assert.undefined(mounted.host.FindFirstChild("Tooltip", true), "Expected no Tooltip popup before hovering");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["Top"],
		["Bottom"],
	])
	@DisplayName("Hovering the target portals a Tooltip into the overlay, centered on the target and on the requested side")
	@Test
	public showsOnHover(placement: "Top" | "Bottom") {
		hoverEvents = undefined;

		withMounted(400, 300, tooltipApp(placement), (mounted) => {
			const target = waitForTarget(mounted.host);
			hover(target);

			const overlay = findDescendant<Frame>(mounted.host, "OverlayProvider");
			const tooltip = waitForGuiObject<CanvasGroup>(overlay, "Tooltip");
			const content = waitForGuiObject<Frame>(tooltip, "Content");
			const text = findDescendant<TextLabel>(content, "TooltipText");

			Assert.equal(text.Text, CONTENT, "Expected a string content prop to render as TooltipText");
			assertContained(text, content, `${placement} tooltip text`);
			assertContained(tooltip, overlay, `${placement} tooltip vs overlay`);
			assertCenteredIn(tooltip, target, "x", 1, `${placement} tooltip`);

			const tooltipRect = rect(tooltip);
			const targetRect = rect(target);
			if (placement === "Top") {
				Assert.true(
					tooltipRect.bottom <= targetRect.top + 1,
					`Expected a Top tooltip (bottom=${tooltipRect.bottom}) to sit above the target (top=${targetRect.top})`,
				);
			} else {
				Assert.true(
					tooltipRect.top >= targetRect.bottom - 1,
					`Expected a Bottom tooltip (top=${tooltipRect.top}) to sit below the target (bottom=${targetRect.bottom})`,
				);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Leaving the target fades the Tooltip out and removes it from the overlay")
	@Test
	public hidesAfterLeave() {
		hoverEvents = undefined;

		withMounted(400, 300, tooltipApp(), (mounted) => {
			const target = waitForTarget(mounted.host);
			hover(target);
			waitForGuiObject<CanvasGroup>(mounted.host, "Tooltip");

			unhover(target);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}
}

export = TooltipMountValidation;
