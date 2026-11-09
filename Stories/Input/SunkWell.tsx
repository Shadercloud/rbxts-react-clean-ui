import React from "@rbxts/react";
import { CleanThemeContext, Container, DeepPartial, extendTheme, Input, Select, ThemeProvider, ThemeTemplate, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const wellBorderColor = Color3.fromHex("#3D2712");
const wellTextColor = Color3.fromHex("#FFF7CF");

const wellGradient = {
    colors: [Color3.fromHex("#173A66"), Color3.fromHex("#214C84"), Color3.fromHex("#295896")],
    stops: [0, 0.45, 1],
    rotation: 90,
};

const disabledGradient = {
    colors: [Color3.fromHex("#3A3A3A"), Color3.fromHex("#4A4A4A"), Color3.fromHex("#555555")],
    stops: [0, 0.45, 1],
    rotation: 90,
};

const wellField = {
    borderColor: wellBorderColor,
    borderThickness: 2,
    cornerRadius: 8,
    backgroundColor: Color3.fromHex("#FFFFFF"),
    backgroundTransparency: 0,
    backgroundImage: { image: "" },
    backgroundGradient: wellGradient,
    boxShadow: { shadow: "0px 1px 0px 0px" as const, color: Color3.fromHex("#A87A45"), transparency: 0 },
    innerShadow: { color: Color3.fromHex("#000000"), transparency: 0.5, size: 8 },
    states: {
        focus: { borderColor: Color3.fromHex("#F2A65A") },
        disabled: { borderColor: Color3.fromHex("#2A2A2A"), backgroundGradient: disabledGradient },
    },
};

const sunkWellOverrides: DeepPartial<ThemeTemplate> = {
    components: {
        input: {
            ...wellField,
            typography: { color: wellTextColor },
            placeholder: { color: Color3.fromHex("#8FA6C4") },
            iconColor: wellTextColor,
        },
        select: {
            ...wellField,
            textColor: wellTextColor,
            iconColor: wellTextColor,
            caret: {
                size: 30,
                backgroundColor: Color3.fromHex("#173A66"),
                borderColor: wellBorderColor,
                borderThickness: 2,
                cornerRadius: 6,
                iconColor: wellTextColor,
                margin: "0px -6px 0px 0px",
            },
            dropDownBackgroundColor: Color3.fromHex("#214C84"),
            dropDown: {
                cornerRadius: 8,
                borderThickness: 2,
                borderColor: wellBorderColor,
                boxShadow: { shadow: "0px 6px 14px 0px", color: Color3.fromHex("#000000"), transparency: 0.5 },
                gap: 6,
            },
            intents: { primary: { focus: { backgroundColor: Color3.fromHex("#3A6DB0") } } },
        },
    },
};

function SunkWell(props: { screenshot?: boolean; disabled?: boolean } = {}) {
    const activeTheme = React.useContext(CleanThemeContext);
    const wellTheme = React.useMemo(() => extendTheme(activeTheme, sunkWellOverrides), [activeTheme]);
    const disabled = props.disabled ?? false;

    const content = (
        <Container width={360}>
            <Container name="Panel" width="100%" BackgroundColor3={Color3.fromHex("#6B4423")} BackgroundTransparency={0}>
                <uicorner CornerRadius={new UDim(0, 8)} />
                <uistroke Color={wellBorderColor} Thickness={2} ApplyStrokeMode={Enum.ApplyStrokeMode.Border} />
                <uipadding PaddingTop={new UDim(0, 16)} PaddingBottom={new UDim(0, 16)} PaddingLeft={new UDim(0, 16)} PaddingRight={new UDim(0, 16)} />
                <ThemeProvider theme={wellTheme}>
                    <VStack>
                        <Input placeholder="Character name" value="" icon="user" disabled={disabled} />
                        <Input value="Ironwood Hearth" disabled={disabled} />
                        <Select max-height="200px" disabled={disabled}>
                            <Select.Option text="Timber" />
                            <Select.Option text="Iron" />
                            <Select.Option text="Stone" />
                            <Select.Option text="Wool" />
                        </Select>
                        <Input placeholder="Always disabled" value="" disabled />
                        <Select disabled>
                            <Select.Option text="Always disabled" />
                        </Select>
                    </VStack>
                </ThemeProvider>
            </Container>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = SunkWell;
