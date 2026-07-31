import React from "@rbxts/react";
// import { Button } from "../src/Components/Input/Button"

export const preview = {
    render: () => <frame Size={UDim2.fromOffset(200, 200)} BackgroundColor3={Color3.fromRGB(50, 100, 100)}>
        {/* <Button text="Hello World" /> */}
    </frame>,
    title: "Button",
} as const;
