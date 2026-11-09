import React from "@rbxts/react";
import { Checkbox } from "../../src/Components/Input/Checkbox";
import { HStack } from "../../src/Components/Layout/HStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="140" center>
                <Box>
                    <HStack>
                        <Checkbox defaultChecked={false} />
                        <Checkbox defaultChecked={true} />
                        <Checkbox
                            defaultChecked={true}
                            intent-checked="success"
                            intent-unchecked="danger"
                            icon-unchecked="times"
                        />
                    </HStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Checkbox",
} as const;
