import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { HoverButton, HoverButtonContext } from "../../../Components/Input/HoverButton";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertSizeApprox,
	findDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const DEFAULT_COLOR = Color3.fromRGB(10, 20, 30);
const FOCUS_COLOR = Color3.fromRGB(200, 40, 40);

const DEFAULT_PROPS = {
	Size: UDim2.fromOffset(120, 40),
	BackgroundColor3: DEFAULT_COLOR,
	BackgroundTransparency: 0,
};

function waitForHoverButton(host: Instance, name = "HoverButton"): ImageButton {
	return waitForGuiObject<ImageButton>(host, name);
}

function SelectionProbe() {
	const context = React.useContext(HoverButtonContext);
	const name = context === undefined ? "ProbeNoContext" : context.isSelected ? "ProbeSelected" : "ProbeUnselected";

	return <frame key={name} BackgroundTransparency={1} Size={UDim2.fromOffset(10, 10)} />;
}

@Tag("Studio")
class HoverButtonMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The default prop set is forwarded to the root ImageButton and its children stay inside it")
	@Test
	public mountsWithDefaultProps() {
		withMounted(
			400,
			200,
			<HoverButton default={DEFAULT_PROPS}>
				<frame key="Child" BackgroundTransparency={1} Size={UDim2.fromOffset(60, 20)} />
			</HoverButton>,
			(mounted) => {
				const button = waitForHoverButton(mounted.host);

				assertSizeApprox(button, 120, 40, 0, "default props");
				Assert.equal(button.BackgroundColor3, DEFAULT_COLOR);
				assertAllDescendantsContained(button, "default props");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("isSelected={true} layers the focus props over default, and clearing it falls back to default again")
	@Test
	public selectedUsesFocus() {
		withMounted(
			400,
			200,
			<HoverButton default={DEFAULT_PROPS} focus={{ BackgroundColor3: FOCUS_COLOR }} isSelected={true} />,
			(mounted) => {
				const button = waitForHoverButton(mounted.host);

				Assert.equal(button.BackgroundColor3, FOCUS_COLOR);
				assertSizeApprox(button, 120, 40, 0, "selected");

				mounted.update(
					<HoverButton default={DEFAULT_PROPS} focus={{ BackgroundColor3: FOCUS_COLOR }} isSelected={false} />,
				);

				waitForLayout(
					() => (button.BackgroundColor3 === DEFAULT_COLOR ? true : undefined),
					"Timed out waiting for the HoverButton to revert to its default BackgroundColor3 after isSelected was cleared",
				);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Children read the isSelected flag through HoverButtonContext and see it flip on re-render")
	@Test
	public contextReportsSelected() {
		withMounted(
			400,
			200,
			<HoverButton default={DEFAULT_PROPS}>
				<SelectionProbe />
			</HoverButton>,
			(mounted) => {
				const button = waitForHoverButton(mounted.host);
				findDescendant(button, "ProbeUnselected");

				mounted.update(
					<HoverButton default={DEFAULT_PROPS} isSelected={true}>
						<SelectionProbe />
					</HoverButton>,
				);

				waitForLayout(
					() => button.FindFirstChild("ProbeSelected"),
					"Timed out waiting for the probe to report isSelected=true after re-render",
				);
				Assert.undefined(button.FindFirstChild("ProbeUnselected"));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Passing a name prop renames the root ImageButton and no \"HoverButton\" child remains")
	@Test
	public customName() {
		withMounted(400, 200, <HoverButton name="TabTrigger" default={DEFAULT_PROPS} />, (mounted) => {
			waitForHoverButton(mounted.host, "TabTrigger");
			Assert.undefined(mounted.host.FindFirstChild("HoverButton", true));
		});
	}
}

export = HoverButtonMountValidation;
