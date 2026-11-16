import React from "@rbxts/react";
import { Container, RadialMenu, RadialMenuItem, RadialMenuPlaceholder, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const STAR_IMAGE = "rbxassetid://90284110323245";
const HEART_IMAGE = "rbxassetid://77750790654504";
const GEAR_IMAGE = "rbxassetid://105361618427312";

const GOLD = Color3.fromHex("#F5B700");
const RED = Color3.fromHex("#E5484D");
const GREEN = Color3.fromHex("#2E9D63");
const WHITE = new Color3(1, 1, 1);

function CenterImage(props: { image: string; color: Color3; text: string; description?: string }) {
    return (
        <frame key="CustomCenter" Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} BorderSizePixel={0}>
            <uilistlayout
                key="Layout"
                FillDirection={Enum.FillDirection.Vertical}
                HorizontalAlignment={Enum.HorizontalAlignment.Center}
                VerticalAlignment={Enum.VerticalAlignment.Center}
                SortOrder={Enum.SortOrder.LayoutOrder}
                Padding={new UDim(0, 4)}
            />
            <imagelabel
                key="Image"
                LayoutOrder={1}
                Size={UDim2.fromScale(0.4, 0.4)}
                Image={props.image}
                ImageColor3={props.color}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            >
                <uiaspectratioconstraint key="AspectRatio" AspectRatio={1} />
            </imagelabel>
            <Text name="Title" LayoutOrder={2} text={props.text} align="Center" TextWrap Size={UDim2.fromScale(1, 0)} AutomaticSize={Enum.AutomaticSize.Y} />
            {props.description !== undefined && (
                <Text name="Description" LayoutOrder={3} text={props.description} align="Center" TextWrap Size={UDim2.fromScale(1, 0)} AutomaticSize={Enum.AutomaticSize.Y} TextTransparency={0.3} />
            )}
        </frame>
    );
}

const ITEMS: RadialMenuItem[] = [
    {
        value: "favourites",
        text: "Favourites",
        description: "Starred items",
        content: (state) => (
            <imagelabel
                key="Star"
                AnchorPoint={new Vector2(0.5, 0.5)}
                Position={UDim2.fromScale(0.5, 0.5)}
                Size={state.selected || state.hovered ? UDim2.fromScale(1.3, 1.3) : UDim2.fromScale(1, 1)}
                Image={STAR_IMAGE}
                ImageColor3={GOLD}
                ImageTransparency={state.selected ? 0 : state.hovered ? 0.2 : 0.5}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            />
        ),
        centerContent: (state) => (
            <CenterImage image={STAR_IMAGE} color={GOLD} text="Favourites" description={state.hovered ? "Click again to keep" : "12 starred items"} />
        ),
    },
    { value: "location", icon: "map-marker", text: "Location", description: "Share your position" },
    {
        value: "inbox",
        text: "Inbox",
        description: "Unread messages",
        content: (state) => (
            <frame
                key="Badge"
                AnchorPoint={new Vector2(0.5, 0.5)}
                Position={UDim2.fromScale(0.5, 0.5)}
                Size={state.hovered ? UDim2.fromScale(1.2, 1.2) : UDim2.fromScale(1, 1)}
                BackgroundColor3={state.selected ? GREEN : RED}
                BorderSizePixel={0}
            >
                <uicorner key="Corners" CornerRadius={new UDim(0.5, 0)} />
                <uipadding key="Padding" PaddingTop={new UDim(0.15, 0)} PaddingBottom={new UDim(0.15, 0)} />
                <Text name="Count" text={state.selected ? "0" : "3"} align="Center" TextScaled Size={UDim2.fromScale(1, 1)} AutomaticSize={Enum.AutomaticSize.None} TextColor3={WHITE} />
            </frame>
        ),
    },
    { value: "message", icon: "comment", text: "Messages", description: "Read and send messages" },
    {
        value: "liked",
        icon: "heart",
        text: "Liked",
        description: "Things you liked",
        content: (state) => (
            <imagelabel
                key="Heart"
                Size={UDim2.fromScale(1, 1)}
                Image={HEART_IMAGE}
                ImageColor3={state.selected ? RED : state.hovered ? Color3.fromHex("#F28B8E") : Color3.fromHex("#9AA0A6")}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            />
        ),
    },
    { value: "wifi", icon: "wifi", text: "Wi-Fi", description: "Connect to a network" },
];

const PLACEHOLDER: RadialMenuPlaceholder = {
    centerContent: <CenterImage image={GEAR_IMAGE} color={GOLD} text="Pick an item" description="Custom placeholder" />,
};

function RadialMenuCustomContent(props: { screenshot?: boolean }) {
    const [lastSelected, setLastSelected] = React.useState<string | undefined>(undefined);

    const content = (
        <Container width={280} AutomaticSize="Y">
            <VStack>
                <RadialMenu
                    name="CustomContentRadialMenu"
                    items={ITEMS}
                    onValueChange={(value) => setLastSelected(value)}
                    size={280}
                    thickness="36%"
                    placeholder={PLACEHOLDER}
                />
                <Text text={`Selected: ${lastSelected ?? "none"}`} />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = RadialMenuCustomContent;
