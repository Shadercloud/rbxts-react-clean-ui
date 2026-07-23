-- Compiled with roblox-ts v3.0.0
local font = Enum.Font.Jura
local DarkTheme = {
	colors = {
		intents = {
			primary = {
				default = {
					textColor = Color3.fromHex("#E8EDF8"),
					borderColor = Color3.fromHex("#4B74C7"),
					backgroundColor = Color3.fromHex("#365FAF"),
				},
				hover = {
					textColor = Color3.fromHex("#FFFFFF"),
					borderColor = Color3.fromHex("#6B96F0"),
					backgroundColor = Color3.fromHex("#4775CC"),
				},
			},
			success = {
				default = {
					textColor = Color3.fromHex("#75E0A7"),
					borderColor = Color3.fromHex("#258A56"),
					backgroundColor = Color3.fromHex("#237A4D"),
				},
				hover = {
					textColor = Color3.fromHex("#FFFFFF"),
					borderColor = Color3.fromHex("#42C982"),
					backgroundColor = Color3.fromHex("#2D965F"),
				},
			},
			danger = {
				default = {
					textColor = Color3.fromHex("#FF8D8D"),
					borderColor = Color3.fromHex("#B93A3A"),
					backgroundColor = Color3.fromHex("#A63737"),
				},
				hover = {
					textColor = Color3.fromHex("#FFFFFF"),
					borderColor = Color3.fromHex("#EB6262"),
					backgroundColor = Color3.fromHex("#C64646"),
				},
			},
			warning = {
				default = {
					textColor = Color3.fromHex("#FFD978"),
					borderColor = Color3.fromHex("#B68522"),
					backgroundColor = Color3.fromHex("#916B1D"),
				},
				hover = {
					textColor = Color3.fromHex("#FFF8E5"),
					borderColor = Color3.fromHex("#E0AD3E"),
					backgroundColor = Color3.fromHex("#AF8427"),
				},
			},
			info = {
				default = {
					textColor = Color3.fromHex("#8DD0FF"),
					borderColor = Color3.fromHex("#2F79B4"),
					backgroundColor = Color3.fromHex("#286D9F"),
				},
				hover = {
					textColor = Color3.fromHex("#FFFFFF"),
					borderColor = Color3.fromHex("#58ACE8"),
					backgroundColor = Color3.fromHex("#3487BE"),
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
			barColor = Color3.fromHex("#697386"),
		},
		boxShadow = {
			color = Color3.fromHex("#000000"),
			transparency = 0.5,
		},
		box = {
			backgroundColor = Color3.fromHex("#1B1F27"),
			backgroundTransparency = 0,
			borderColor = Color3.fromHex("#343B49"),
			borderThickness = 1,
			cornerRadius = 8,
			boxShadow = "2px 2px 8px 0px",
		},
		button = {
			backgroundTransparency = 0,
			borderThickness = 1,
			cornerRadius = 8,
			intents = {
				primary = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
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
			borderColor = Color3.fromHex("#3A4352"),
			borderThickness = 1,
			cornerRadius = 8,
		},
		select = {
			dropDownBackgroundColor = Color3.fromHex("#20252E"),
			maxDropDownHeight = 200,
			borderColor = Color3.fromHex("#3A4352"),
			borderThickness = 1,
			cornerRadius = 8,
			intents = {
				primary = {
					default = {
						textColor = Color3.fromHex("#E8EDF8"),
						backgroundColor = Color3.fromHex("#20252E"),
					},
					hover = {
						textColor = Color3.fromHex("#FFFFFF"),
						backgroundColor = Color3.fromHex("#2B3340"),
					},
					focus = {
						textColor = Color3.fromHex("#FFFFFF"),
						backgroundColor = Color3.fromHex("#365FAF"),
						borderColor = Color3.fromHex("#6B96F0"),
					},
				},
			},
		},
		checkbox = {
			borderColor = Color3.fromHex("#3A4352"),
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
			borderColor = Color3.fromHex("#343B49"),
			backgroundColor = Color3.fromHex("#1B1F27"),
			borderThickness = 1,
			cornerRadius = 4,
			list = {
				backgroundColor = Color3.fromHex("#14181F"),
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
							textColor = Color3.fromHex("#AAB3C2"),
						},
						hover = {
							backgroundTransparency = 1,
							textColor = Color3.fromHex("#FFFFFF"),
						},
						focus = {
							textColor = Color3.fromHex("#FFFFFF"),
							backgroundColor = Color3.fromHex("#2A303B"),
							backgroundTransparency = 0,
							boxShadow = "2px 2px 6px 0px",
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
	DarkTheme = DarkTheme,
}
