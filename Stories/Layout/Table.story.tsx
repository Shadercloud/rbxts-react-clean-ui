import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import Table from "./Table";

export = createStory(
	(props) => (
		<Container center width={props.controls["Fixed Width"] ? "75%" : undefined}>
			<Table compact={props.controls.Compact} fixedWidth={props.controls["Fixed Width"]} />
		</Container>
	),
	{
		Compact: Boolean(false),
		"Fixed Width": Boolean(false),
	},
);
