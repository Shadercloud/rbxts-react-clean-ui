import React from "@rbxts/react";
import { Box, Button, Container, HStack, Icon, IconName, DefaultIconSet, Scroller } from "@rbxts/react-clean-ui";

const entries = [] as Array<[IconName, number]>;

for (const [icon, assetId] of pairs(DefaultIconSet)) {
    entries.push([icon, assetId]);
}

entries.sort((a, b) => a[0] < b[0]);

const icons = entries.map(([icon]) => (
    <Button key={icon}>
        <Icon icon={icon} color={Color3.fromHex("#000000")} scale="xl" />
    </Button>
));

function AllIcons() {
    return <Container
        BackgroundColor3={new Color3(1, 1, 1)}
        BackgroundTransparency={0}
        BorderSizePixel={0}
        width="90%"
        height="300"
        >
        <Box>
            <Scroller>
                <HStack>
                    {icons}
                </HStack>
            </Scroller>
        </Box>
    </Container>
}

export = AllIcons;
