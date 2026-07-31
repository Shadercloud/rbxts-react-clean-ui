import React from "@rbxts/react";
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
            Size={UDim2.fromScale(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
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
                Size={UDim2.fromScale(0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}>
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
            Size={UDim2.fromScale(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
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


type CardComponent = React.ForwardRefExoticComponent<
    CardProps & React.RefAttributes<Frame>
> & {
    Header: typeof CardHeader;
    Footer: typeof CardFooter;
    Body: typeof CardBody;
};

const Card = React.forwardRef<Frame, CardProps>(
    (props, ref) => {

        const theme = React.useContext(CleanThemeContext);

        const contextValue = React.useMemo<CardContextValue>(
            () => ({
                intent: props.intent,
            }),
            [props.intent],
        );

        const intent = ColorHelper.getIntentColors(theme, props.intent ?? "primary", "default", theme.components.card.header.intents);
        return (
            <CardContext.Provider value={contextValue}>
                <Box {...props} ref={ref} spacing="None" border-color={intent.borderColor}>
                    <VStack spacing="None">
                        {props.children}
                    </VStack>
                </Box>
            </CardContext.Provider>
        );
    }) as CardComponent;

Card.Header = CardHeader;
Card.Footer = CardFooter;
Card.Body = CardBody;

export { Card };