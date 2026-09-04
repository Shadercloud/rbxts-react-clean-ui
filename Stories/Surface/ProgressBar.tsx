import React from "@rbxts/react";
import { Container, ProgressBar as ProgressBarComponent, Intent, ScaleSize } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface ProgressBarProps {
    value?: number;
    max?: number;
    intent?: Intent;
    scale?: ScaleSize;
    label?: string;
    showValue?: boolean;
    valueFormatter?: (value: number, max: number) => string;
    striped?: boolean;
    stripeDuration?: number;
    stripeDirection?: number;
    screenshot?: boolean;
}

function ProgressBar(props: ProgressBarProps = {}) {
    const content = (
        <Container width="300px">
            <ProgressBarComponent
                value={props.value ?? 60}
                max={props.max}
                intent={props.intent}
                scale={props.scale}
                label={props.label}
                showValue={props.showValue}
                valueFormatter={props.valueFormatter}
                striped={props.striped}
                stripeDuration={props.stripeDuration}
                stripeDirection={props.stripeDirection}
            />
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ProgressBar;
