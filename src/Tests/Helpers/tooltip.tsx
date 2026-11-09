import React from "@rbxts/react";
import { Assert } from "@rbxts/lunit";

import { Tooltip } from "../../Components/Interaction/Tooltip";
import { TooltipPlacement } from "../../Components/Interaction/Tooltip.placement";
import { OverlayProvider } from "../../Providers/overlay.provider";
import { ThemeProvider } from "../../Providers/theme.provider";
import { DefaultTheme, extendTheme } from "../../Theme";
import { settleFrames, waitForGuiObject } from "./layout";

export const FAST_TOOLTIP = {
	fadeDuration: 0.05,
	closeDelay: 0.1,
	longPressDelay: 0.2,
};

export const FAST_THEME = extendTheme(DefaultTheme, { components: { tooltip: FAST_TOOLTIP } });

export const HOLD_SECONDS = 0.3;

export type TooltipTheme = typeof DefaultTheme;

const CONTENT = "Helpful hint";

export function assertNoPopup(host: Instance, message: string, name = "Tooltip") {
	settleFrames(10);
	Assert.undefined(host.FindFirstChild(name, true), message);
}

export interface TipOptions {
	name?: string;
	trigger?: string;
	content?: React.ReactNode | string;
	placement?: TooltipPlacement;
	position?: UDim2;
	open?: boolean;
	disabled?: boolean;
	interactive?: boolean;
	pinOnPress?: boolean;
	longPress?: boolean;
}

export function tip(options: TipOptions = {}) {
	const trigger = options.trigger ?? "Trigger";

	return (
		<Tooltip
			key={trigger}
			name={options.name}
			content={options.content ?? CONTENT}
			placement={options.placement}
			open={options.open}
			disabled={options.disabled}
			interactive={options.interactive}
			pinOnPress={options.pinOnPress}
			longPress={options.longPress}
		>
			<frame
				key={trigger}
				BackgroundTransparency={1}
				Size={UDim2.fromOffset(100, 40)}
				Position={options.position ?? UDim2.fromOffset(150, 130)}
			/>
		</Tooltip>
	);
}

export function tipApp(options: TipOptions = {}, theme: TooltipTheme = FAST_THEME) {
	return (
		<ThemeProvider theme={theme}>
			<OverlayProvider>{tip(options)}</OverlayProvider>
		</ThemeProvider>
	);
}

export function coverApp(cover: TipOptions, under: TipOptions = {}) {
	return (
		<ThemeProvider theme={FAST_THEME}>
			<OverlayProvider>
				{tip({ name: "CoverTip", trigger: "CoverTrigger", position: UDim2.fromOffset(20, 20), ...cover })}
				{tip({ name: "UnderTip", trigger: "UnderTrigger", position: UDim2.fromOffset(150, 200), ...under })}
			</OverlayProvider>
		</ThemeProvider>
	);
}

export type ParentMode = "plain" | "interactive" | "pinOnPress";

export function nestedApp(mode: ParentMode, childOpen: boolean) {
	return (
		<ThemeProvider theme={FAST_THEME}>
			<OverlayProvider>
				<Tooltip
					name="ParentTip"
					interactive={mode === "interactive"}
					pinOnPress={mode === "pinOnPress"}
					content={
						<Tooltip name="ChildTip" content="Nested hint" open={childOpen}>
							<frame key="ChildTrigger" BackgroundTransparency={1} Size={UDim2.fromOffset(80, 20)} />
						</Tooltip>
					}
				>
					<frame
						key="ParentTrigger"
						BackgroundTransparency={1}
						Size={UDim2.fromOffset(100, 40)}
						Position={UDim2.fromOffset(150, 200)}
					/>
				</Tooltip>
			</OverlayProvider>
		</ThemeProvider>
	);
}

export function waitForTrigger(host: Instance, name = "Trigger"): Frame {
	waitForGuiObject<Frame>(host, "OverlayProvider");
	return waitForGuiObject<Frame>(host, name);
}

export function pressInput(kind: "MouseButton1" | "Touch" = "MouseButton1"): InputObject {
	return {
		UserInputType: kind === "Touch" ? Enum.UserInputType.Touch : Enum.UserInputType.MouseButton1,
		UserInputState: Enum.UserInputState.Begin,
	} as unknown as InputObject;
}

export interface TouchPress {
	input: InputObject;
	finish: (state: Enum.UserInputState) => void;
}

export function touchPress(): TouchPress {
	const changed = new Instance("BindableEvent");
	const fields = {
		UserInputType: Enum.UserInputType.Touch,
		UserInputState: Enum.UserInputState.Begin as Enum.UserInputState,
		GetPropertyChangedSignal: () => changed.Event,
	};

	return {
		input: fields as unknown as InputObject,
		finish: (state) => {
			fields.UserInputState = state;
			changed.Fire();
			task.wait();
			changed.Destroy();
		},
	};
}

export function waitForShown(host: Instance, name = "Tooltip", seconds = 2): CanvasGroup {
	const popup = waitForGuiObject<CanvasGroup>(host, name);
	const deadline = os.clock() + seconds;

	while (os.clock() < deadline) {
		if (popup.GroupTransparency < 0.01) return popup;
		task.wait();
	}

	return Assert.fail(
		`Timed out after ${seconds}s waiting for "${name}" to fade in (GroupTransparency=${popup.GroupTransparency})`,
	);
}

export function assertStaysShown(host: Instance, seconds: number, message: string, name = "Tooltip") {
	task.wait(seconds);

	const popup = host.FindFirstChild(name, true) as CanvasGroup | undefined;
	Assert.notUndefined(popup, message);
	Assert.true(popup!.GroupTransparency < 0.01, `${message} (GroupTransparency=${popup!.GroupTransparency})`);
}

export function fadesBy(popup: CanvasGroup, deadline: number): boolean {
	while (os.clock() < deadline) {
		if (popup.GroupTransparency > 0.01) return true;
		task.wait();
	}

	return false;
}
