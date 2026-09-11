import React from "@rbxts/react";
import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Column } from "../../../Components/Layout/Column";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertSizeApprox,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 300;
const CONTENT_HEIGHT = 40;

function column(span?: number | `${number}`) {
	return (
		<Column span={span}>
			<frame key="ColumnContent" BackgroundTransparency={1} Size={new UDim2(1, 0, 0, CONTENT_HEIGHT)} />
		</Column>
	);
}

function waitForColumn(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "Column");
}

@Tag("Studio")
class ColumnMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without a span or an enclosing Row, the Column resolves to span 12 and fills the host width")
	@Test
	public fullWidthByDefault() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, column(), (mounted) => {
			const col = waitForColumn(mounted.host);

			assertSizeApprox(col, HOST_WIDTH, undefined, 1, "default span");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[3, 100],
		["6", 200],
		[12, 400],
	])
	@DisplayName("Numeric and numeric-string spans size the Column to span/12 of the host width")
	@Test
	public spanFraction(span: number | `${number}`, expectedWidth: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, column(span), (mounted) => {
			const col = waitForColumn(mounted.host);

			assertSizeApprox(col, expectedWidth, undefined, 1, `span=${span}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The Column grows to its content's height and keeps that content inside its rect")
	@Test
	public autoHeightFromContent() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, column(6), (mounted) => {
			const col = waitForGuiObject<Frame>(
				mounted.host,
				"Column",
				(gui) => gui.AbsoluteSize.Y >= CONTENT_HEIGHT,
				`Timed out waiting for the Column to grow to its ${CONTENT_HEIGHT}px content`,
			);

			assertSizeApprox(col, undefined, CONTENT_HEIGHT, 1, "auto height");
			assertAllDescendantsContained(col, "auto height");
		});
	}
}

export = ColumnMountValidation;
