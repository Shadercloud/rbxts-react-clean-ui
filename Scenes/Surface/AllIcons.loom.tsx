import React from "@rbxts/react";
import { Icon } from "../../src/Components/Surface/Icon";
import { Button } from "../../src/Components/Input/Button";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { Scroller } from "../../src/Components/Layout/Scroller";
import { Box } from "../../src/Components/Surface/Box";
import { DefaultIconSet } from "../../src/Theme";
import { IconName } from "../../src/Interfaces";
import { LoomScene } from "../LoomScene";

const entries = [] as Array<[IconName, number]>;

for (const [icon, assetId] of pairs(DefaultIconSet)) {
    entries.push([icon, assetId]);
}

entries.sort((a, b) => a[0] < b[0]);

const icons = entries.map(([icon]) => (
    <Button key={icon}>
        <Icon icon={icon} scale="xl" />
    </Button>
));

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="90%" height="360" center>
                <Box>
                    <Scroller>
                        <HStack>
                            {icons}
                        </HStack>
                    </Scroller>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/All Icons",
} as const;
