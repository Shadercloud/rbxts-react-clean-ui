import { CleanTheme } from "../CleanTheme";

const font = Enum.Font.Jura;

export const DarkTheme: CleanTheme = {
    colors: {
        intents: {
            primary: {
                text: Color3.fromHex("#E8EDF8"),
                textMuted: Color3.fromHex("#A7B1C2"),
                background: Color3.fromHex("#4B7BE5"),
                hover: Color3.fromHex("#5B8AF0"),
                pressed: Color3.fromHex("#3A69D0"),
                foreground: Color3.fromHex("#FFFFFF"),
                border: Color3.fromHex("#5A8BF0"),
            },

            success: {
                text: Color3.fromHex("#52D98A"),
                background: Color3.fromHex("#2FA96A"),
                hover: Color3.fromHex("#3AB979"),
                pressed: Color3.fromHex("#258A56"),
                foreground: Color3.fromHex("#FFFFFF"),
                border: Color3.fromHex("#258A56"),
            },

            danger: {
                text: Color3.fromHex("#FF7A7A"),
                background: Color3.fromHex("#D94B4B"),
                hover: Color3.fromHex("#E55A5A"),
                pressed: Color3.fromHex("#B93A3A"),
                foreground: Color3.fromHex("#FFFFFF"),
                border: Color3.fromHex("#B93A3A"),
            },

            warning: {
                text: Color3.fromHex("#FFD46B"),
                background: Color3.fromHex("#D9A531"),
                hover: Color3.fromHex("#E8B53F"),
                pressed: Color3.fromHex("#B68522"),
                foreground: Color3.fromHex("#1A1A1A"),
                border: Color3.fromHex("#B68522"),
            },

            info: {
                text: Color3.fromHex("#7CC6FF"),
                background: Color3.fromHex("#3C92D6"),
                hover: Color3.fromHex("#4EA2E4"),
                pressed: Color3.fromHex("#2F79B4"),
                foreground: Color3.fromHex("#FFFFFF"),
                border: Color3.fromHex("#2F79B4"),
            },
        }
    },

    default: {
        scale: "md",
        spacing: "md",
    },

    breakpoints: {
        xs: 100,
        sm: 200,
        md: 300,
        lg: 400,
        xl: 500,
    },

    spacing: {
        xs: 4,
        sm: 8,
        md: 12,
        lg: 16,
        xl: 24,
    },

    radius: {
        sm: 4,
        md: 8,
        lg: 12,
        default: "md",
    },

    typography: {
        display: {
            font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size48,
            lineHeight: 1.1,
        },
        title: {
            font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size32,
            lineHeight: 1.2,
        },
        heading: {
            font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size24,
            lineHeight: 1.25,
        },
        body: {
            font,
            size: Enum.FontSize.Size18,
            lineHeight: 1.4,
        },
        label: {
            font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size14,
            lineHeight: 1.2,
        },
        caption: {
            font,
            size: Enum.FontSize.Size10,
            lineHeight: 1.3,
        },
    },

    typeScaleMap: {
        xs: "caption",
        sm: "label",
        md: "body",
        lg: "heading",
        xl: "title"
    },

    components: {
        scroller: {
            barColor: Color3.fromHex("#FFFFFF")
        },
        boxShadow: {
            color: Color3.fromHex("#000000"),
            transparency: 0.55,
        },

        box: {
            backgroundColor: Color3.fromHex("#1E222B"),
            backgroundTransparency: 0,
            borderColor: Color3.fromHex("#353C49"),
            borderThickness: 1,
            cornerRadius: 8,
            boxShadow: "2px 2px 8px 0px",
        },

        button: {
            textColor: Color3.fromHex("#FFFFFF"),
            backgroundTransparency: 0,
            borderThickness: 1,
            cornerRadius: 8,
        },
        input: {
            borderColor: Color3.fromHex("#353C49"),
            borderThickness: 1,
            cornerRadius: 8,
        },
        select: {
            dropDownBackgroundColor: Color3.fromHex("#1E222B"),
            borderColor: Color3.fromHex("#353C49"),
            borderThickness: 1,
            cornerRadius: 8,
        }
    },

    icons: {},
    iconSize: {
        xs: 10,
        sm: 16,
        md: 20,
        lg: 24,
        xl: 30,
    }
};