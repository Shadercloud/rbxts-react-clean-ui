import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { HoverButton, HoverButtonContext } from "../../../Components/Input/HoverButton";
import { fireHostEvent } from "../../Helpers/fiber";
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
const BORDER_COLOR = Color3.fromRGB(40, 120, 220);
const HOVER_BORDER = Color3.fromRGB(240, 200, 40);

const DEFAULT_PROPS = {
	Size: UDim2.fromOffset(120, 40),
	BackgroundColor3: DEFAULT_COLOR,
	BackgroundTransparency: 0,
};

function waitForHoverButton(host: Instance, name = "HoverButton"): ImageButton {
	return waitForGuiObject<ImageButton>(host, name);
}

function strokeOf(button: Instance): UIStroke {
	const stroke = button.FindFirstChildWhichIsA("UIStroke");
	Assert.notUndefined(stroke, `Expected ${button.Name} to have a direct UIStroke child`);
	return stroke!;
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

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no border props anywhere the HoverButton renders no UIStroke")
	@Test
	public noStrokeByDefault() {
		withMounted(400, 200, <HoverButton default={DEFAULT_PROPS} />, (mounted) => {
			const button = waitForHoverButton(mounted.host);

			Assert.undefined(button.FindFirstChildWhichIsA("UIStroke"), "Expected no UIStroke without border props");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Top-level border props render a Stroke with that thickness, colour and transparency, drawn inside by default")
	@Test
	public topLevelBorder() {
		withMounted(
			400,
			200,
			<HoverButton default={DEFAULT_PROPS} borderThickness={2} borderColor={BORDER_COLOR} borderTransparency={0.5} />,
			(mounted) => {
				const stroke = strokeOf(waitForHoverButton(mounted.host));

				Assert.equal(stroke.Name, "Stroke");
				Assert.equal(stroke.Thickness, 2);
				Assert.equal(stroke.Color, BORDER_COLOR);
				Assert.equal(stroke.Transparency, 0.5);
				Assert.equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Border values inside the default state set override the top-level ones field by field")
	@Test
	public stateBorderWins() {
		withMounted(
			400,
			200,
			<HoverButton
				default={{ ...DEFAULT_PROPS, borderThickness: 3, borderColor: HOVER_BORDER }}
				borderThickness={1}
				borderColor={BORDER_COLOR}
				borderTransparency={0.25}
				borderPosition="outer"
			/>,
			(mounted) => {
				const stroke = strokeOf(waitForHoverButton(mounted.host));

				Assert.equal(stroke.Thickness, 3);
				Assert.equal(stroke.Color, HOVER_BORDER);
				Assert.equal(stroke.Transparency, 0.25);
				Assert.equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A hover set with only borderColor recolours the stroke on MouseEnter, keeps its thickness, and reverts on MouseLeave")
	@Test
	public hoverBorderColor() {
		withMounted(
			400,
			200,
			<HoverButton
				default={{ ...DEFAULT_PROPS, borderThickness: 2, borderColor: BORDER_COLOR }}
				hover={{ borderColor: HOVER_BORDER }}
			/>,
			(mounted) => {
				const button = waitForHoverButton(mounted.host);
				Assert.equal(strokeOf(button).Color, BORDER_COLOR);

				fireHostEvent(mounted, button, "MouseEnter", 0, 0);
				waitForLayout(
					() => (strokeOf(button).Color === HOVER_BORDER ? true : undefined),
					"Timed out waiting for the stroke to take the hover borderColor",
				);
				Assert.equal(strokeOf(button).Thickness, 2);

				fireHostEvent(mounted, button, "MouseLeave", 0, 0);
				waitForLayout(
					() => (strokeOf(button).Color === BORDER_COLOR ? true : undefined),
					"Timed out waiting for the stroke to revert to the default borderColor",
				);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A focus set can add a border that only appears while isSelected is true")
	@Test
	public focusAddsBorder() {
		const element = (selected: boolean) => (
			<HoverButton
				default={DEFAULT_PROPS}
				focus={{ borderThickness: 4, borderPosition: "outer" }}
				isSelected={selected}
			/>
		);

		withMounted(400, 200, element(true), (mounted) => {
			const button = waitForHoverButton(mounted.host);
			const stroke = strokeOf(button);

			Assert.equal(stroke.Thickness, 4);
			Assert.equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer);

			mounted.update(element(false));

			waitForLayout(
				() => (button.FindFirstChildWhichIsA("UIStroke") === undefined ? true : undefined),
				"Timed out waiting for the focus-only stroke to be removed after isSelected was cleared",
			);
		});
	}
}

export = HoverButtonMountValidation;
