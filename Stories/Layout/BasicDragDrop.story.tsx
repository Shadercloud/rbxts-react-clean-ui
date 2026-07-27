import React from "@rbxts/react";
import { Intent, Button, Card, Container, createStory, HStack, Text, Droppable, Box, Draggable } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <>
        <Droppable onDrop={(draggedObject) => {
            print("Draggable object entered: ", draggedObject)
        }}>
            <Container width="300" height="300">
                <Box>
                    <Text text="Drop Zone" />
                </Box>
            </Container>
        </Droppable>
        <Draggable onDropped={(droppable) => {
            print("Dropped onto: ", droppable)
        }}>
            <Container width="300" height="300" right="0">
                <Draggable.Handle>
                    <Box>
                        <Text text="Draggable Element" />
                    </Box>
                </Draggable.Handle>
            </Container>
        </Draggable>
    </>

));