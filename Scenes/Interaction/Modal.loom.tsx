import React from "@rbxts/react";
import { Modal } from "../../src/Components/Interaction/Modal";
import { Button } from "../../src/Components/Input/Button";
import { Card } from "../../src/Components/Surface/Card";
import { Text } from "../../src/Components/Typography/Text";
import { HStack } from "../../src/Components/Layout/HStack";
import { FlexItem } from "../../src/Components/Layout/FlexItem";
import { Container } from "../../src/Components/Layout/Container";
import { useModalClose } from "../../src/Contexts";
import { OverlayProvider } from "../../src/Providers/overlay.provider";
import { LoomScene } from "../LoomScene";

function ModalCloseButton() {
	const close = useModalClose();

	return <Button name="ModalCloseButton" icon="close" scale="xs" Event={{ Activated: () => close() }} />;
}

function ModalDemo() {
	const [open, setOpen] = React.useState(false);

	return (
		<>
			<Button
				text="Open Modal"
				intent="primary"
				Event={{
					Activated: () => setOpen(true),
				}}
			/>
			<Modal open={open} onOpenChange={setOpen} draggable width="60%">
				<Card.Header>
					<HStack valign="Center">
						<Text variant="heading" text="Drag This Header" />
						<FlexItem align="Right">
							<ModalCloseButton />
						</FlexItem>
					</HStack>
				</Card.Header>
				<Card.Body>
					<Text text="This panel is 60% wide. Drag from the header, then release to keep its dropped position; dragging from this body does nothing." />
				</Card.Body>
				<Card.Footer>
					<HStack>
						<Button
							text="Cancel"
							Event={{
								Activated: () => setOpen(false),
							}}
						/>
						<Button
							text="Confirm"
							intent="success"
							Event={{
								Activated: () => setOpen(false),
							}}
						/>
					</HStack>
				</Card.Footer>
			</Modal>
		</>
	);
}

export const preview = {
	render: () => (
		<LoomScene>
			<Container width="100%" height="260" center>
				<OverlayProvider>
					<ModalDemo />
				</OverlayProvider>
			</Container>
		</LoomScene>
	),
	title: "Interaction/Modal",
} as const;
