import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { PinTextSize } from "../../../Components/Typography/PinTextSize";
import { useIgnorePreferredTextSize } from "../../../Contexts/textsize.context";
import { CleanUiProvider } from "../../../Providers/app.provider";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertTextSizeNotPinned,
	assertTextSizePinned,
	settleFrames,
	waitForDescendant,
	withMounted,
} from "../../Helpers/layout";

function pinnedLabel(size: number | undefined, enabled?: boolean) {
	return (
		<textlabel key="Label" Text="Pinned" TextSize={size ?? 14} Size={UDim2.fromOffset(100, 30)}>
			<PinTextSize size={size} enabled={enabled} />
		</textlabel>
	);
}

function SwitchLabel() {
	const enabled = useIgnorePreferredTextSize();

	return (
		<textlabel key="Label" Text="Switch" TextSize={20} Size={UDim2.fromOffset(100, 30)}>
			<PinTextSize size={20} enabled={enabled} />
		</textlabel>
	);
}

function waitForLabel(host: Instance): TextLabel {
	return waitForDescendant<TextLabel>(host, "Label", () => true);
}

@Tag("Studio")
class PinTextSizeStandalone {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A size renders one PinTextSize constraint with equal min and max at that size")
	@Each([[8], [18], [42]])
	@Test
	public pinsSize(size: number) {
		withMounted(300, 200, pinnedLabel(size), (mounted) => {
			assertTextSizePinned(waitForLabel(mounted.host), size);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Sizes outside Roblox's 1-100 text size range are clamped into it")
	@Each([
		[0, 1],
		[-5, 1],
		[150, 100],
	])
	@Test
	public clampsRange(size: number, expected: number) {
		withMounted(300, 200, pinnedLabel(size), (mounted) => {
			assertTextSizePinned(waitForLabel(mounted.host), expected);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An undefined size renders no constraint at all")
	@Test
	public undefinedSize() {
		withMounted(300, 200, pinnedLabel(undefined), (mounted) => {
			const label = waitForLabel(mounted.host);
			settleFrames(2);

			Assert.equal(label.GetChildren().size(), 0, "Expected the label to have no children");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("enabled={false} renders nothing and switching it back on adds the pin")
	@Test
	public enabledToggle() {
		withMounted(300, 200, pinnedLabel(18, false), (mounted) => {
			const label = waitForLabel(mounted.host);
			settleFrames(2);

			Assert.equal(label.GetChildren().size(), 0, "Expected no constraint while enabled is false");

			mounted.update(pinnedLabel(18, true));
			settleFrames(1);

			assertTextSizePinned(label, 18);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the size prop updates the existing constraint to the new size")
	@Test
	public tracksSize() {
		withMounted(300, 200, pinnedLabel(18), (mounted) => {
			const label = waitForLabel(mounted.host);
			assertTextSizePinned(label, 18);

			mounted.update(pinnedLabel(30));
			settleFrames(1);

			assertTextSizePinned(label, 30);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Gated by useIgnorePreferredTextSize, the pin is absent without a provider")
	@Test
	public hookDefaultsOff() {
		withMounted(300, 200, <SwitchLabel />, (mounted) => {
			const label = waitForLabel(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(label);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Gated by useIgnorePreferredTextSize, the pin follows CleanUiProvider's ignorePreferredTextSize")
	@Each([[true], [false]])
	@Test
	public hookFollowsProvider(ignore: boolean) {
		withMounted(
			300,
			200,
			<CleanUiProvider theme={DefaultTheme} toasts={false} ignorePreferredTextSize={ignore}>
				<SwitchLabel />
			</CleanUiProvider>,
			(mounted) => {
				const label = waitForLabel(mounted.host);
				settleFrames(2);

				if (ignore) {
					assertTextSizePinned(label, 20);
				} else {
					assertTextSizeNotPinned(label);
				}
			},
		);
	}
}

export = PinTextSizeStandalone;
