import React from "@rbxts/react";
import { PinTextSize } from "../../src/Components/Typography/PinTextSize";
import { Text } from "../../src/Components/Typography/Text";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { CleanThemeContext } from "../../src/Contexts";
import { CleanUiProvider } from "../../src/Providers/app.provider";
import { LoomScene } from "../LoomScene";

function PinnedTextDemo() {
    const theme = React.useContext(CleanThemeContext);

    return (
        <CleanUiProvider theme={theme} toasts={false} ignorePreferredTextSize>
            <Container width="100%" height="160" center>
                <Box>
                    <VStack spacing="sm">
                        <textlabel
                            AutomaticSize={Enum.AutomaticSize.XY}
                            BackgroundTransparency={1}
                            Size={new UDim2()}
                            Text="Native textlabel pinned to 18px"
                            TextColor3={theme.typography.body.color ?? new Color3(0, 0, 0)}
                            TextSize={18}
                        >
                            <PinTextSize size={18} />
                        </textlabel>
                        <Text text="Library Text pins its own size" />
                    </VStack>
                </Box>
            </Container>
        </CleanUiProvider>
    );
}

export const preview = {
    render: () => (
        <LoomScene>
            <PinnedTextDemo />
        </LoomScene>
    ),
    title: "Typography/Pin Text Size",
} as const;
