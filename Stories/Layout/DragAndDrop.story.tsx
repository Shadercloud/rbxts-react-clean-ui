import React, { useState } from "@rbxts/react";
import { Box, Container, createStory, Draggable, Droppable, FlexItem, HStack, Icon, Text, VStack, CleanThemeContext, Button, IconName, DroppableRegistration, DroppableContext, Fieldset, Select, Intent } from "@rbxts/react-clean-ui";


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

    return <Box 
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

    return <>
        <Container width="300" height="400" top="5" left="5">
            <Box>
                <VStack>
                    <Container>
                        <HStack valign="Center">
                            <Icon icon="shopping-basket" LayoutOrder={1} />
                            <Text text="Basket" variant="title" LayoutOrder={2} />
                            <FlexItem align="Right" LayoutOrder={3}>
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
                            <Draggable
                                onDropped={(droppableRegistry) => {
                                    if (droppableRegistry !== undefined) {
                                        if (droppableRegistry.id === "trash")
                                            basket.remove(index)

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
        <Draggable placeholder={false} retainPosition>
            <Container width="300" height="300" top="5" right="5">
                <Box>
                    <VStack>
                        <Draggable.Handle>
                            <Container>
                                <HStack valign="Center">
                                    <Icon icon="shopping-bag" />
                                    <Text text="Backpack" variant="title" />
                                </HStack>
                            </Container>
                        </Draggable.Handle>
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
        </Draggable>

    </>
}
export = createStory(dragAndDrop);