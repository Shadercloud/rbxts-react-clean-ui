import React from "@rbxts/react";
import { BarChart } from "../../src/Components/Chart/BarChart";
import { Container } from "../../src/Components/Layout/Container";
import { LoomScene } from "../LoomScene";

export const preview = {
	render: () => (
		<LoomScene>
			<Container height="300" width="100%">
				<BarChart
					data={{
						labels: ["Alpha", "Beta", "Gamma", "Delta"],
						datasets: [{ values: [7, 4, 6, 5] }, { values: [2, 3, 1, 2] }],
					}}
				/>
			</Container>
		</LoomScene>
	),

	title: "Charts/Bar Chart",
} as const;
