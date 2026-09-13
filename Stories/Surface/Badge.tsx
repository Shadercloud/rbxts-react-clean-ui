import React from "@rbxts/react";
import { Badge as BadgeComponent, Container, HStack, IconName, Intent, ScaleSize, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface BadgeProps {
    screenshot?: boolean;
}

const SCALES: ScaleSize[] = ["xs", "sm", "md", "lg", "xl"];

const INTENTS: { intent: Intent; label: string; icon: IconName }[] = [
    { intent: "primary", label: "Primary", icon: "smile-o" },
    { intent: "success", label: "Success", icon: "check" },
    { intent: "info", label: "Info", icon: "info" },
    { intent: "warning", label: "Warning", icon: "exclamation" },
    { intent: "danger", label: "Danger", icon: "times" },
];

function Badge(props: BadgeProps = {}) {
    const content = (
        <Container>
            <VStack spacing="sm">
                {SCALES.map((scale, scaleIndex) => (
                    <Container name={`Scale_${scale}`} LayoutOrder={scaleIndex}>
                        <HStack valign="Center" spacing="sm" Wraps={false}>
                            <Container name="ScaleLabel" width={32} LayoutOrder={0}>
                                <Text text={scale.upper()} weight="bold" TextWrap={false} />
                            </Container>
                            {INTENTS.map((entry, intentIndex) => (
                                <BadgeComponent
                                    name={`Plain_${entry.intent}`}
                                    LayoutOrder={intentIndex + 1}
                                    text={entry.label}
                                    intent={entry.intent}
                                    scale={scale}
                                />
                            ))}
                            {INTENTS.map((entry, intentIndex) => (
                                <BadgeComponent
                                    name={`Icon_${entry.intent}`}
                                    LayoutOrder={INTENTS.size() + intentIndex + 1}
                                    text={tostring((intentIndex + 1) * 3)}
                                    icon={entry.icon}
                                    intent={entry.intent}
                                    scale={scale}
                                />
                            ))}
                        </HStack>
                    </Container>
                ))}
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Badge;
