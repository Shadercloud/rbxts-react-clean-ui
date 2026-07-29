import React from "@rbxts/react";
import { useTween } from "@rbxts/react-ripple";
import { SizeElementProps } from "../../Interfaces";
import { Box, Icon } from "../Surface";
import { Container, FlexItem, HStack, VStack } from "../Layout";
import { Button } from "../Input";
import { Text } from "../Typography";
import { CleanThemeContext, ToastOptions, useToast } from "../../Contexts/";
import { ColorHelper, SizeHelper, TypographyHelper } from "../../Helpers";
import { Corners } from "../Decorator";

interface ToastProps extends ToastOptions {
    onDismiss: () => void;
}

export function Toast({
    title = undefined,
    description = undefined,
    icon = undefined,
    intent = "primary",
    duration = 3,
    dismissible = true,
    children = undefined,
    onDismiss,
}: ToastProps) {
    const theme = React.useContext(CleanThemeContext);

    const dismissRef = React.useRef(onDismiss);
    const dismissingRef = React.useRef(false);
    const fadeThreadRef = React.useRef<thread>();

    const statusBarTheme = theme.components.toast.statusBar;

    const [progress, progressTween] = useTween(1, {
        duration,
        easing: "linear",
    });

    React.useEffect(() => {
        if (
            statusBarTheme === undefined ||
            duration === math.huge ||
            duration <= 0
        ) {
            return;
        }

        progressTween.setGoal(0);
    }, [duration, statusBarTheme]);

    const TOAST_FADE_DURATION = theme.components.toast.fadeDuration;

    const [groupTransparency, transparencyTween] = useTween(0, {
        duration: TOAST_FADE_DURATION,
        easing: "quadOut",
    });

    React.useEffect(() => {

    })

    React.useEffect(() => {
        dismissRef.current = onDismiss;
    }, [onDismiss]);

    const beginDismiss = React.useCallback(() => {
        if (dismissingRef.current) {
            return;
        }

        dismissingRef.current = true;

        if (TOAST_FADE_DURATION <= 0) {
            dismissRef.current();
            return;
        }

        transparencyTween.setGoal(1);

        fadeThreadRef.current = task.delay(TOAST_FADE_DURATION, () => {
            fadeThreadRef.current = undefined;
            dismissRef.current();
        });
    }, [transparencyTween]);

    React.useEffect(() => {
        if (duration === math.huge || duration <= 0) {
            return;
        }

        const dismissThread = task.delay(duration, beginDismiss);

        return () => {
            task.cancel(dismissThread);
        };
    }, [duration, beginDismiss]);

    React.useEffect(() => {
        if (TOAST_FADE_DURATION <= 0) {
            return;
        }
        return () => {
            const fadeThread = fadeThreadRef.current;

            if (fadeThread !== undefined) {
                task.cancel(fadeThread);
            }
        };
    }, []);

    const boxStyles = ColorHelper.getIntentColors(theme, intent, "default", theme.components.toast.intents);

    return (
        <canvasgroup
            Size={UDim2.fromScale(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            BackgroundTransparency={1}
            GroupTransparency={groupTransparency}
        >

            <Box
                border-color={boxStyles.borderColor}
                BackgroundColor3={boxStyles.backgroundColor}
                BackgroundTransparency={boxStyles.backgroundTransparency}
            >
                {children !== undefined && children ||
                    <VStack spacing="None">
                        <Container>

                            <HStack valign="Center">
                                {icon !== undefined &&
                                    <Icon icon={icon} scale="sm" color={boxStyles.textColor} />}
                                <Text
                                    TextColor3={boxStyles.textColor}
                                    text={title ?? ""}
                                    typography={TypographyHelper.getTypography(
                                        theme,
                                        undefined,
                                        theme.components.toast.header.typography,
                                    )}
                                />

                                {dismissible && (
                                    <FlexItem align="Right">
                                        <Button
                                            intent={intent}
                                            spacing="xs"
                                            Event={{
                                                Activated: beginDismiss,
                                            }}
                                        >
                                            <Button.Icon intent={intent} icon="times" scale="sm" />
                                        </Button>
                                    </FlexItem>
                                )}
                            </HStack>

                        </Container>

                        {description !== undefined && (
                            <Container>
                                <Text text={description} TextColor3={boxStyles.textColor} />
                            </Container>
                        )}
                    </VStack>
                }
            </Box>
            {statusBarTheme !== undefined &&
                <><frame
                    Size={progress.map((value) => new UDim2(new UDim(value, 0), SizeHelper.toUDim(statusBarTheme.height)))}
                    BackgroundColor3={ColorHelper.getIntentColors(theme, intent, "default", statusBarTheme.intents).backgroundColor}
                    BackgroundTransparency={ColorHelper.getIntentColors(theme, intent, "default", statusBarTheme.intents).backgroundTransparency}
                    ZIndex={2}
                    BorderSizePixel={0}
                    Position={UDim2.fromScale(0, statusBarTheme.position === "Top" ? 0 : 1)}
                    AnchorPoint={new Vector2(0, statusBarTheme.position === "Top" ? 0 : 1)} />
                    <Corners radius={theme.components.box.cornerRadius} />
                </>
            }
        </canvasgroup>
    );
}

interface ToastContainerProps extends SizeElementProps { }

export function ToastContainer(props: ToastContainerProps) {
    const { toasts, dismiss } = useToast();
    const theme = React.useContext(CleanThemeContext);

    if (toasts.isEmpty()) {
        return undefined;
    }

    const position = theme.components.toast.position
        ? SizeHelper.GetPosition(theme.components.toast.position)
        : UDim2.fromOffset(5, 5);

    const anchor = theme.components.toast.position
        ? SizeHelper.GetAnchor(theme.components.toast.position)
        : new Vector2(0, 0);

    return (
        <Container
            Size={SizeHelper.GetSize(
                props,
                new UDim2(
                    SizeHelper.toUDim(theme.components.toast.width),
                    new UDim(0, 0),
                ),
            )}
            Position={position}
            AnchorPoint={anchor}
        >
            <VStack spacing="xs">
                {toasts.map((toast) => (
                    <Toast
                        key={toast.id}
                        {...toast}
                        onDismiss={() => dismiss(toast.id)}
                    />
                ))}
            </VStack>
        </Container>
    );
}