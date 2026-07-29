import React from "@rbxts/react";
import { Container, createStory, Button, useToast, Card, Fieldset, HStack, Intent, Select, Text } from "@rbxts/react-clean-ui";

function ToastDemo() {
    const toast = useToast();

    const [intent, setIntent] = React.useState<Intent>("primary")
    return <Container
        width="300"
        center>

        <Card>
            <Card.Header>
                <HStack valign="Center">
                    <Text text="Toast Demo" variant="heading" />
                </HStack>
            </Card.Header>
            <Card.Body>
                <Fieldset >
                    <Fieldset.Label>
                        <Text text="Select Toast Intent:" />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Select onChange={(selected, value) => {
                            setIntent(value as Intent);
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
                <Button text="Show Toast" icon="bullhorn" intent={intent}
                    Event={{
                        Activated: () => {
                            toast.show({
                                title: "Alert Message",
                                description: "This is a test to show the toast system.",
                                intent: intent,
                                icon: intent === "primary" ?
                                    undefined :
                                    intent === "success" ? "thumbs-up" :
                                        intent === "info" ? "question-circle" : "exclamation-circle",
                                duration: 3,
                                dismissible: true,
                            })
                        }
                    }} />
            </Card.Footer>
        </Card>
    </Container>
}
export = createStory(ToastDemo);