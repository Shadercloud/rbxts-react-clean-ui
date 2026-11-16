import React from "@rbxts/react";
import { Button, Container, RadialMenu as RadialMenuComponent, RadialMenuItem, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const ITEMS: RadialMenuItem[] = [
    { value: "airplane", icon: "plane", text: "Airplane Mode", description: "Disable all wireless connections" },
    { value: "bluetooth", icon: "bluetooth", text: "Bluetooth", description: "Pair nearby devices" },
    { value: "location", icon: "map-marker", text: "Location", description: "Share your position" },
    { value: "volume", icon: "volume-up", text: "Volume", description: "Adjust sound levels" },
    { value: "brightness", icon: "sun-o", text: "Brightness", description: "Adjust screen brightness" },
    { value: "phone", icon: "phone", text: "Phone", description: "Calls and contacts" },
    { value: "message", icon: "comment", text: "Messages", description: "Read and send messages" },
    { value: "wifi", icon: "wifi", text: "Wi-Fi", description: "Connect to a network" },
];

const PLACEHOLDER = { icon: "gear" as const, text: "System Settings", description: "Radial Menu" };

interface RadialMenuProps {
    screenshot?: boolean;
    size?: number;
    thickness?: number;
    showLabels?: boolean;
    controlled?: boolean;
}

function RadialMenu(props: RadialMenuProps = {}) {
    const size = props.size ?? 280;
    const thickness: `${number}%` = `${props.thickness ?? 36}%`;
    const [selected, setSelected] = React.useState("wifi");
    const [lastSelected, setLastSelected] = React.useState<string | undefined>(undefined);

    const selectNext = () => {
        const index = ITEMS.findIndex((item) => item.value === selected);
        setSelected(ITEMS[(index + 1) % ITEMS.size()].value);
    };

    const content = props.controlled === true ? (
        <Container width={size} AutomaticSize="Y">
            <VStack>
                <RadialMenuComponent
                    name="ControlledRadialMenu"
                    items={ITEMS}
                    value={selected}
                    onValueChange={(value) => setSelected(value)}
                    size={size}
                    thickness={thickness}
                    showLabels={props.showLabels}
                    placeholder={PLACEHOLDER}
                />
                <Text text={`Selected: ${selected}`} />
                <Button text="Next item" icon="arrow-right" Event={{ Activated: () => selectNext() }} />
            </VStack>
        </Container>
    ) : (
        <Container width={size} AutomaticSize="Y">
            <VStack>
                <RadialMenuComponent
                    name="UncontrolledRadialMenu"
                    items={ITEMS}
                    onValueChange={(value) => setLastSelected(value)}
                    size={size}
                    thickness={thickness}
                    showLabels={props.showLabels}
                    placeholder={PLACEHOLDER}
                />
                <Text text={`Selected: ${lastSelected ?? "none"}`} />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = RadialMenu;
