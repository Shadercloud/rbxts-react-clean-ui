import React from "@rbxts/react";
import { Boolean, Choose } from "@rbxts/ui-labs";
import { Card, Container, createStory, HStack, Intent, Text, VStack } from "@rbxts/react-clean-ui";
import Modal from "./Modal";

export = createStory(
	(props) => (
		<Container center>
			<Card>
				<Card.Header>
					<HStack valign="Center">
						<Text text="Modal Demo" variant="heading" />
					</HStack>
				</Card.Header>
				<Card.Body>
					<VStack>
						<Text text="Open the modal, then click its body: it should stay open. The backdrop and explicit close controls should close it." />
						<Text text="With dragging enabled, drag the modal header and release it to verify the panel remains at its dropped position." />
						<Text text="The basic modal uses percentage width and height so it scales with the story viewport." />
						<Modal
							closeOnBackdropClick={props.controls.CloseOnBackdropClick}
							closeOnEscape={props.controls.CloseOnEscape}
							draggable={props.controls.Draggable}
							intent={props.controls.Intent as Intent}
						/>
					</VStack>
				</Card.Body>
			</Card>
		</Container>
	),
	{
		CloseOnBackdropClick: Boolean(true),
		CloseOnEscape: Boolean(true),
		Draggable: Boolean(true),
		Intent: Choose(["primary", "success", "info", "warning", "danger"]),
	},
);
