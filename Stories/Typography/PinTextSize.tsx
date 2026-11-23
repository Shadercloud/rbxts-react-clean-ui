import React from "@rbxts/react";
import {
    Button,
    CleanThemeContext,
    CleanUiProvider,
    Container,
    Input,
    PinTextSize as PinTextSizeComponent,
    Text,
    useIgnorePreferredTextSize,
    VStack,
} from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface PinTextSizeProps {
    ignorePreferredTextSize?: boolean;
    screenshot?: boolean;
}

const nativeTextSize = 18;

function NativeLabel() {
    const theme = React.useContext(CleanThemeContext);
    const pinned = useIgnorePreferredTextSize();

    return (
        <textlabel
            key="NativeLabel"
            Text={pinned ? "Native textlabel (pinned)" : "Native textlabel (follows Text Size)"}
            TextSize={nativeTextSize}
            Font={theme.typography.body.font}
            TextColor3={theme.typography.body.color ?? new Color3(0, 0, 0)}
            BackgroundTransparency={1}
            AutomaticSize={Enum.AutomaticSize.XY}
            Size={UDim2.fromOffset(0, 0)}
        >
            <PinTextSizeComponent size={nativeTextSize} enabled={pinned} />
        </textlabel>
    );
}

function PinTextSize(props: PinTextSizeProps = {}) {
    const theme = React.useContext(CleanThemeContext);
    const ignorePreferredTextSize = props.ignorePreferredTextSize ?? false;

    const content = (
        <Container width={360}>
            <CleanUiProvider theme={theme} toasts={false} ignorePreferredTextSize={ignorePreferredTextSize}>
                <VStack spacing="md">
                    <Text text="Library Text component" />
                    <Button text="Library Button" intent="primary" />
                    <Input placeholder="Library Input" value="" />
                    <NativeLabel />
                </VStack>
            </CleanUiProvider>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = PinTextSize;
