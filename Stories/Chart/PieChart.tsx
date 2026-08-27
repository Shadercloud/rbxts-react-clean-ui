import React from "@rbxts/react";
import { Button, Container, Pie } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface PieChartProps {
    labelHover?: boolean;
    screenshot?: boolean;
}

function PieChart(props: PieChartProps = {}) {
    const labelHover = props.labelHover ?? false;

    const content = (
        <Container width={300} height={300}>
            <Pie
                label-spacing="xs"
                label-distance={0.3}
                label-hover={labelHover}
                hover-darken={0.2}
                values={[
                    { value: 30, label: "Green" },
                    { value: 40, label: "Red" },
                    {
                        value: 50, label: {
                            text: "Yellow",
                            BackgroundColor3: Color3.fromHex("#FAD5A5")
                        }
                    },
                    {
                        value: 5, label: {
                            content: <Button icon="check-square" text="Hello Blue" intent="info" />
                        }
                    },
                ]}
            />
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = PieChart;
