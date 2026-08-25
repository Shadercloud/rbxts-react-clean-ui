import React from "@rbxts/react";
import { Box, Menu as MenuComponent } from "@rbxts/react-clean-ui";

interface MenuProps {
    title?: string;
}

function Menu(props: MenuProps = {}) {
    return <Box
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

}

export = Menu;
