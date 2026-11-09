import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Select } from "../../../Components/Input/Select";
import { STUDIO_SKIP_MESSAGE, assertSizeApprox, waitForGuiObject, withMounted } from "../../Helpers/layout";

const HOST_WIDTH = 400;

function widthSelect(width?: number) {
	return (
		<Select width={width}>
			<Select.Option text="Alpha" />
			<Select.Option text="Beta" />
		</Select>
	);
}

function waitForSelectWidth(host: Instance, expected: number): ImageLabel {
	return waitForGuiObject<ImageLabel>(
		host,
		"Select",
		(gui) => math.abs(gui.AbsoluteSize.X - expected) <= 1 && gui.AbsoluteSize.Y > 0,
		`Timed out waiting for the Select root to be ${expected}px wide`,
	);
}

@Tag("Studio")
class SelectWidthValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("width={200} pins the closed control to 200px while its height still hugs the content")
	@Test
	public fixedWidth() {
		withMounted(HOST_WIDTH, 200, widthSelect(200), (mounted) => {
			const selectRoot = waitForSelectWidth(mounted.host, 200);

			assertSizeApprox(selectRoot, 200, undefined, 1, "width=200 select");
			Assert.equal(selectRoot.AutomaticSize, Enum.AutomaticSize.Y);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without width the closed control stretches to the full width of its parent")
	@Test
	public fullWidthDefault() {
		withMounted(HOST_WIDTH, 200, widthSelect(), (mounted) => {
			const selectRoot = waitForSelectWidth(mounted.host, HOST_WIDTH);

			assertSizeApprox(selectRoot, HOST_WIDTH, undefined, 1, "unset width select");
		});
	}
}

export = SelectWidthValidation;
