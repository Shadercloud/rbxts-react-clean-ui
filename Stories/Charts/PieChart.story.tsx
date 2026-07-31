import React from "@rbxts/react";
import { Pie, Container, createStory, Card, Text, Button } from "@rbxts/react-clean-ui";

export = createStory((props) => (

    <Container center>
        <Card>
            <Card.Header>
                <Text text="Pie Chart Example" variant="heading" />
            </Card.Header>
            <Card.Body>
                <Container height={300} width={300}>
                    <Pie
                        label-spacing="xs"
                        label-distance={0.3}
                        label-hover
                        //label-hidden
                        hover-darken={0.2}
                        values={[
                            { value: 30, label: "Green" },
                            { value: 40, label: "Red" },
                            {
                                value: 50, label: {
                                    text: "Yellow",
                                    BackgroundColor3: Color3.fromHex("#FAD5A5")
                                }
                            },
                            {
                                value: 5, label: {
                                    content: <Button icon="check-square" text="Hello Blue" intent="info" />
                                }
                            },



                        ]}
                        onChangeSelected={(index, value) => {

                        }}
                        onClick={(index, value) => {

                        }}
                    />
                </Container>
            </Card.Body>
        </Card>
    </Container>
));