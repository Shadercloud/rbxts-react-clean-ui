import React from "@rbxts/react";
import { useTween } from "@rbxts/react-ripple";
import { CleanThemeContext } from "../../Contexts";
import { FieldsetContext } from "../Layout";
import { Corners, BoxShadow } from "../Decorator";
import { ColorHelper, SizeHelper } from "../../Helpers";
import { BackgroundElementProps, IntentElementProps, ZIndexElementProps } from "../../Interfaces";

export interface SwitchProps extends IntentElementProps, BackgroundElementProps, ZIndexElementProps {
    checked?: boolean;
    defaultChecked?: boolean;
    onChange?: (value: boolean) => void;
    disabled?: boolean;
    name?: string;
    LayoutOrder?: number;
}

function lerpUDim(from: UDim, to: UDim, alpha: number): UDim {
    return new UDim(
        from.Scale + (to.Scale - from.Scale) * alpha,
        from.Offset + (to.Offset - from.Offset) * alpha,
    );
}

export function Switch(props: SwitchProps) {
    const theme = React.useContext(CleanThemeContext);
    const fieldset = React.useContext(FieldsetContext);
    const switchTheme = theme.components.switch;

    const controlled = props.checked !== undefined;
    const [internalChecked, setInternalChecked] = React.useState(props.defaultChecked ?? false);
    const checked = controlled ? props.checked === true : internalChecked;

    const requestChange = (value: boolean) => {
        if (props.disabled) {
            return;
        }

        if (!controlled) {
            setInternalChecked(value);
        }

        props.onChange?.(value);
    };

    const toggleRef = React.useRef<() => void>();
    toggleRef.current = () => requestChange(!checked);

    React.useEffect(() => {
        if (!fieldset) {
            return;
        }

        const connection = fieldset.labelActivated?.Event.Connect(() => {
            toggleRef.current?.();
        });

        return () => {
            connection?.Disconnect();
        };
    }, [fieldset]);

    const duration = switchTheme.animation.duration;

    const [progress, progressTween] = useTween(checked ? 1 : 0, { duration });

    React.useEffect(() => {
        const goal = checked ? 1 : 0;
        progressTween.setGoal(goal, { duration });
        if (duration === 0) {
            progressTween.setPosition(goal);
        }
        progressTween.start();
    }, [checked, duration, progressTween]);

    const onColors = ColorHelper.getIntentColors(
        theme,
        props.intent,
        props.disabled ? "disabled" : "default",
        switchTheme.track.intents,
    );

    const offBackgroundColor = switchTheme.track.backgroundColor;
    const offBorderColor = switchTheme.track.borderColor;

    const trackBackgroundColor = progress.map((value) =>
        offBackgroundColor.Lerp(onColors.backgroundColor, value));

    const trackBorderColor = progress.map((value) =>
        offBorderColor.Lerp(onColors.borderColor, value));

    const trackWidth = SizeHelper.toUDim(switchTheme.width);
    const trackHeight = SizeHelper.toUDim(switchTheme.height);
    const inset = SizeHelper.toUDim(switchTheme.thumb.inset);
    const insetDoubled = inset.add(inset);
    const thumbDiameter = trackHeight.sub(insetDoubled);

    const thumbOffX = inset;
    const thumbOnX = trackWidth.sub(inset).sub(thumbDiameter);

    const thumbPosition = progress.map((value) =>
        new UDim2(lerpUDim(thumbOffX, thumbOnX, value), new UDim(0.5, 0)));

    return (
        <imagebutton
            key={props.name ?? "Switch"}
            Active={!props.disabled}
            Selectable={!props.disabled}
            AutoButtonColor={false}
            Size={new UDim2(trackWidth, trackHeight)}
            ZIndex={props.ZIndex}
            LayoutOrder={props.LayoutOrder}
            BorderSizePixel={0}
            BackgroundColor3={trackBackgroundColor}
            BackgroundTransparency={
                props.disabled
                    ? switchTheme.disabledTransparency
                    : props.BackgroundTransparency ?? switchTheme.track.backgroundTransparency
            }
            Event={{
                Activated: () => {
                    requestChange(!checked);
                },
            }}
        >
            <Corners radius={switchTheme.cornerRadius} />
            <uistroke
                key="TrackStroke"
                Thickness={switchTheme.borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={trackBorderColor}
            />

            <frame
                key="Thumb"
                Position={thumbPosition}
                AnchorPoint={new Vector2(0, 0.5)}
                Size={new UDim2(thumbDiameter, thumbDiameter)}
                BackgroundColor3={switchTheme.thumb.backgroundColor}
                BackgroundTransparency={
                    props.disabled
                        ? switchTheme.disabledTransparency
                        : switchTheme.thumb.backgroundTransparency
                }
                BorderSizePixel={0}
            >
                <uistroke
                    key="ThumbStroke"
                    Thickness={switchTheme.thumb.borderThickness}
                    Color={switchTheme.thumb.borderColor}
                />

                <Corners radius={switchTheme.thumb.cornerRadius} />

                <BoxShadow box-shadow={switchTheme.thumb.boxShadow} />
            </frame>
        </imagebutton>
    );
}
