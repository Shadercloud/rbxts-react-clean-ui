import React from "@rbxts/react";
import { Box, Container, Menu as MenuComponent } from "@rbxts/react-clean-ui";

interface MenuProps {
    title?: string;
}

function Menu(props: MenuProps = {}) {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={220} height={300}>
        <Box
            width="Auto"
            height="100%"
        >
            <MenuComponent title={props.title ?? "Main Menu"}>
                <MenuComponent.Item title="New Game" icon="plus-circle"
                    Event={{
                        Activated: () => { print("Clicked New Game") }
                    }} />
                <MenuComponent.Item title="Create Character and Start" icon="user-plus" />
                <MenuComponent.Item title="Load Game " icon="database" />
                <MenuComponent.Item title="Quit" icon="sign-out" />
            </MenuComponent>
        </Box>
    </Container>
}

export = Menu;
