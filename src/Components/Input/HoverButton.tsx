import React from "@rbxts/react";
import { ButtonFlag } from "../../Interfaces";

export interface HoverButtonContextValue {
    hover: boolean;
    isSelected: boolean;
}

export const HoverButtonContext = React.createContext<HoverButtonContextValue | undefined>(
    undefined,
);

type ImageButtonProps = React.InstanceProps<ImageButton>;

interface HoverButtonProps {
    default: ImageButtonProps;
    hover?: ImageButtonProps;
    focus?: ImageButtonProps;
    isSelected?: boolean;
    children?: React.ReactNode;
}

export function HoverButton(propSet: HoverButtonProps) {
    const [hovering, setHovering] = React.useState(false);

    const state: ButtonFlag = propSet.isSelected
        ? "focus"
        : hovering
            ? "hover"
            : "default";


    const stateProps = propSet[state];


    // Object spreading into a new object is supported.
    // It is object rest destructuring that roblox-ts does not support.
    const props: ImageButtonProps = {
        ...propSet.default,
        ...stateProps,
    };

    const defaultEvents = propSet.default.Event;
    const stateEvents = stateProps?.Event;

    return (
        <HoverButtonContext.Provider value={{
            hover: hovering,
            isSelected: propSet.isSelected === true
        }}>
            <imagebutton
                Active={props.Active}
                AnchorPoint={props.AnchorPoint}
                Archivable={props.Archivable}
                AutoButtonColor={props.AutoButtonColor}
                AutomaticSize={props.AutomaticSize}
                BackgroundColor3={props.BackgroundColor3}
                BackgroundTransparency={props.BackgroundTransparency}
                BorderColor3={props.BorderColor3}
                BorderMode={props.BorderMode}
                BorderSizePixel={props.BorderSizePixel}
                ClipsDescendants={props.ClipsDescendants}
                LayoutOrder={props.LayoutOrder}
                NextSelectionDown={props.NextSelectionDown}
                NextSelectionLeft={props.NextSelectionLeft}
                NextSelectionRight={props.NextSelectionRight}
                NextSelectionUp={props.NextSelectionUp}
                Position={props.Position}
                Rotation={props.Rotation}
                Selectable={props.Selectable}
                SelectionBehaviorDown={props.SelectionBehaviorDown}
                SelectionBehaviorLeft={props.SelectionBehaviorLeft}
                SelectionBehaviorRight={props.SelectionBehaviorRight}
                SelectionBehaviorUp={props.SelectionBehaviorUp}
                SelectionGroup={props.SelectionGroup}
                Size={props.Size}
                SizeConstraint={props.SizeConstraint}
                Visible={props.Visible}
                ZIndex={props.ZIndex}
                Image={props.Image}
                ImageColor3={props.ImageColor3}
                ImageRectOffset={props.ImageRectOffset}
                ImageRectSize={props.ImageRectSize}
                ImageTransparency={props.ImageTransparency}
                ResampleMode={props.ResampleMode}
                ScaleType={props.ScaleType}
                SliceCenter={props.SliceCenter}
                SliceScale={props.SliceScale}
                TileSize={props.TileSize}
                Event={{
                    ...defaultEvents,
                    ...stateEvents,

                    MouseEnter: (button, x, y) => {
                        setHovering(true);

                        stateEvents?.MouseEnter?.(button, x, y);

                        if (stateEvents !== defaultEvents) {
                            defaultEvents?.MouseEnter?.(button, x, y);
                        }
                    },

                    MouseLeave: (button, x, y) => {
                        setHovering(false);

                        stateEvents?.MouseLeave?.(button, x, y);

                        if (stateEvents !== defaultEvents) {
                            defaultEvents?.MouseLeave?.(button, x, y);
                        }
                    },
                }}
                Change={props.Change}
                Tag={props.Tag}
            >
                {propSet.children}
            </imagebutton>
        </HoverButtonContext.Provider>
    );
}