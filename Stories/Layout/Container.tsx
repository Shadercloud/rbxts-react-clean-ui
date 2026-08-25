import React from "@rbxts/react";
import { Container as ContainerComponent, HStack } from "@rbxts/react-clean-ui";

interface ContainerProps {
    width?: number;
}

function Container(props: ContainerProps = {}) {
    return <ContainerComponent BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={props.width ?? 420} height={120}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <HStack>
            <ContainerComponent width={100} height={100} BackgroundColor3={Color3.fromHex("#7A9E7E")} BackgroundTransparency={0} />
            <ContainerComponent width={100} height={100} BackgroundColor3={Color3.fromHex("#C97A4A")} BackgroundTransparency={0} />
            <ContainerComponent width={100} height={100} BackgroundColor3={Color3.fromHex("#4A7AC9")} BackgroundTransparency={0} />
        </HStack>
    </ContainerComponent>
}

export = Container;
