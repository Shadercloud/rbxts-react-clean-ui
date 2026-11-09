import React from "@rbxts/react";
import { EnumList } from "@rbxts/ui-labs";
import { Card, Container, createStory, GamepadSelectionMode, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import ModalFocus from "./ModalFocus";

export = createStory(
	(props) => (
		<Container center>
			<Card>
				<Card.Header>
					<HStack valign="Center">
						<Text text="Modal Focus Demo" variant="heading" />
					</HStack>
				</Card.Header>
				<Card.Body>
					<VStack>
						<Text text="Gamepad mode: the modal selects Confirm only while the last input is a gamepad, selects it when you switch to a gamepad while open, and clears it when you switch back to mouse or keyboard." />
						<Text text="Always mode: Confirm is selected on every open whatever the input, and the selection is not cleared on an input switch." />
						<Text text="Selection only works when the story is mounted under a PlayerGui; in a plain plugin preview the assignment fails silently." />
						<ModalFocus selectionMode={props.controls.SelectionMode} />
					</VStack>
				</Card.Body>
			</Card>
		</Container>
	),
	{
		SelectionMode: EnumList<GamepadSelectionMode>(
			{
				Gamepad: "gamepad",
				Always: "always",
			},
			"Gamepad",
		),
	},
);
