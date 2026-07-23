-- Compiled with roblox-ts v3.0.0
local font = Enum.Font.Gotham
local DefaultTheme = {
	colors = {
		intents = {
			primary = {
				default = {
					textColor = Color3.fromHex("#1D2433"),
					borderColor = Color3.fromHex("#D9DEE8"),
					backgroundColor = Color3.fromHex("#FFFFFF"),
				},
				hover = {
					textColor = Color3.fromHex("#477FE8"),
					borderColor = Color3.fromHex("#D9DEE8"),
					backgroundColor = Color3.fromHex("F5F5F5"),
				},
			},
			success = {
				default = {
					textColor = Color3.fromHex("#2E9D63"),
					borderColor = Color3.fromHex("#237D4D"),
					backgroundColor = Color3.fromHex("#2E9D63"),
				},
				hover = {
					textColor = Color3.fromHex("#38AC70"),
					borderColor = Color3.fromHex("#237D4D"),
					backgroundColor = Color3.fromHex("#1f824e"),
				},
			},
			danger = {
				default = {
					textColor = Color3.fromHex("#D64545"),
					borderColor = Color3.fromHex("#B53535"),
					backgroundColor = Color3.fromHex("#D64545"),
				},
				hover = {
					textColor = Color3.fromHex("#E05252"),
					borderColor = Color3.fromHex("#D64545"),
					backgroundColor = Color3.fromHex("#b03131"),
				},
			},
			warning = {
				default = {
					textColor = Color3.fromHex("#E7A92F"),
					borderColor = Color3.fromHex("#C58B1D"),
					backgroundColor = Color3.fromHex("#E7A92F"),
				},
				hover = {
					textColor = Color3.fromHex("#F0B640"),
					borderColor = Color3.fromHex("#C58B1D"),
					backgroundColor = Color3.fromHex("#bf8a22"),
				},
			},
			info = {
				default = {
					textColor = Color3.fromHex("#3187C8"),
					borderColor = Color3.fromHex("#266CA2"),
					backgroundColor = Color3.fromHex("#3187C8"),
				},
				hover = {
					textColor = Color3.fromHex("#4097D8"),
					borderColor = Color3.fromHex("#266CA2"),
					backgroundColor = Color3.fromHex("#2977b3"),
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
			font = Enum.Font.Gotham,
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
			barColor = Color3.fromHex("#000000"),
		},
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
			backgroundTransparency = 0,
			borderThickness = 1,
			cornerRadius = 8,
			intents = {
				primary = {
					default = {
						textColor = Color3.fromHex("#1D2433"),
					},
				},
				success = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
				},
				info = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
				},
				warning = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
				},
				danger = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
				},
			},
		},
		input = {
			borderColor = Color3.fromHex("#D9DEE8"),
			borderThickness = 1,
			cornerRadius = 8,
		},
		select = {
			dropDownBackgroundColor = Color3.fromHex("#FFFFFF"),
			maxDropDownHeight = 200,
			borderColor = Color3.fromHex("#D9DEE8"),
			borderThickness = 1,
			cornerRadius = 8,
			intents = {
				primary = {
					default = {
						textColor = Color3.fromHex("#1D2433"),
					},
					hover = {
						textColor = Color3.fromHex("#000000"),
						backgroundColor = Color3.fromHex("#CCCCCC"),
					},
					focus = {
						textColor = Color3.fromHex("#FFFFFF"),
						backgroundColor = Color3.fromHex("#3187C8"),
					},
				},
			},
		},
		checkbox = {
			borderColor = Color3.fromHex("#D9DEE8"),
			borderThickness = 1,
			cornerRadius = 8,
			spacing = {
				xs = 1,
				sm = 2,
				md = 4,
				lg = 6,
				xl = 8,
			},
		},
		tabs = {
			borderColor = Color3.fromHex("#D9DEE8"),
			backgroundColor = Color3.fromHex("#FFFFFF"),
			borderThickness = 1,
			cornerRadius = 4,
			list = {
				backgroundColor = Color3.fromHex("#F5F5F5"),
				borderThickness = 0,
				cornerRadius = 8,
				spacing = {
					xs = 2,
					sm = 4,
					md = 6,
					lg = 8,
					xl = 12,
				},
			},
			button = {
				borderThickness = 0,
				cornerRadius = 4,
				spacing = {
					xs = 1,
					sm = 2,
					md = 4,
					lg = 6,
					xl = 8,
				},
				intents = {
					primary = {
						default = {
							backgroundTransparency = 1,
							textColor = Color3.fromHex("#4f4f4f"),
						},
						hover = {
							backgroundTransparency = 1,
							textColor = Color3.fromHex("#000000"),
						},
						focus = {
							textColor = Color3.fromHex("#000000"),
							backgroundColor = Color3.fromHex("#FFFFFF"),
							backgroundTransparency = 0,
							boxShadow = "2px 2px 2px 2px",
							typography = {
								weight = Enum.FontWeight.Bold,
							},
						},
					},
				},
			},
		},
	},
	icons = {
		["shopping-cart"] = 112388431913339,
	},
	iconSize = {
		xs = 10,
		sm = 16,
		md = 20,
		lg = 24,
		xl = 30,
	},
}
return {
	DefaultTheme = DefaultTheme,
}
