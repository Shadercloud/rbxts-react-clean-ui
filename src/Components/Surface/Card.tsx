import React, { Component, ReactComponent } from "@rbxts/react";
import { Box, BoxProps } from "./Box";
import { Container, FlexItem, VStack } from "../Layout";
import { ColorHelper, CssHelper, SpacingHelper } from "../../Helpers";
import { CleanThemeContext } from "../../Contexts";
import { Padding } from "../Decorator";
import { Intent, IntentElementProps } from "../../Interfaces";


interface CardContextValue {
    intent?: Intent;
}

const CardContext = React.createContext<CardContextValue>({});

interface CardHeaderProps extends IntentElementProps {
    children?: React.ReactNode;
}

export const CardHeader = React.forwardRef<Frame, CardHeaderProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const card = React.useContext(CardContext);
        const intent = ColorHelper.getIntentColors(theme, props.intent ?? card.intent ?? "primary", "default", theme.components.card.header.intents);
        const padding = SpacingHelper.ResolveNumberPadding(SpacingHelper.GetPadding(theme, "md", theme.components.card.header.spacing));
        const corners = CssHelper.parseCssSize(theme.components.card.cornerRadius);
        return <Container
            ref={ref}
            {...props}
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={intent.backgroundTransparency}
            BackgroundColor3={intent.backgroundColor}
            BorderSizePixel={0}
        >
            <Padding resolvedPadding={padding} />
            <uistroke Thickness={1} Color={intent.borderColor} BorderStrokePosition={Enum.BorderStrokePosition.Inner} />
            <uicorner TopLeftRadius={corners} TopRightRadius={corners} BottomLeftRadius={new UDim(0, 0)} BottomRightRadius={new UDim(0, 0)} />
            {props.children}
        </Container>
    });
interface CardBodyProps extends BoxProps {

}

export const CardBody = React.forwardRef<Frame, CardBodyProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const padding = SpacingHelper.ResolveNumberPadding(SpacingHelper.GetPadding(theme, "md", theme.components.card.header.spacing))
        return <FlexItem>
            <Container
                ref={ref}
                {...props}
                Size={UDim2.fromScale(1, 0)}
                AutomaticSize={Enum.AutomaticSize.Y}>
                <Padding resolvedPadding={padding} />
                {props.children}
            </Container>
        </FlexItem>
    });

interface CardFooterProps extends BoxProps, IntentElementProps {

}

export const CardFooter = React.forwardRef<Frame, CardFooterProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const card = React.useContext(CardContext);
        const intent = ColorHelper.getIntentColors(theme, props.intent ?? card.intent ?? "primary", "default", theme.components.card.footer.intents);
        const padding = SpacingHelper.ResolveNumberPadding(SpacingHelper.GetPadding(theme, "md", theme.components.card.footer.spacing));
        const corners = CssHelper.parseCssSize(theme.components.card.cornerRadius);
        return <Container
            ref={ref}
            {...props}
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={intent.backgroundTransparency}
            BackgroundColor3={intent.backgroundColor}
            BorderSizePixel={0}
        >
            <Padding resolvedPadding={padding} />
            <uistroke Thickness={1} Color={intent.borderColor} BorderStrokePosition={Enum.BorderStrokePosition.Inner} />
            <uicorner TopLeftRadius={new UDim(0, 0)} TopRightRadius={new UDim(0, 0)} BottomLeftRadius={corners} BottomRightRadius={corners} />
            {props.children}
        </Container>
    });

interface CardProps extends BoxProps, IntentElementProps {

}

@ReactComponent
export class Card extends Component<CardProps> {
    static Header = CardHeader;
    static Footer = CardFooter;
    static Body = CardBody;

    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;

    render() {
        const contextValue: CardContextValue = {
            intent: this.props.intent,
        };
        return (
            <CardContext.Provider value={contextValue}>
                <Box {...this.props} ref={this.props.ref} spacing="None">
                    <VStack spacing="None">
                        {this.props.children}
                    </VStack>
                </Box>
            </CardContext.Provider>
        );
    }
}