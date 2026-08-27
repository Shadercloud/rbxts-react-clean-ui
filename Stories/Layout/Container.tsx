import React from "@rbxts/react";
import { Container as ContainerComponent, HStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface ContainerProps {
    width?: number;
    screenshot?: boolean;
}

function Container(props: ContainerProps = {}) {
    const content = (
        <ContainerComponent width={props.width ?? 420} height={120}>
            <HStack>
                <ContainerComponent width={100} height={100} BackgroundColor3={Color3.fromHex("#7A9E7E")} BackgroundTransparency={0} />
                <ContainerComponent width={100} height={100} BackgroundColor3={Color3.fromHex("#C97A4A")} BackgroundTransparency={0} />
                <ContainerComponent width={100} height={100} BackgroundColor3={Color3.fromHex("#4A7AC9")} BackgroundTransparency={0} />
            </HStack>
        </ContainerComponent>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Container;
