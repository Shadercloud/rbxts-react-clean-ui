-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local createTheme = TS.import(script, script.Parent.Parent, "theme.factory").createTheme
local font = Enum.Font.PatrickHand
local WoodenTheme = createTheme({
	typography = {
		display = {
			font = font,
			size = Enum.FontSize.Size60,
		},
		title = {
			font = font,
			size = Enum.FontSize.Size48,
		},
		heading = {
			font = font,
			size = Enum.FontSize.Size32,
		},
		body = {
			font = font,
			size = Enum.FontSize.Size24,
		},
		label = {
			font = font,
			size = Enum.FontSize.Size18,
		},
		caption = {
			font = font,
			size = Enum.FontSize.Size14,
		},
	},
	colors = {
		intents = {
			primary = {
				default = {
					textColor = Color3.fromHex("#FFF7CF"),
				},
			},
		},
	},
	components = {
		button = {
			cornerRadius = 0,
			backgroundTransparency = 1,
			borderThickness = 0,
			intents = {
				primary = {
					default = {
						textColor = Color3.fromHex("#FFF7CF"),
						backgroundImage = {
							image = 92016395170536,
							slice = "10 5 240 40",
							tintColor = Color3.fromHex("#A16B30"),
						},
					},
					hover = {
						backgroundImage = {
							tintColor = Color3.fromHex("#BA854A"),
						},
					},
					disabled = {
						textColor = Color3.fromHex("#a4a29f"),
						backgroundImage = {
							transparency = 0.3,
						},
					},
				},
				success = {
					default = {
						backgroundImage = {
							tintColor = Color3.fromHex("#63ff00"),
						},
					},
					hover = {
						backgroundImage = {
							tintColor = Color3.fromHex("#29ff52"),
						},
					},
				},
				info = {
					default = {
						backgroundImage = {
							tintColor = Color3.fromHex("#00bfff"),
						},
					},
					hover = {
						backgroundImage = {
							tintColor = Color3.fromHex("#29d4ff"),
						},
					},
				},
				warning = {
					default = {
						backgroundImage = {
							tintColor = Color3.fromHex("#ffbf00"),
						},
					},
					hover = {
						backgroundImage = {
							tintColor = Color3.fromHex("#ffd429"),
						},
					},
				},
				danger = {
					default = {
						backgroundImage = {
							tintColor = Color3.fromHex("#ff0000"),
						},
					},
					hover = {
						backgroundImage = {
							tintColor = Color3.fromHex("#ff2929"),
						},
					},
				},
			},
		},
		box = {
			borderThickness = 0,
			boxShadow = 0,
			cornerRadius = 0,
			padding = "35px 40px 40px 40px",
			backgroundImage = {
				image = 89050878990049,
				slice = "54 55 969 565",
			},
		},
	},
})
return {
	WoodenTheme = WoodenTheme,
}
