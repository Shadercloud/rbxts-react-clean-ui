import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Card, Container, createStory, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import GamepadSelectionGuard from "./GamepadSelectionGuard";

export = createStory(
	(props) => (
		<Container center>
			<Card>
				<Card.Header>
					<HStack valign="Center">
						<Text text="Gamepad Selection Guard Demo" variant="heading" />
					</HStack>
				</Card.Header>
				<Card.Body>
					<VStack>
						<Text text="With the mouse or keyboard, Select First (or the backslash navigation toggle) is cleared on the next frame, so no selection outline appears." />
						<Text text="Switch to a gamepad (Studio's gamepad emulator) and the selection is kept. Turn Enabled off to compare without the guard." />
						<Text text="Selection only works when the story is mounted under a PlayerGui; in a plain plugin preview the assignment fails silently." />
						<GamepadSelectionGuard enabled={props.controls.Enabled} />
					</VStack>
				</Card.Body>
			</Card>
		</Container>
	),
	{
		Enabled: Boolean(true),
	},
);
