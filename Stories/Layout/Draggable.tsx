import React, { useState } from "@rbxts/react";
import { Card, Container, Draggable as DraggableComponent, FlexItem, HStack, Icon, Text, Button, Fieldset, Select, Intent } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function Draggable(props: { screenshot?: boolean } = {}) {
    const [windowIntent, setWindowIntent] = useState<Intent>("primary")
    const [windowMinimized, setWindowMinimized] = useState<boolean>(false)

    const content = (
        <Container width={340} height={280}>
            <DraggableComponent
                retainPosition
                placeholder={false}
            >
                <Container
                    width="300"
                    center>

                    <Card intent={windowIntent}>
                        <DraggableComponent.Handle>
                            <Card.Header>
                                <HStack valign="Center">
                                    <Text text="Draggable Window" variant="heading" />
                                    <FlexItem align="Right">
                                        <Button icon="window-minimize" scale="xs" intent={windowIntent} Event={{
                                            Activated: () => {
                                                setWindowMinimized(!windowMinimized);
                                            }
                                        }} />
                                    </FlexItem>
                                    <Icon icon="arrows" />
                                </HStack>
                            </Card.Header>
                        </DraggableComponent.Handle>
                        <Card.Body Visible={!windowMinimized}>
                            <Fieldset >
                                <Fieldset.Label>
                                    <Text text="Select Window Intent:" />
                                </Fieldset.Label>
                                <Fieldset.Control>
                                    <Select onChange={(selected, value) => {
                                        setWindowIntent(value as Intent);
                                    }}>
                                        <Select.Option text="Primary" value="primary" />
                                        <Select.Option text="Success" value="success" />
                                        <Select.Option text="Info" value="info" />
                                        <Select.Option text="Warning" value="warning" />
                                        <Select.Option text="Danger" value="danger" />
                                    </Select>
                                </Fieldset.Control>
                            </Fieldset>
                        </Card.Body>
                        <Card.Footer>
                            <Button text="Click Me" intent={windowIntent} />
                        </Card.Footer>
                    </Card>
                </Container>

            </DraggableComponent>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Draggable;
