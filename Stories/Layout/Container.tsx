import React from "@rbxts/react";
import { Container as ContainerComponent, HStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface ContainerProps {
    width?: number;
    maxWidth?: number;
    padding?: number;
    borderPosition?: "inner" | "outer";
    screenshot?: boolean;
}

function Container(props: ContainerProps = {}) {
    const borderPosition = props.borderPosition ?? "inner";

    const content = (
        <ContainerComponent
            width={props.width ?? 420}
            maxWidth={props.maxWidth}
            padding={`${props.padding ?? 12}`}
            cornerRadius="lg"
            borderThickness={2}
            borderColor={Color3.fromHex("#8A8F98")}
            borderPosition={borderPosition}
        >
            <HStack>
                <ContainerComponent width={100} height={100} cornerRadius="sm" borderThickness={3} borderColor={Color3.fromHex("#4E6B52")} borderPosition={borderPosition} BackgroundColor3={Color3.fromHex("#7A9E7E")} BackgroundTransparency={0} />
                <ContainerComponent width={100} height={100} cornerRadius="md" borderThickness={3} borderColor={Color3.fromHex("#8A4F2C")} borderPosition={borderPosition} BackgroundColor3={Color3.fromHex("#C97A4A")} BackgroundTransparency={0} />
                <ContainerComponent width={100} height={100} cornerRadius="lg" borderThickness={3} borderColor={Color3.fromHex("#2C4F8A")} borderPosition={borderPosition} BackgroundColor3={Color3.fromHex("#4A7AC9")} BackgroundTransparency={0} />
            </HStack>
        </ContainerComponent>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Container;
