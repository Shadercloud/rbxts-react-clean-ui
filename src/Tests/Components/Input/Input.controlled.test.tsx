import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Input } from "../../../Components/Input/Input";
import {
	MountedElement,
	STUDIO_SKIP_MESSAGE,
	findDescendant,
	settleFrames,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

type EchoMode = "defer" | "delay";

const ECHO_DELAY = 0.1;

function echoLater(mode: EchoMode, apply: () => void) {
	if (mode === "defer") {
		task.defer(apply);
	} else {
		task.delay(ECHO_DELAY, apply);
	}
}

function EchoParent(props: { mode: EchoMode }) {
	const [value, setValue] = React.useState("");

	return <Input controlled value={value} onChange={(text) => echoLater(props.mode, () => setValue(text))} />;
}

function BlurFormatParent() {
	const [value, setValue] = React.useState("4.00");

	return <Input controlled value={value} onChange={setValue} Event={{ FocusLost: () => setValue("4.00") }} />;
}

function waitForTextBox(mounted: MountedElement): TextBox {
	return findDescendant<TextBox>(waitForGuiObject<ImageLabel>(mounted.host, "Input"), "TextBox");
}

function focus(textBox: TextBox) {
	textBox.CaptureFocus();
	waitForLayout(() => (textBox.IsFocused() ? true : undefined), "Timed out waiting for CaptureFocus to focus the TextBox");
	settleFrames(2);
}

function blur(textBox: TextBox) {
	textBox.ReleaseFocus();
	waitForLayout(() => (!textBox.IsFocused() ? true : undefined), "Timed out waiting for ReleaseFocus to blur the TextBox");
}

function waitForText(textBox: TextBox, expected: string, message: string) {
	waitForLayout(() => (textBox.Text === expected ? true : undefined), `${message} (Text="${textBox.Text}")`);
}

@Tag("Studio")
class InputControlledValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["defer"], ["delay"]])
	@DisplayName("A parent echoing onChange late cannot overwrite what was typed while the controlled TextBox is focused")
	@Test
	public focusedKeepsTyping(mode: EchoMode) {
		withMounted(400, 200, <EchoParent mode={mode} />, (mounted) => {
			const textBox = waitForTextBox(mounted);

			focus(textBox);

			textBox.Text = "2";
			if (mode === "delay") task.wait();
			textBox.Text = "24";

			task.wait(ECHO_DELAY * 3);
			settleFrames(10);
			Assert.equal(textBox.Text, "24", `${mode}: expected the focused TextBox to keep the latest typed text`);

			blur(textBox);
			settleFrames(5);
			Assert.equal(textBox.Text, "24", `${mode}: expected the blurred TextBox to show the echoed value`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A parent that reformats value to 4.00 in FocusLost shows 4.00 once the TextBox loses focus")
	@Test
	public blurShowsFormatted() {
		withMounted(400, 200, <BlurFormatParent />, (mounted) => {
			const textBox = waitForTextBox(mounted);

			Assert.equal(textBox.Text, "4.00");

			focus(textBox);
			textBox.Text = "4";
			settleFrames(5);
			Assert.equal(textBox.Text, "4", "Expected the typed text while focused");

			blur(textBox);
			waitForText(textBox, "4.00", "Expected the TextBox to show the parent's reformatted value after FocusLost");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the controlled value while the TextBox is unfocused writes the new value into Text")
	@Test
	public unfocusedSyncsValue() {
		withMounted(400, 200, <Input controlled value="1" />, (mounted) => {
			const textBox = waitForTextBox(mounted);

			Assert.equal(textBox.Text, "1");

			mounted.update(<Input controlled value="2" />);
			waitForText(textBox, "2", "Expected the unfocused TextBox to follow the new value");

			mounted.update(<Input controlled value="" />);
			waitForText(textBox, "", "Expected the unfocused TextBox to follow an emptied value");
		});
	}
}

export = InputControlledValidation;
