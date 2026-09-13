import React from "@rbxts/react";
import {
    BreakpointContext,
    BreakpointProvider as BreakpointProviderComponent,
    BreakpointValue,
    Box,
    Button,
    CleanThemeContext,
    Container,
    HStack,
    Text,
    useBreakpoint,
    useBreakpointValue,
    VStack,
} from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const BREAKPOINTS: BreakpointValue<number> = { xs: 0, sm: 360, md: 600, lg: 900, xl: 1200 };

const WORLDS = [
    { title: "Obby Tower", players: "18 / 20" },
    { title: "Sandbox City", players: "7 / 30" },
    { title: "Racing League", players: "12 / 12" },
];

function BreakpointStatus() {
    const context = React.useContext(BreakpointContext);
    const breakpoint = useBreakpoint();
    const layout = useBreakpointValue({ xs: "stacked", md: "row" }) ?? "stacked";

    return (
        <Container width="100%" AutomaticSize="Y" LayoutOrder={0}>
            <VStack spacing="xs" />
            <Text text={`Breakpoint: ${breakpoint}`} variant="heading" LayoutOrder={0} />
            <Text text={`Context width: ${context?.width ?? 0}px`} variant="caption" LayoutOrder={1} />
            <Text text={`Layout: ${layout}`} variant="caption" LayoutOrder={2} />
        </Container>
    );
}

function WorldRow(props: { title: string; players: string; LayoutOrder: number }) {
    const layout = useBreakpointValue({ xs: "stacked", md: "row" }) ?? "stacked";
    const thumbnailSize = useBreakpointValue({ xs: 40, md: 56 }) ?? 40;

    const thumbnail = (
        <Box name="Thumbnail" width={thumbnailSize} height={thumbnailSize} spacing="None" LayoutOrder={0} />
    );

    if (layout === "row") {
        return (
            <Box width="100%" AutomaticSize="Y" LayoutOrder={props.LayoutOrder}>
                <HStack
                    valign="Center"
                    Wraps={false}
                    HorizontalFlex={Enum.UIFlexAlignment.SpaceBetween}
                />
                <Container name="Details" AutomaticSize="XY" LayoutOrder={0}>
                    <HStack valign="Center" Wraps={false} />
                    {thumbnail}
                    <Text text={props.title} variant="heading" LayoutOrder={1} />
                </Container>
                <Container name="Actions" AutomaticSize="XY" LayoutOrder={1}>
                    <HStack valign="Center" Wraps={false} />
                    <Text text={props.players} variant="caption" LayoutOrder={0} />
                    <Button text="Join" intent="primary" LayoutOrder={1} />
                </Container>
            </Box>
        );
    }

    return (
        <Box width="100%" AutomaticSize="Y" LayoutOrder={props.LayoutOrder}>
            <HStack valign="Center" Wraps={false} />
            {thumbnail}
            <Container name="Lines" AutomaticSize="XY" LayoutOrder={1}>
                <VStack spacing="xs" />
                <Text text={props.title} variant="heading" LayoutOrder={0} />
                <Container name="SecondLine" AutomaticSize="XY" LayoutOrder={1}>
                    <HStack valign="Center" Wraps={false} />
                    <Text text={props.players} variant="caption" LayoutOrder={0} />
                    <Button text="Join" intent="primary" scale="sm" LayoutOrder={1} />
                </Container>
            </Container>
        </Box>
    );
}

interface BreakpointProviderProps {
    width?: number;
    height?: number;
    screenshot?: boolean;
}

function BreakpointProvider(props: BreakpointProviderProps = {}) {
    const theme = React.useContext(CleanThemeContext);

    const content = (
        <Container name="Viewport" width={props.width ?? 390} height={props.height ?? 844}>
            <uistroke
                key="ViewportOutline"
                Thickness={1}
                Color={theme.components.box.borderColor}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
            />
            <BreakpointProviderComponent breakpoints={BREAKPOINTS}>
                <uipadding
                    key="ViewportPadding"
                    PaddingTop={new UDim(0, 12)}
                    PaddingBottom={new UDim(0, 12)}
                    PaddingLeft={new UDim(0, 12)}
                    PaddingRight={new UDim(0, 12)}
                />
                <VStack spacing="sm" Wraps={false} />
                <BreakpointStatus />
                {WORLDS.map((world, index) => (
                    <WorldRow key={world.title} title={world.title} players={world.players} LayoutOrder={index + 1} />
                ))}
            </BreakpointProviderComponent>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = BreakpointProvider;
