import React, { useState } from "@rbxts/react";
import { Box, Card, Container, createStory, Draggable, Droppable, FlexItem, HStack, Icon, Text, VStack, CleanThemeContext, Button, IconName, DroppableRegistration, DroppableContext, Fieldset, Select, Intent } from "@rbxts/react-clean-ui";


interface DemoItem {
    name: string;
    icon: IconName;
}


function DropZone(props: {
    hovered?: DroppableRegistration,
    children?: React.ReactNode
}) {
    const theme = React.useContext(CleanThemeContext);
    const context = React.useContext(DroppableContext)

    const isHovered =
        props.hovered !== undefined &&
        context?.registration !== undefined &&
        props.hovered.guiObject ===
        context.registration.guiObject;

    return <Box Size={UDim2.fromScale(1, 1)}
        box-shadow="0"
        BackgroundColor3={theme.components.draggable.placeholder.backgroundColor}
        BackgroundTransparency={isHovered ? 0 : 1}>
        {props.children}
    </Box>
}

const initialBackpack: DemoItem[] = [
    {
        name: "Apple",
        icon: "apple",
    },
    {
        name: "Bathtub",
        icon: "bath",
    },
    {
        name: "Automobile",
        icon: "automobile",
    },
];

function dragAndDrop() {
    const [backpack, setBackpack] = useState<DemoItem[]>([
        ...initialBackpack,
    ]);

    const [basket, setBasket] = useState<DemoItem[]>([]);

    const [hovered, setHovered] = useState<DroppableRegistration | undefined>(undefined);

    const [windowIntent, setWindowIntent] = useState<Intent>("primary")

    return <>
        <Container width="300" height="400" top="5" left="5">
            <Box>
                <VStack>
                    <Container>
                        <HStack valign="Center">
                            <Icon icon="shopping-basket" />
                            <Text text="Basket" variant="title" />
                            <FlexItem align="Right">
                                <Button icon="refresh" scale="sm" spacing="sm" Event={{
                                    Activated: () => {
                                        setBackpack([...initialBackpack]);
                                        setBasket([]);
                                    }
                                }} />
                            </FlexItem>
                        </HStack>
                    </Container>
                    {basket.map((item, index) =>
                        <Container LayoutOrder={index}>
                            <Box box-shadow="0">
                                <HStack>
                                    <Button.Icon icon={item.icon} />
                                    <Button.Text text={item.name} />
                                </HStack>
                            </Box>
                        </Container>
                    )}
                    <Droppable
                        id="basket"
                        onDrop={(draggedObject) => {
                            print("Dropped:", draggedObject);
                        }}>
                        <FlexItem LayoutOrder={99}>
                            <DropZone hovered={hovered}>
                                <Container center>
                                    <Text text="Drop Zone"></Text>
                                </Container>
                            </DropZone>
                        </FlexItem>
                    </Droppable>


                    <Droppable
                        id="trash"
                        onDrop={(draggedObject) => {
                            print("Dropped:", draggedObject);
                        }}>
                        <Container LayoutOrder={100}>
                            <DropZone hovered={hovered}>
                                <HStack>
                                    <Icon icon="trash" />
                                    <Text text="Trash Can" />
                                </HStack>
                            </DropZone>
                        </Container>
                    </Droppable>
                </VStack>
            </Box>

        </Container>
        <Container width="300" height="300" top="5" right="5">
            <Box>
                <VStack>
                    <Container>
                        <HStack valign="Center">
                            <Icon icon="shopping-bag" />
                            <Text text="Backpack" variant="title" />
                        </HStack>
                    </Container>
                    {backpack.map((item, index) =>
                        <Container LayoutOrder={index}>
                            <Draggable
                                onDropped={(droppableRegistry) => {
                                    if (droppableRegistry !== undefined) {
                                        if (droppableRegistry.id === "basket")
                                            basket.push(item)
                                        backpack.remove(index)
                                    }
                                    setHovered(undefined)
                                }}
                                onDragged={(droppableRegistry) => {
                                    setHovered(droppableRegistry)
                                }}>
                                <Container width="100%">
                                    <Draggable.Handle>
                                        <Container width="100%">
                                            <Box box-shadow="0">
                                                <HStack>
                                                    <Button.Icon icon={item.icon} />

                                                    <Button.Text text={item.name} />
                                                </HStack>
                                            </Box>
                                        </Container>
                                    </Draggable.Handle>
                                </Container>
                            </Draggable>
                        </Container>
                    )}

                </VStack>
            </Box>

        </Container>
        <Draggable
            retainPosition
            placeholder={false}
        >
            <Container
                width="300"
                height="300"
                center>

                <Card intent={windowIntent}>
                    <Draggable.Handle>
                        <Card.Header>
                            <HStack>
                                <Text text="Draggable Window" variant="heading" />
                                <FlexItem align="Right">
                                    <Icon icon="arrows" />
                                </FlexItem>
                            </HStack>
                        </Card.Header>
                    </Draggable.Handle>
                    <Card.Body>
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

        </Draggable>
    </>
}
export = createStory(dragAndDrop);