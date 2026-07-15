import React from "@rbxts/react";
import { CleanTheme } from "../Theme/CleanTheme";
import { DefaultTheme } from "../Theme/themes/default.theme";

export const CleanThemeContext = React.createContext<CleanTheme>(DefaultTheme);