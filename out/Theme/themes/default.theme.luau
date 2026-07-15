-- Compiled with roblox-ts v3.0.0
local font = Enum.Font.Gotham
local DefaultTheme = {
	colors = {
		intents = {
			primary = {
				text = Color3.fromHex("#1D2433"),
				textMuted = Color3.fromHex("#6F7785"),
				background = Color3.fromHex("#FFFFFF"),
				hover = Color3.fromHex("#477FE8"),
				pressed = Color3.fromHex("#285BBE"),
				foreground = Color3.fromHex("#FFFFFF"),
				border = Color3.fromHex("#D9DEE8"),
			},
			success = {
				text = Color3.fromHex("#2E9D63"),
				background = Color3.fromHex("#2E9D63"),
				hover = Color3.fromHex("#38AC70"),
				pressed = Color3.fromHex("#237D4D"),
				foreground = Color3.fromHex("#FFFFFF"),
				border = Color3.fromHex("#237D4D"),
			},
			danger = {
				text = Color3.fromHex("#D64545"),
				background = Color3.fromHex("#D64545"),
				hover = Color3.fromHex("#E05252"),
				pressed = Color3.fromHex("#B53535"),
				foreground = Color3.fromHex("#FFFFFF"),
				border = Color3.fromHex("#B53535"),
			},
			warning = {
				text = Color3.fromHex("#E7A92F"),
				background = Color3.fromHex("#E7A92F"),
				hover = Color3.fromHex("#F0B640"),
				pressed = Color3.fromHex("#C58B1D"),
				foreground = Color3.fromHex("#1D2433"),
				border = Color3.fromHex("#C58B1D"),
			},
			info = {
				text = Color3.fromHex("#3187C8"),
				background = Color3.fromHex("#3187C8"),
				hover = Color3.fromHex("#4097D8"),
				pressed = Color3.fromHex("#266CA2"),
				foreground = Color3.fromHex("#FFFFFF"),
				border = Color3.fromHex("#266CA2"),
			},
		},
	},
	default = {
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
			font = Enum.Font.Gotham,
			size = Enum.FontSize.Size10,
			lineHeight = 1.3,
		},
	},
	components = {
		boxShadow = {
			color = Color3.fromHex("#000000"),
			transparency = 0.9,
		},
		box = {
			backgroundColor = Color3.fromHex("#FFFFFF"),
			backgroundTransparency = 0,
			borderColor = Color3.fromHex("#D9DEE8"),
			borderThickness = 1,
			cornerRadius = 8,
			boxShadow = "2px 2px 2px 2px",
		},
		button = {
			textColor = Color3.fromHex("#FFFFFF"),
			backgroundTransparency = 0,
			borderColor = Color3.fromHex("#D9DEE8"),
			borderThickness = 1,
			cornerRadius = 8,
			intents = {
				primary = {
					text = Color3.fromHex("#1D2433"),
					hover = Color3.fromHex("#CCCCCC"),
				},
			},
		},
	},
	icons = {
		shoppingCart = 112388431913339,
		times = 104942966197113,
	},
}
return {
	DefaultTheme = DefaultTheme,
}
