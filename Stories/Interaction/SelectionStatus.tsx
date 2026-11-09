import React from "@rbxts/react";
import { GuiService, UserInputService } from "@rbxts/services";
import { Text } from "@rbxts/react-clean-ui";

function readStatus() {
	const selected = GuiService.SelectedObject;

	return `Last input: ${UserInputService.GetLastInputType().Name}  |  Selected: ${selected !== undefined ? selected.Name : "(none)"}`;
}

function SelectionStatus() {
	const [status, setStatus] = React.useState(readStatus);

	React.useEffect(() => {
		const update = () => setStatus(readStatus());
		const inputConnection = UserInputService.LastInputTypeChanged.Connect(update);
		const selectionConnection = GuiService.GetPropertyChangedSignal("SelectedObject").Connect(update);

		update();

		return () => {
			inputConnection.Disconnect();
			selectionConnection.Disconnect();
		};
	}, []);

	return <Text text={status} />;
}

export = SelectionStatus;
