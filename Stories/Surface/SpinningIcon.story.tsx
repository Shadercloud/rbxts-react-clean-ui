import React, { useState } from "@rbxts/react";
import { Box, Button, Container, createStory, HStack, Icon, IconName, DefaultIconSet, Scroller, Text, FlexItem } from "@rbxts/react-clean-ui";


function spinningIcons() {
    const [loading, setLoading] = useState(false);

    return <Container
        width="50%"
        center
    >
        <Box>
            <HStack valign="Center">
                <FlexItem>
                    <Button intent="success" Event={{
                        Activated: () => {
                            setLoading(!loading);
                        }
                    }}>
                        <HStack>
                            <Button.Icon icon="circle-o-notch" intent="success" spinning={loading} />
                            <Button.Text text={loading ? "Spinning!" : "Click to Spin"} intent="success" />
                        </HStack>

                    </Button>
                </FlexItem>
                {loading &&
                    <Icon scale="xl" icon="spinner" spinning={loading} color={new Color3(0, 0, 0)} />
                }
            </HStack>
        </Box>
    </Container>
}

export = createStory(spinningIcons);