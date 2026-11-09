import React from "@rbxts/react";
import {
	Button,
	Card,
	Container,
	GamepadSelectionMode,
	HStack,
	Modal as ModalComponent,
	Text,
	VStack,
} from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";
import SelectionStatus from "./SelectionStatus";

interface ModalFocusProps {
	screenshot?: boolean;
	selectionMode?: GamepadSelectionMode;
}

function ModalFocus(props: ModalFocusProps = {}) {
	const [open, setOpen] = React.useState(false);
	const confirmRef = React.useRef<ImageButton>();

	const content = (
		<Container width={360}>
			<VStack>
				<Button text="Open Focus Modal" Event={{ Activated: () => setOpen(true) }} />
				<SelectionStatus />
				<ModalComponent
					open={open}
					onOpenChange={setOpen}
					initialFocus={confirmRef}
					selectionMode={props.selectionMode}
				>
					<Card.Header>
						<Text text="Focus Modal" variant="heading" />
					</Card.Header>
					<Card.Body>
						<VStack>
							<Text text="Confirm is the initial focus target." />
							<SelectionStatus />
						</VStack>
					</Card.Body>
					<Card.Footer>
						<HStack>
							<Button name="CancelButton" text="Cancel" Event={{ Activated: () => setOpen(false) }} />
							<Button
								ref={confirmRef}
								name="ConfirmButton"
								text="Confirm"
								intent="primary"
								Event={{ Activated: () => setOpen(false) }}
							/>
						</HStack>
					</Card.Footer>
				</ModalComponent>
			</VStack>
		</Container>
	);

	return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ModalFocus;
