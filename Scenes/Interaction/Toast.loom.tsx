import React from "@rbxts/react";
import { Button } from "../../src/Components/Input/Button";
import { Container } from "../../src/Components/Layout/Container";
import { useToast } from "../../src/Contexts";
import { LoomScene } from "../LoomScene";

function ToastDemo() {
    const toast = useToast();

    const showToast = () => {
        toast.show({
            title: "Saved",
            description: "Your changes have been saved successfully.",
            intent: "success",
            icon: "check",
        });
    };

    React.useEffect(() => {
        showToast();
    }, []);

    return (
        <Button
            text="Show Toast"
            intent="primary"
            Event={{
                Activated: showToast,
            }}
        />
    );
}

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="120" center>
                <ToastDemo />
            </Container>
        </LoomScene>
    ),
    title: "Interaction/Toast",
} as const;
