import React from "@rbxts/react";
import { ThemeTemplate } from "../Theme/theme.template";
import { DefaultTheme } from "../Theme/themes/default.theme";

export const CleanThemeContext = React.createContext<ThemeTemplate>(DefaultTheme);