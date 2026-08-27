import React from "@rbxts/react";
import { Button, CleanUiProvider, Container, DefaultTheme, IconName, Intent, useToast } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface ToastDemoProps {
    intent?: Intent;
}

function iconForIntent(intent: Intent): IconName | undefined {
    if (intent === "success") return "thumbs-up";
    if (intent === "info") return "question-circle";
    if (intent === "primary") return undefined;
    return "exclamation-circle";
}

function ToastDemo(props: ToastDemoProps) {
    const toast = useToast();
    const intent = props.intent ?? "info";
    const icon = iconForIntent(intent);

    React.useEffect(() => {
        toast.show({
            title: "Alert Message",
            description: "This is a test to show the toast system.",
            intent,
            icon,
            duration: math.huge,
            dismissible: true,
        });
        // Only ever trigger the initial demo toast once, on mount.
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    return <Container center>
        <Button text="Show Toast" icon="bullhorn" intent={intent}
            Event={{
                Activated: () => {
                    toast.show({
                        title: "Alert Message",
                        description: "This is a test to show the toast system.",
                        intent,
                        icon,
                        duration: 3,
                        dismissible: true,
                    })
                }
            }} />
    </Container>;
}

interface ToastProps {
    intent?: Intent;
    screenshot?: boolean;
}

function Toast(props: ToastProps = {}) {
    const content = (
        <Container width={320} height={160}>
            <ToastDemo intent={props.intent} />
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Toast;
