import React from "@rbxts/react";
import {
    CleanThemeContext,
    CleanUiProvider,
    Container,
    CssSize,
    HStack,
    Text,
    UiScaleRoot,
    VStack,
} from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface TextUiScaleProps {
    scale?: number;
    width?: CssSize;
    height?: CssSize;
    screenshot?: boolean;
}

const SIZES: [number, Enum.FontSize][] = [
    [12, Enum.FontSize.Size12],
    [24, Enum.FontSize.Size24],
    [32, Enum.FontSize.Size32],
    [48, Enum.FontSize.Size48],
    [96, Enum.FontSize.Size96],
];

const labelWidth = 90;
const boxWidth = 110;
const textWidth = 180;
const boxBorder = Color3.fromHex("#9AA5B1");

function Row(props: { size: number; fontSize: Enum.FontSize; LayoutOrder: number }) {
    const theme = React.useContext(CleanThemeContext);
    const typography = { ...theme.typography.body, size: props.fontSize };

    return (
        <Container name={`Row${props.size}`} width="100%" AutomaticSize="Y" LayoutOrder={props.LayoutOrder}>
            <HStack spacing="md" valign="Center" Wraps={false} />
            <Container name="Label" width={labelWidth} AutomaticSize="Y" LayoutOrder={0}>
                <Text text={`${props.size}px`} variant="label" TextWrap={false} />
            </Container>
            <Container name="BoxCell" width={boxWidth} AutomaticSize="Y" LayoutOrder={1}>
                <Container name="Box" width={props.size} height={props.size} borderThickness={1} borderColor={boxBorder} />
            </Container>
            <Container name="Default" width={textWidth} AutomaticSize="Y" LayoutOrder={2}>
                <Text text="Ag" typography={typography} TextWrap={false} />
            </Container>
            <Container name="Pinned" width={textWidth} AutomaticSize="Y" LayoutOrder={3}>
                <CleanUiProvider theme={theme} toasts={false} ignorePreferredTextSize={true}>
                    <Text text="Ag" typography={typography} TextWrap={false} />
                </CleanUiProvider>
            </Container>
        </Container>
    );
}

function Header(props: { scale: number; LayoutOrder: number }) {
    return (
        <Container name="Header" width="100%" AutomaticSize="Y" LayoutOrder={props.LayoutOrder}>
            <HStack spacing="md" valign="Center" Wraps={false} />
            <Container width={labelWidth} AutomaticSize="Y" LayoutOrder={0}>
                <Text text={`Scale ${string.format("%.2f", props.scale)}`} variant="caption" TextWrap={false} />
            </Container>
            <Container width={boxWidth} AutomaticSize="Y" LayoutOrder={1}>
                <Text text="Fixed box" variant="caption" TextWrap={false} />
            </Container>
            <Container width={textWidth} AutomaticSize="Y" LayoutOrder={2}>
                <Text text="Default" variant="caption" TextWrap={false} />
            </Container>
            <Container width={textWidth} AutomaticSize="Y" LayoutOrder={3}>
                <Text text="Pinned text size" variant="caption" TextWrap={false} />
            </Container>
        </Container>
    );
}

function TextUiScale(props: TextUiScaleProps = {}) {
    const scale = props.scale ?? 1;

    const content = (
        <Container name="Viewport" width={props.width ?? 680} height={props.height ?? 420}>
            <UiScaleRoot scale={scale}>
                <VStack spacing="sm" Wraps={false} />
                <Header scale={scale} LayoutOrder={0} />
                {SIZES.map(([size, fontSize], index) => (
                    <Row key={size} size={size} fontSize={fontSize} LayoutOrder={index + 1} />
                ))}
            </UiScaleRoot>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TextUiScale;
