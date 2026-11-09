import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Switch, SwitchProps } from "../../../Components/Input/Switch";
import { FieldsetContext } from "../../../Components/Layout";
import { SizeHelper } from "../../../Helpers";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, extendTheme } from "../../../Theme";
import { activateButton } from "../../Helpers/fiber";
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForGuiObject, waitForLayout, withMounted } from "../../Helpers/layout";

const SNAP_THEME = extendTheme(DefaultTheme, { components: { switch: { animation: { duration: 0 } } } });

const switchTheme = SNAP_THEME.components.switch;
const inset = SizeHelper.toUDim(switchTheme.thumb.inset).Offset;
const THUMB_OFF_X = inset;
const THUMB_ON_X =
	SizeHelper.toUDim(switchTheme.width).Offset - inset - (SizeHelper.toUDim(switchTheme.height).Offset - inset * 2);

function snapSwitch(props: SwitchProps) {
	return (
		<ThemeProvider theme={SNAP_THEME}>
			<Switch {...props} />
		</ThemeProvider>
	);
}

function recorder(values: boolean[]) {
	return (value: boolean) => {
		values.push(value);
	};
}

function checkedFor(label: string): boolean | undefined {
	return label === "on" ? true : label === "off" ? false : undefined;
}

function waitForSwitch(host: Instance, name = "Switch"): ImageButton {
	return waitForGuiObject<ImageButton>(host, name);
}

function assertThumb(track: Instance, on: boolean, label: string) {
	const thumb = track.FindFirstChild("Thumb") as Frame | undefined;
	Assert.notUndefined(thumb, `${label}: expected a Thumb frame inside the track`);

	const expected = on ? THUMB_ON_X : THUMB_OFF_X;
	Assert.true(
		math.abs(thumb!.Position.X.Offset - expected) <= 0.5,
		`${label}: expected the thumb ${on ? "on" : "off"} at X offset ${expected}, got ${thumb!.Position.X.Offset}`,
	);
}

