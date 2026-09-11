import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { BarChart, BarChartData } from "../../../Components/Chart/BarChart";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertContained,
	assertStackedHorizontally,
	findDescendant,
	rect,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const VALUES = [10, 30, 20];
const MAX_INDEX = 1;

const DATA: BarChartData = {
	labels: ["A", "B", "C"],
	datasets: [{ values: VALUES }],
};

function waitForBarsToSettle(host: Instance): { barsContainer: ImageLabel; bars: ImageLabel[] } {
	const barsContainer = waitForGuiObject<ImageLabel>(host, "BarsContainer");

	task.wait(DefaultTheme.components.charts.bar.tweenTime + 0.25);

	waitForGuiObject<ImageLabel>(
		findDescendant(barsContainer, `BarGroup-${MAX_INDEX}`),
		"Segment-0",
		(segment) => math.abs(segment.AbsoluteSize.Y - barsContainer.AbsoluteSize.Y) <= 1,
		"Timed out waiting for the max-value bar to finish its mount animation and fill the chart height",
	);

	const bars = VALUES.map((_, index) => findDescendant<ImageLabel>(findDescendant(barsContainer, `BarGroup-${index}`), "Segment-0"));

	return { barsContainer, bars };
}

@Tag("Studio")
class BarChartMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Renders exactly one BarGroup (each with a Segment-0) per label in the data")
	@Test
	public oneBarPerDataPoint() {
		withMounted(400, 300, <BarChart data={DATA} />, (mounted) => {
			const barsContainer = waitForGuiObject<ImageLabel>(mounted.host, "BarsContainer");

			for (let index = 0; index < VALUES.size(); index++) {
				const group = findDescendant<ImageLabel>(barsContainer, `BarGroup-${index}`);
				findDescendant<ImageLabel>(group, "Segment-0");
			}

			Assert.undefined(
				barsContainer.FindFirstChild(`BarGroup-${VALUES.size()}`, true),
				`Expected no BarGroup-${VALUES.size()} for a chart with ${VALUES.size()} labels`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("After the mount animation, the bar for the maximum value is the tallest and fills the chart height")
	@Test
	public tallestBarMatchesMax() {
		withMounted(400, 300, <BarChart data={DATA} />, (mounted) => {
			const { barsContainer, bars } = waitForBarsToSettle(mounted.host);
			const maxBar = bars[MAX_INDEX];

			Assert.approximately(rect(maxBar).height, rect(barsContainer).height, 1);

			for (let index = 0; index < bars.size(); index++) {
				if (index === MAX_INDEX) continue;

				Assert.greaterThan(
					rect(maxBar).height,
					rect(bars[index]).height,
					`Expected the max-value bar (value ${VALUES[MAX_INDEX]}) to be taller than the bar for value ${VALUES[index]}`,
				);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Bar groups stay inside the BarsContainer and are laid out left-to-right in data order")
	@Test
	public barsContainedAndOrdered() {
		withMounted(400, 300, <BarChart data={DATA} />, (mounted) => {
			const { barsContainer, bars } = waitForBarsToSettle(mounted.host);

			const groups = VALUES.map((_, index) => findDescendant<ImageLabel>(barsContainer, `BarGroup-${index}`));

			for (let index = 0; index < groups.size(); index++) {
				assertContained(groups[index], barsContainer, `bar group ${index}`);
				assertContained(bars[index], barsContainer, `bar segment ${index}`);
			}

			assertStackedHorizontally(groups, "bar groups");
		});
	}
}

export = BarChartMountValidation;
