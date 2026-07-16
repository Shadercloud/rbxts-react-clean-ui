import React from "@rbxts/react";
import { Box, Button, Container, createStory, HStack, Icon, IconName, DefaultIconSet, Scroller } from "@rbxts/react-clean-ui";

const entries = [] as Array<[IconName, number]>;

for (const [icon, assetId] of pairs(DefaultIconSet)) {
    entries.push([icon, assetId]);
}

entries.sort((a, b) => a[0] < b[0]);

const icons = entries.map(([icon]) => (
    <Button key={icon}>
        <Icon icon={icon} color={Color3.fromHex("#000000")} />
    </Button>
));

export = createStory((props) => (
    <Container
        width="90%"
        height="90%"
        center="50%"
    >
        <Box>
            <Scroller>
                <HStack>
                    {icons}
                </HStack>
            </Scroller>
        </Box>
    </Container>
));