@Tag("Studio")
class SwitchMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["on"], ["off"], ["unset"]])
	@DisplayName("Mounting never calls onChange, whether checked is true, false or left unset")
	@Test
	public silentMount(label: string) {
		const values: boolean[] = [];
		const checked = checkedFor(label);

		withMounted(200, 100, snapSwitch({ checked, onChange: recorder(values) }), (mounted) => {
			const track = waitForSwitch(mounted.host);
			settleFrames(3);

			Assert.deepEqual(values, [], `${label}: expected no onChange on mount`);
			assertThumb(track, checked === true, label);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An uncontrolled switch with defaultChecked starts on without calling onChange")
	@Test
	public defaultCheckedSeeds() {
		const values: boolean[] = [];

		withMounted(200, 100, snapSwitch({ defaultChecked: true, onChange: recorder(values) }), (mounted) => {
			const track = waitForSwitch(mounted.host);
			settleFrames(3);

			Assert.deepEqual(values, []);
			assertThumb(track, true, "defaultChecked");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Clicking a controlled switch reports the flipped value but the thumb waits for the prop to change")
	@Test
	public controlledClickReports() {
		const values: boolean[] = [];

		withMounted(200, 100, snapSwitch({ checked: false, onChange: recorder(values) }), (mounted) => {
			const track = waitForSwitch(mounted.host);

			activateButton(mounted, track);
			settleFrames(3);

			Assert.deepEqual(values, [true]);
			assertThumb(track, false, "after click, before the prop changes");

			mounted.update(snapSwitch({ checked: true, onChange: recorder(values) }));
			settleFrames(2);

			assertThumb(track, true, "after the prop changes");
			Assert.deepEqual(values, [true], "Expected the prop change not to call onChange");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Flipping a controlled checked prop moves the thumb without calling onChange")
	@Test
	public propChangeSilent() {
		const values: boolean[] = [];

		withMounted(200, 100, snapSwitch({ checked: false, onChange: recorder(values) }), (mounted) => {
			const track = waitForSwitch(mounted.host);

			mounted.update(snapSwitch({ checked: true, onChange: recorder(values) }));
			settleFrames(2);
			assertThumb(track, true, "checked prop on");

			mounted.update(snapSwitch({ checked: false, onChange: recorder(values) }));
			settleFrames(2);
			assertThumb(track, false, "checked prop off");

			Assert.deepEqual(values, []);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Clicking an uncontrolled switch flips its own state and reports each new value")
	@Test
	public uncontrolledClickToggles() {
		const values: boolean[] = [];

		withMounted(200, 100, snapSwitch({ onChange: recorder(values) }), (mounted) => {
			const track = waitForSwitch(mounted.host);

			activateButton(mounted, track);
			settleFrames(1);
			Assert.deepEqual(values, [true]);
			assertThumb(track, true, "after first click");

			activateButton(mounted, track);
			settleFrames(1);
			Assert.deepEqual(values, [true, false]);
			assertThumb(track, false, "after second click");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Firing the Fieldset labelActivated event turns an uncontrolled switch on and reports true")
	@Test
	public fieldsetLabelToggles() {
		const labelActivated = new Instance("BindableEvent");
		const values: boolean[] = [];

		try {
			withMounted(
				200,
				100,
				<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
					{snapSwitch({ onChange: recorder(values) })}
				</FieldsetContext.Provider>,
				(mounted) => {
					const track = waitForSwitch(mounted.host);
					settleFrames(2);

					labelActivated.Fire();

					waitForLayout(
						() => (values.size() >= 1 ? true : undefined),
						"Timed out waiting for onChange to fire after labelActivated",
					);
					settleFrames(1);

					Assert.deepEqual(values, [true]);
					assertThumb(track, true, "after labelActivated");
				},
			);
		} finally {
			labelActivated.Destroy();
		}
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A disabled switch ignores both a click and the Fieldset labelActivated event")
	@Test
	public disabledBlocksToggle() {
		const labelActivated = new Instance("BindableEvent");
		const values: boolean[] = [];

		try {
			withMounted(
				200,
				100,
				<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
					{snapSwitch({ disabled: true, onChange: recorder(values) })}
				</FieldsetContext.Provider>,
				(mounted) => {
					const track = waitForSwitch(mounted.host);

					activateButton(mounted, track);
					labelActivated.Fire();
					settleFrames(5);

					Assert.deepEqual(values, []);
					assertThumb(track, false, "disabled after click and label");
				},
			);
		} finally {
			labelActivated.Destroy();
		}
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A disabled switch renders its track ImageButton with Active and Selectable both false")
	@Test
	public disabledTrackInert() {
		withMounted(200, 100, snapSwitch({ disabled: true }), (mounted) => {
			const track = waitForSwitch(mounted.host);

			Assert.false(track.Active);
			Assert.false(track.Selectable);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("LayoutOrder reaches the root track, and leaving it unset keeps the engine default of 0")
	@Test
	public layoutOrderForwarded() {
		withMounted(200, 100, snapSwitch({ LayoutOrder: 3 }), (mounted) => {
			Assert.equal(waitForSwitch(mounted.host).LayoutOrder, 3);

			mounted.update(snapSwitch({}));
			Assert.equal(waitForSwitch(mounted.host).LayoutOrder, 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The root instance is named \"Switch\" when no name prop is given")
	@Test
	public defaultName() {
		withMounted(200, 100, snapSwitch({}), (mounted) => {
			Assert.notUndefined(mounted.host.FindFirstChild("Switch"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Passing a name prop renames the root instance and no \"Switch\" child remains")
	@Test
	public customName() {
		withMounted(200, 100, snapSwitch({ name: "MarketingOptIn" }), (mounted) => {
			waitForSwitch(mounted.host, "MarketingOptIn");
			Assert.undefined(mounted.host.FindFirstChild("Switch"));
		});
	}
}

export = SwitchMountValidation;
