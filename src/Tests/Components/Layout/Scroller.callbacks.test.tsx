import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Scroller } from "../../../Components/Layout/Scroller";
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForGuiObject, waitForLayout, withMounted } from "../../Helpers/layout";

const HOST_WIDTH = 300;
const HOST_HEIGHT = 150;
const TALL_HEIGHT = 600;
const THRESHOLD = 20;

interface ScrollLog {
	nearEnd: number;
	positions: number[];
	frames: ScrollingFrame[];
}

function newLog(): ScrollLog {
	return { nearEnd: 0, positions: [], frames: [] };
}

function trackedScroller(log: ScrollLog, childHeight: number) {
	return (
		<Scroller
			nearEndThreshold={THRESHOLD}
			onNearEnd={() => log.nearEnd++}
			onScroll={(position, frame) => {
				log.positions.push(position.Y);
				log.frames.push(frame);
			}}
		>
			<frame key="Content" Size={new UDim2(1, 0, 0, childHeight)} BackgroundTransparency={1} />
		</Scroller>
	);
}

function waitForCanvas(host: Instance, height: number): ScrollingFrame {
	return waitForGuiObject<ScrollingFrame>(
		host,
		"Scroller",
		(gui) => gui.AbsoluteCanvasSize.Y >= height && gui.AbsoluteWindowSize.Y > 0,
		`Timed out waiting for the canvas to reach ${height}px`,
	);
}

function endPosition(scroller: ScrollingFrame) {
	return scroller.AbsoluteCanvasSize.Y - scroller.AbsoluteWindowSize.Y;
}

function scrollTo(scroller: ScrollingFrame, y: number) {
	scroller.CanvasPosition = new Vector2(0, y);
	settleFrames(2);
}

@Tag("Studio")
class ScrollerScrollCallbacks {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Setting CanvasPosition from code calls onScroll with the new position and the ScrollingFrame")
	@Test
	public onScrollReports() {
		const log = newLog();

		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), (mounted) => {
			const scroller = waitForCanvas(mounted.host, TALL_HEIGHT);
			settleFrames(2);
			const before = log.positions.size();

			scrollTo(scroller, 40);

			Assert.true(log.positions.size() > before, "Expected onScroll to be called after CanvasPosition changed");
			Assert.equal(log.positions[log.positions.size() - 1], 40);
			Assert.equal(log.frames[log.frames.size() - 1], scroller);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("onNearEnd stays quiet outside the threshold and fires exactly once while the end stays within it")
	@Test
	public oncePerApproach() {
		const log = newLog();

		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), (mounted) => {
			const scroller = waitForCanvas(mounted.host, TALL_HEIGHT);
			const finish = endPosition(scroller);
			settleFrames(2);
			Assert.equal(log.nearEnd, 0, "Expected no near-end call while the end is far away");

			scrollTo(scroller, finish - THRESHOLD - 10);
			Assert.equal(log.nearEnd, 0, "Expected no near-end call just outside the threshold");

			scrollTo(scroller, finish - THRESHOLD + 5);
			Assert.equal(log.nearEnd, 1, "Expected one near-end call inside the threshold");

			scrollTo(scroller, finish - 5);
			scrollTo(scroller, finish);
			Assert.equal(log.nearEnd, 1, "Expected no repeat call while staying near the end");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Scrolling back out past the threshold re-arms onNearEnd for the next approach")
	@Test
	public rearmsScrollingAway() {
		const log = newLog();

		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), (mounted) => {
			const scroller = waitForCanvas(mounted.host, TALL_HEIGHT);
			const finish = endPosition(scroller);

			scrollTo(scroller, finish);
			Assert.equal(log.nearEnd, 1);

			scrollTo(scroller, 0);
			Assert.equal(log.nearEnd, 1, "Expected no call while scrolling away");

			scrollTo(scroller, finish);
			Assert.equal(log.nearEnd, 2, "Expected a second call on the second approach");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A canvas that grows while the end is still within the threshold fires onNearEnd again without scrolling")
	@Test
	public rearmsOnGrowth() {
		const log = newLog();

		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), (mounted) => {
			const scroller = waitForCanvas(mounted.host, TALL_HEIGHT);

			scrollTo(scroller, endPosition(scroller));
			Assert.equal(log.nearEnd, 1);

			mounted.update(trackedScroller(log, TALL_HEIGHT + 5));
			waitForLayout(
				() => (log.nearEnd >= 2 ? true : undefined),
				`Timed out waiting for onNearEnd to fire again after the canvas grew (calls ${log.nearEnd}, canvas ${scroller.AbsoluteCanvasSize.Y})`,
			);
			settleFrames(3);
			Assert.equal(log.nearEnd, 2, "Expected exactly one extra call for the growth");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Content that does not overflow counts as the end, so onNearEnd fires on mount")
	@Test
	public firesOnMountShort() {
		const log = newLog();

		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, 50), (mounted) => {
			waitForGuiObject<ScrollingFrame>(mounted.host, "Scroller");
			waitForLayout(
				() => (log.nearEnd >= 1 ? true : undefined),
				"Timed out waiting for onNearEnd to fire for short content",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A negative nearEndThreshold behaves like 0 and only fires at the very end")
	@Test
	public negativeThresholdZero() {
		let calls = 0;

		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Scroller nearEndThreshold={-50} onNearEnd={() => calls++}>
				<frame key="Content" Size={new UDim2(1, 0, 0, TALL_HEIGHT)} BackgroundTransparency={1} />
			</Scroller>,
			(mounted) => {
				const scroller = waitForCanvas(mounted.host, TALL_HEIGHT);
				const finish = endPosition(scroller);

				scrollTo(scroller, finish - 1);
				Assert.equal(calls, 0, "Expected no call one pixel before the end");

				scrollTo(scroller, finish);
				Assert.equal(calls, 1, "Expected a call at the very end");
			},
		);
	}
}

export = ScrollerScrollCallbacks;
