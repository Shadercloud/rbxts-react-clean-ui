import React from "@rbxts/react";
import {
	Button,
	Card,
	Container,
	FlexItem,
	HStack,
	Intent,
	Modal as ModalComponent,
	Text,
	useModalClose,
	VStack,
} from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function ModalCloseButton() {
	const close = useModalClose();

	return <Button icon="close" scale="xs" Event={{ Activated: () => close() }} />;
}

interface BasicModalDemoProps {
	closeOnBackdropClick?: boolean;
	closeOnEscape?: boolean;
	draggable?: boolean;
	intent?: Intent;
}

function BasicModalDemo(props: BasicModalDemoProps) {
	const [open, setOpen] = React.useState(false);

	return (
		<Container>
			<Button text="Open Modal" intent={props.intent} Event={{ Activated: () => setOpen(true) }} />
			<ModalComponent
				open={open}
				onOpenChange={setOpen}
				closeOnBackdropClick={props.closeOnBackdropClick}
				closeOnEscape={props.closeOnEscape}
				draggable={props.draggable}
				intent={props.intent}
			>
				<Card.Header>
					<HStack valign="Center">
						<Text text="Modal Title" variant="heading" />
						<FlexItem align="Right">
							<ModalCloseButton />
						</FlexItem>
					</HStack>
				</Card.Header>
				<Card.Body>
					<Text text="Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts." />
				</Card.Body>
				<Card.Footer>
					<HStack>
						<Button text="Cancel" Event={{ Activated: () => setOpen(false) }} />
						<Button
							text="Confirm"
							intent={props.intent ?? "primary"}
							Event={{ Activated: () => setOpen(false) }}
						/>
					</HStack>
				</Card.Footer>
			</ModalComponent>
		</Container>
	);
}

function StackedModalDemo(props: BasicModalDemoProps) {
	const [firstOpen, setFirstOpen] = React.useState(false);
	const [secondOpen, setSecondOpen] = React.useState(false);

	return (
		<Container>
			<Button text="Open Stacked Modals" Event={{ Activated: () => setFirstOpen(true) }} />
			<ModalComponent draggable={props.draggable} open={firstOpen} onOpenChange={setFirstOpen}>
				<Card.Header>
					<HStack valign="Center">
						<Text text="First Modal" variant="heading" />
						<FlexItem align="Right">
							<ModalCloseButton />
						</FlexItem>
					</HStack>
				</Card.Header>
				<Card.Body>
					<VStack>
						<Text text="Escape or a backdrop click only closes the topmost modal." />
						<Button text="Open Second Modal" Event={{ Activated: () => setSecondOpen(true) }} />
					</VStack>
				</Card.Body>
				<Card.Footer>
					<Button text="Close" Event={{ Activated: () => setFirstOpen(false) }} />
				</Card.Footer>
			</ModalComponent>
			<ModalComponent open={secondOpen} draggable={props.draggable} onOpenChange={setSecondOpen}>
				<Card.Header>
					<HStack valign="Center">
						<Text text="Second Modal" variant="heading" />
						<FlexItem align="Right">
							<ModalCloseButton />
						</FlexItem>
					</HStack>
				</Card.Header>
				<Card.Body>
					<Text text="This modal is stacked on top of the first one, and closes independently of it." />
				</Card.Body>
				<Card.Footer>
					<Button text="Close" intent="primary" Event={{ Activated: () => setSecondOpen(false) }} />
				</Card.Footer>
			</ModalComponent>
		</Container>
	);
}

interface ModalProps {
	screenshot?: boolean;
	closeOnBackdropClick?: boolean;
	closeOnEscape?: boolean;
	draggable?: boolean;
	intent?: Intent;
}

function Modal(props: ModalProps = {}) {
	const content = (
		<Container width={360}>
			<VStack>
				<BasicModalDemo
					closeOnBackdropClick={props.closeOnBackdropClick}
					closeOnEscape={props.closeOnEscape}
					draggable={props.draggable}
					intent={props.intent}
				/>
				<StackedModalDemo
					closeOnBackdropClick={props.closeOnBackdropClick}
					closeOnEscape={props.closeOnEscape}
					draggable={props.draggable}
					intent={props.intent}
				/>
			</VStack>
		</Container>
	);

	return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Modal;
