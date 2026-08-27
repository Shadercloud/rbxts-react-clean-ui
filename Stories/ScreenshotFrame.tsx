import React from "@rbxts/react";
import { Container } from "@rbxts/react-clean-ui";

function ScreenshotFrame(props: React.PropsWithChildren<{}>) {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        {props.children}
    </Container>
}

export { ScreenshotFrame };
