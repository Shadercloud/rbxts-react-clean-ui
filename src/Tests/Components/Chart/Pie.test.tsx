import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Pie } from "../../../Components/Chart/Pie";
import {
	STUDIO_SKIP_MESSAGE,
	assertContained,
	assertNonZeroSize,
	findDescendant,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const VALUES = [
	{ value: 25, label: "Alpha" },
	{ value: 25, label: "Beta" },
	{ value: 50, label: "Gamma" },
];

function getWedges(hitArea: Instance): Frame[] {
	const wedges: Frame[] = [];
	for (const child of hitArea.GetChildren()) {
		if (child.IsA("Frame") && child.Name === "SegmentWedge") wedges.push(child);
	}
	return wedges;
}

function waitForHitArea(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "HitArea");
}

@Tag("Studio")
class PieMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Mounts a Pie root with a non-zero size and exactly one SegmentWedge (with a SegmentFill) per value")
	@Test
	public slicePerDataPoint() {
		withMounted(300, 300, <Pie values={VALUES} />, (mounted) => {
			const pie = waitForGuiObject<Frame>(mounted.host, "Pie");
			assertNonZeroSize(pie, "mounted pie");

			const wedges = getWedges(waitForHitArea(pie));
			Assert.equal(wedges.size(), VALUES.size(), `Expected one SegmentWedge per value, got ${wedges.size()} for ${VALUES.size()} values`);

			for (const wedge of wedges) {
				findDescendant<Frame>(wedge, "SegmentFill");
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The Pie root renders as a plain Frame rather than an off-screen CanvasGroup")
	@Test
	public rootIsFrame() {
		withMounted(300, 300, <Pie values={VALUES} />, (mounted) => {
			const pie = waitForGuiObject<GuiObject>(mounted.host, "Pie");
			Assert.equal(pie.ClassName, "Frame", `Expected the Pie root to be a Frame, got ${pie.ClassName}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The HitArea stays inside the Pie root and every SegmentWedge stays inside the HitArea")
	@Test
	public slicesContained() {
		withMounted(300, 300, <Pie values={VALUES} />, (mounted) => {
			const pie = waitForGuiObject<Frame>(mounted.host, "Pie");
			const hitArea = waitForHitArea(pie);

			assertContained(hitArea, pie, "hit area");

			const wedges = getWedges(hitArea);
			for (let index = 0; index < wedges.size(); index++) {
				assertContained(wedges[index], hitArea, `wedge ${index}`);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("String labels render one PieLabel-N frame per value, each with text and inside the Pie root")
	@Test
	public labelPerValue() {
		withMounted(300, 300, <Pie values={VALUES} />, (mounted) => {
			const pie = waitForGuiObject<Frame>(mounted.host, "Pie");

			for (let index = 0; index < VALUES.size(); index++) {
				const label = waitForGuiObject<Frame>(pie, `PieLabel-${index}`);
				const text = findDescendant<TextLabel>(label, "PieLabelText");

				Assert.equal(text.Text, VALUES[index].label, `Expected PieLabel-${index} to show "${VALUES[index].label}"`);
				assertContained(label, pie, `pie label ${index}`);
			}
		});
	}
}

export = PieMountValidation;
