import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Input } from "../../../Components/Input/Input";
import { TypographyHelper } from "../../../Helpers/typography.helper";
import { ScaleSize } from "../../../Interfaces";
import { CleanUiProvider } from "../../../Providers/app.provider";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertTextSizeNotPinned,
	assertTextSizePinned,
	settleFrames,
	textSizeConstraintsOf,
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
	const typography = TypographyHelper.getTypography(DefaultTheme, scale, DefaultTheme.components.input.typography);
	const size = TypographyHelper.toTextSize(typography.size);
	Assert.notUndefined(size, `Expected the input typography size ${typography.size.Name} to have a pixel size`);
	return size!;
}

function waitForTextBox(host: Instance): TextBox {
	return waitForDescendant<TextBox>(host, "TextBox", () => true);
}

@Tag("Studio")
class InputPreferredTextSize {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch on, the TextBox is pinned to its resolved typography size for each scale")
	@Each([["xs"], ["sm"], ["md"], ["lg"], ["xl"]])
	@Test
	public pinsTextBox(scale: ScaleSize) {
		withMounted(400, 200, app(true, <Input value="Hello" scale={scale} />), (mounted) => {
			const box = waitForTextBox(mounted.host);
			settleFrames(1);

			const expected = expectedSize(scale);
			assertTextSizePinned(box, expected);
			Assert.equal(box.TextSize, expected, "Expected the pin to match the TextBox's own TextSize");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch off, the TextBox has no text size constraint")
	@Test
	public offNoPin() {
		withMounted(400, 200, app(false, <Input value="Hello" />), (mounted) => {
			const box = waitForTextBox(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(box);
			Assert.equal(textSizeConstraintsOf(box).size(), 0, "Expected no UITextSizeConstraint with the switch off");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the scale on a mounted Input moves the pin to the new size")
	@Test
	public tracksScale() {
		withMounted(400, 200, app(true, <Input value="Hello" scale="xs" />), (mounted) => {
			const box = waitForTextBox(mounted.host);
			settleFrames(1);
			assertTextSizePinned(box, expectedSize("xs"));

			mounted.update(app(true, <Input value="Hello" scale="xl" />));
			settleFrames(1);

			assertTextSizePinned(box, expectedSize("xl"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A TextScaled TextBox is not pinned even with the switch on")
	@Test
	public scaledSkipped() {
		withMounted(400, 200, app(true, <Input value="Hello" TextScaled={true} />), (mounted) => {
			const box = waitForTextBox(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(box);
		});
	}
}

export = InputPreferredTextSize;
