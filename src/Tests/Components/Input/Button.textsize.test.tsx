import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Button } from "../../../Components/Input/Button";
import { TypographyHelper } from "../../../Helpers/typography.helper";
import { ScaleSize } from "../../../Interfaces";
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

function app(ignore: boolean, child: React.ReactElement) {
	return (
		<CleanUiProvider theme={DefaultTheme} toasts={false} ignorePreferredTextSize={ignore}>
			{child}
		</CleanUiProvider>
	);
}

function expectedSize(scale?: ScaleSize): number {
	const typography = TypographyHelper.getTypography(DefaultTheme, scale, DefaultTheme.components.button.typography);
	const size = TypographyHelper.toTextSize(typography.size);
	Assert.notUndefined(size, `Expected the button typography size ${typography.size.Name} to have a pixel size`);
	return size!;
}

function waitForButtonText(host: Instance): TextLabel {
	return waitForDescendant<TextLabel>(host, "ButtonText", () => true);
}

@Tag("Studio")
class ButtonPreferredTextSize {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch on, the button label is pinned to the button typography size for each scale")
	@Each([["xs"], ["md"], ["xl"]])
	@Test
	public pinsLabel(scale: ScaleSize) {
		withMounted(400, 200, app(true, <Button text="Save" scale={scale} />), (mounted) => {
			const label = waitForButtonText(mounted.host);
			settleFrames(1);

			const expected = expectedSize(scale);
			assertTextSizePinned(label, expected);
			Assert.equal(label.TextSize, expected, "Expected the pin to match the label's own TextSize");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch off, the button label is left unpinned")
	@Test
	public offNoPin() {
		withMounted(400, 200, app(false, <Button text="Save" />), (mounted) => {
			const label = waitForButtonText(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(label);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the button scale moves the pin on its label to the new size")
	@Test
	public tracksScale() {
		withMounted(400, 200, app(true, <Button text="Save" scale="xs" />), (mounted) => {
			const label = waitForButtonText(mounted.host);
			settleFrames(1);
			assertTextSizePinned(label, expectedSize("xs"));

			mounted.update(app(true, <Button text="Save" scale="xl" />));
			settleFrames(1);

			assertTextSizePinned(label, expectedSize("xl"));
		});
	}
}

export = ButtonPreferredTextSize;
