import React from "@rbxts/react";
import {
	Button,
	Container,
	GamepadHelper,
	GamepadSelectionGuard as GamepadSelectionGuardComponent,
	HStack,
	VStack,
} from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";
import SelectionStatus from "./SelectionStatus";

interface GamepadSelectionGuardProps {
	screenshot?: boolean;
	enabled?: boolean;
}

function GamepadSelectionGuard(props: GamepadSelectionGuardProps = {}) {
	const firstButtonRef = React.useRef<ImageButton>();

	const content = (
		<Container width={360}>
			<GamepadSelectionGuardComponent enabled={props.enabled}>
				<VStack>
					<HStack>
						<Button ref={firstButtonRef} name="FirstButton" text="First" />
						<Button name="SecondButton" text="Second" />
						<Button name="ThirdButton" text="Third" />
					</HStack>
					<Button
						name="SelectFirstButton"
						text="Select First"
						intent="primary"
						Event={{ Activated: () => GamepadHelper.trySetSelectedObject(firstButtonRef.current) }}
					/>
					<SelectionStatus />
				</VStack>
			</GamepadSelectionGuardComponent>
		</Container>
	);

	return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = GamepadSelectionGuard;
