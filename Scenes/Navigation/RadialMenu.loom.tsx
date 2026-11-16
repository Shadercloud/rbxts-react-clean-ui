import React from "@rbxts/react";
import { RadialMenu } from "../../src/Components/Navigation/RadialMenu";
import { Container } from "../../src/Components/Layout/Container";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="320" center>
                <RadialMenu
                    placeholder={{ icon: "gear", text: "System Settings", description: "Radial Menu" }}
                    items={[
                        { value: "airplane", icon: "plane", text: "Airplane", description: "Flight mode" },
                        { value: "bluetooth", icon: "bluetooth", text: "Bluetooth", description: "Wireless devices" },
                        { value: "location", icon: "location-arrow", text: "Location", description: "GPS services" },
                        { value: "volume", icon: "volume-up", text: "Volume", description: "Sound level" },
                        { value: "brightness", icon: "sun-o", text: "Brightness", description: "Screen light" },
                        { value: "phone", icon: "phone", text: "Phone", description: "Calls" },
                        { value: "message", icon: "comment", text: "Message", description: "Texts and chat" },
                        { value: "wifi", icon: "wifi", text: "Wi-Fi", description: "Network" },
                    ]}
                />
            </Container>
        </LoomScene>
    ),
    title: "Navigation/Radial Menu",
} as const;
