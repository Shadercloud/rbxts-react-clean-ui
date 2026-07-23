-- Compiled with roblox-ts v3.0.0
local font = Enum.Font.Jura
local DarkTheme = {
	colors = {
		intents = {
			primary = {
				default = {
					textColor = Color3.fromHex("#E8EDF8"),
					borderColor = Color3.fromHex("#5A8BF0"),
					backgroundColor = Color3.fromHex("#4B7BE5"),
				},
				hover = {
					textColor = Color3.fromHex("#5B8AF0"),
					borderColor = Color3.fromHex("#5A8BF0"),
					backgroundColor = Color3.fromHex("#4B7BE5"),
				},
			},
			success = {
				default = {
					textColor = Color3.fromHex("#52D98A"),
					borderColor = Color3.fromHex("#258A56"),
					backgroundColor = Color3.fromHex("#2FA96A"),
				},
				hover = {
					textColor = Color3.fromHex("#3AB979"),
					borderColor = Color3.fromHex("#258A56"),
					backgroundColor = Color3.fromHex("#2FA96A"),
				},
			},
			danger = {
				default = {
					textColor = Color3.fromHex("#FF7A7A"),
					borderColor = Color3.fromHex("#B93A3A"),
					backgroundColor = Color3.fromHex("#D94B4B"),
				},
				hover = {
					textColor = Color3.fromHex("#E55A5A"),
					borderColor = Color3.fromHex("#B93A3A"),
					backgroundColor = Color3.fromHex("#D94B4B"),
				},
			},
			warning = {
				default = {
					textColor = Color3.fromHex("#FFD46B"),
					borderColor = Color3.fromHex("#B68522"),
					backgroundColor = Color3.fromHex("#D9A531"),
				},
				hover = {
					textColor = Color3.fromHex("#E8B53F"),
					borderColor = Color3.fromHex("#B68522"),
					backgroundColor = Color3.fromHex("#D9A531"),
				},
			},
			info = {
				default = {
					textColor = Color3.fromHex("#7CC6FF"),
					borderColor = Color3.fromHex("#2F79B4"),
					backgroundColor = Color3.fromHex("#3C92D6"),
				},
				hover = {
					textColor = Color3.fromHex("#4EA2E4"),
					borderColor = Color3.fromHex("#2F79B4"),
					backgroundColor = Color3.fromHex("#3C92D6"),
				},
			},
		},
	},
	default = {
		scale = "md",
		spacing = "md",
	},
	breakpoints = {
		xs = 100,
		sm = 200,
		md = 300,
		lg = 400,
		xl = 500,
	},
	spacing = {
		xs = 4,
		sm = 8,
		md = 12,
		lg = 16,
		xl = 24,
	},
	radius = {
		sm = 4,
		md = 8,
		lg = 12,
		default = "md",
	},
	typography = {
		display = {
			font = font,
			weight = Enum.FontWeight.Bold,
			size = Enum.FontSize.Size48,
			lineHeight = 1.1,
		},
		title = {
			font = font,
			weight = Enum.FontWeight.Bold,
			size = Enum.FontSize.Size32,
			lineHeight = 1.2,
		},
		heading = {
			font = font,
			weight = Enum.FontWeight.Bold,
			size = Enum.FontSize.Size24,
			lineHeight = 1.25,
		},
		body = {
			font = font,
			size = Enum.FontSize.Size18,
			lineHeight = 1.4,
		},
		label = {
			font = font,
			weight = Enum.FontWeight.Bold,
			size = Enum.FontSize.Size14,
			lineHeight = 1.2,
		},
		caption = {
			font = font,
			size = Enum.FontSize.Size10,
			lineHeight = 1.3,
		},
	},
	typeScaleMap = {
		xs = "caption",
		sm = "label",
		md = "body",
		lg = "heading",
		xl = "title",
	},
	components = {
		scroller = {
			barColor = Color3.fromHex("#FFFFFF"),
		},
		boxShadow = {
			color = Color3.fromHex("#000000"),
			transparency = 0.55,
		},
		box = {
			backgroundColor = Color3.fromHex("#1E222B"),
			backgroundTransparency = 0,
			borderColor = Color3.fromHex("#353C49"),
			borderThickness = 1,
			cornerRadius = 8,
			boxShadow = "2px 2px 8px 0px",
		},
		button = {
			backgroundTransparency = 0,
			borderThickness = 1,
			cornerRadius = 8,
		},
		input = {
			borderColor = Color3.fromHex("#353C49"),
			borderThickness = 1,
			cornerRadius = 8,
		},
		select = {
			dropDownBackgroundColor = Color3.fromHex("#1E222B"),
			maxDropDownHeight = 200,
			borderColor = Color3.fromHex("#353C49"),
			borderThickness = 1,
			cornerRadius = 8,
		},
		checkbox = {
			borderColor = Color3.fromHex("#353C49"),
			borderThickness = 1,
			cornerRadius = 8,
		},
		tabs = {
			borderColor = Color3.fromHex("#D9DEE8"),
			backgroundColor = Color3.fromHex("#FFFFFF"),
			borderThickness = 0,
			cornerRadius = 0,
			list = {
				backgroundColor = Color3.fromHex("#D9DEE8"),
				borderThickness = 0,
				cornerRadius = 8,
			},
			button = {
				borderThickness = 0,
				cornerRadius = 4,
				intents = {
					primary = {
						default = {
							backgroundColor = Color3.fromHex("#D9DEE8"),
						},
						hover = {
							backgroundColor = Color3.fromHex("#FFFFFF"),
							textColor = Color3.fromHex("#000000"),
						},
						focus = {
							textColor = Color3.fromHex("#000000"),
							backgroundColor = Color3.fromHex("#D9DEE8"),
						},
					},
				},
			},
		},
	},
	icons = {},
	iconSize = {
		xs = 10,
		sm = 16,
		md = 20,
		lg = 24,
		xl = 30,
	},
}
return {
	DarkTheme = DarkTheme,
}
