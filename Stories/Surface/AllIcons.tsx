import React from "@rbxts/react";
import { Box, Button, Container, HStack, IconName, DefaultIconSet, Scroller } from "@rbxts/react-clean-ui";

const entries = [] as Array<[IconName, number]>;

for (const [icon, assetId] of pairs(DefaultIconSet)) {
    entries.push([icon, assetId]);
}

entries.sort((a, b) => a[0] < b[0]);

const icons = entries.map(([icon]) => (
    <Button key={icon} icon={icon} scale="xl" />
));

function AllIcons() {
    return <Box width="100%" height="100%">
        <Scroller>
            <HStack>
                {icons}
            </HStack>
        </Scroller>
    </Box>

}

export = AllIcons;
