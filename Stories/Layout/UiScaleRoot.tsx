import React from "@rbxts/react";
import {
    BreakpointContext,
    BreakpointProvider,
    BreakpointValue,
    Box,
    Button,
    Card,
    CleanThemeContext,
    CleanUiProvider,
    Container,
    CssSize,
    FlexItem,
    Grid,
    HStack,
    Modal,
    Select,
    Text,
    Tooltip,
    UiScaleRoot as UiScaleRootComponent,
    toScreenPixels,
    useBreakpoint,
    useDesignViewportSize,
    useModalClose,
    useToast,
    useUiScale,
    VStack,
} from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const BREAKPOINTS: BreakpointValue<number> = { xs: 0, sm: 400, md: 600, lg: 800, xl: 1000 };

const COLUMNS: BreakpointValue<number> = { xs: 1, sm: 2, md: 3, lg: 4, xl: 6 };

const CELLS = ["Cell 1", "Cell 2", "Cell 3", "Cell 4", "Cell 5", "Cell 6"];

function Readouts(props: { overlayInside: boolean; LayoutOrder: number }) {
    const scale = useUiScale();
    const designViewport = useDesignViewportSize();
    const breakpoint = useBreakpoint();
    const context = React.useContext(BreakpointContext);
    const designWidth = context?.width ?? 0;

    return (
        <Container width="100%" AutomaticSize="Y" LayoutOrder={props.LayoutOrder}>
            <VStack spacing="xs" />
            <Text text={`useUiScale(): ${string.format("%.2f", scale)}`} variant="heading" LayoutOrder={0} />
            <Text
                text={`useDesignViewportSize(): ${math.round(designViewport.X)} x ${math.round(designViewport.Y)}`}
                variant="caption"
                LayoutOrder={1}
            />
            <Text
                text={`Breakpoint: ${breakpoint} (${COLUMNS[breakpoint]} columns)`}
                variant="caption"
                LayoutOrder={2}
            />
            <Text
                text={`Design width: ${math.round(designWidth)}px (${math.round(toScreenPixels(designWidth, scale))} screen px)`}
                variant="caption"
                LayoutOrder={3}
            />
            <Text
                text={props.overlayInside ? "Overlay: inside the root" : "Overlay: outside the root (UiScaleOverlay)"}
                variant="caption"
                LayoutOrder={4}
            />
        </Container>
    );
}

function ModalCloseButton() {
    const close = useModalClose();

    return <Button icon="close" scale="xs" Event={{ Activated: () => close() }} />;
}

function ModalDemo() {
    const [open, setOpen] = React.useState(false);

    return (
        <Container AutomaticSize="XY">
            <Button text="Open Modal" Event={{ Activated: () => setOpen(true) }} />
            <Modal open={open} onOpenChange={setOpen}>
                <Card.Header>
                    <HStack valign="Center">
                        <Text text="Scaled Modal" variant="heading" />
                        <FlexItem align="Right">
                            <ModalCloseButton />
                        </FlexItem>
                    </HStack>
                </Card.Header>
                <Card.Body>
                    <Text text="This modal renders at the same scale as the button that opened it." />
                </Card.Body>
                <Card.Footer>
                    <Button text="Close" intent="primary" Event={{ Activated: () => setOpen(false) }} />
                </Card.Footer>
            </Modal>
        </Container>
    );
}

function ToastButton() {
    const toast = useToast();

    return (
        <Button
            text="Show Toast"
            icon="bullhorn"
            Event={{
                Activated: () => {
                    toast.show({
                        title: "Scaled Toast",
                        description: "Scaled only when its ToastContainer is inside the root.",
                        intent: "info",
                        duration: 3,
                        dismissible: true,
                    });
                },
            }}
        />
    );
}

function Demo(props: { overlayInside: boolean }) {
    return (
        <BreakpointProvider breakpoints={BREAKPOINTS}>
            <uipadding
                key="DemoPadding"
                PaddingTop={new UDim(0, 12)}
                PaddingBottom={new UDim(0, 12)}
                PaddingLeft={new UDim(0, 12)}
                PaddingRight={new UDim(0, 12)}
            />
            <VStack spacing="sm" Wraps={false} />
            <Readouts overlayInside={props.overlayInside} LayoutOrder={0} />
            <Container name="Controls" width="100%" AutomaticSize="Y" LayoutOrder={1}>
                <HStack valign="Center" />
                <Container AutomaticSize="XY" LayoutOrder={0}>
                    <Tooltip content="Aligned with its trigger at every scale" placement="Top">
                        <Button text="Hover for Tooltip" />
                    </Tooltip>
                </Container>
                <Container AutomaticSize="XY" LayoutOrder={1}>
                    <Select width={200} max-height="200px">
                        <Select.Option text="Small" />
                        <Select.Option text="Medium" />
                        <Select.Option text="Large" />
                        <Select.Option text="Extra Large" />
                    </Select>
                </Container>
                <Container AutomaticSize="XY" LayoutOrder={2}>
                    <ModalDemo />
                </Container>
                <Container AutomaticSize="XY" LayoutOrder={3}>
                    <ToastButton />
                </Container>
            </Container>
            <Container name="GridArea" width="100%" AutomaticSize="Y" LayoutOrder={2}>
                <Grid name="ScaledGrid" width="100%" cols={COLUMNS} breakpoints={BREAKPOINTS} gap="sm">
                    {CELLS.map((cell) => (
                        <Box key={cell} AutomaticSize={Enum.AutomaticSize.Y}>
                            <Text text={cell} />
                        </Box>
                    ))}
                </Grid>
            </Container>
        </BreakpointProvider>
    );
}

interface UiScaleRootProps {
    scale?: number;
    overlayInside?: boolean;
    width?: CssSize;
    height?: CssSize;
    screenshot?: boolean;
}

function UiScaleRoot(props: UiScaleRootProps = {}) {
    const theme = React.useContext(CleanThemeContext);
    const overlayInside = props.overlayInside ?? true;

    const content = (
        <Container name="Viewport" width={props.width ?? 900} height={props.height ?? 480}>
            <UiScaleRootComponent scale={props.scale ?? 1}>
                {overlayInside ? (
                    <CleanUiProvider theme={theme}>
                        <Demo overlayInside={true} />
                    </CleanUiProvider>
                ) : (
                    <Demo overlayInside={false} />
                )}
            </UiScaleRootComponent>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = UiScaleRoot;
