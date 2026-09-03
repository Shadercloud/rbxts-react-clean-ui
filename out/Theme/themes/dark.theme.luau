-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local createTheme = TS.import(script, script.Parent.Parent, "theme.factory").createTheme
local font = Enum.Font.Jura
local DarkTheme = createTheme({
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
					disabled = {
						backgroundColor = Color3.fromHex("#1D222B"),
						borderColor = Color3.fromHex("#343B49"),
						textColor = Color3.fromHex("#697386"),
					},
				},
				success = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
					disabled = {
						backgroundColor = Color3.fromHex("#1D222B"),
						borderColor = Color3.fromHex("#343B49"),
						textColor = Color3.fromHex("#697386"),
					},
				},
				info = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
					disabled = {
						backgroundColor = Color3.fromHex("#1D222B"),
						borderColor = Color3.fromHex("#343B49"),
						textColor = Color3.fromHex("#697386"),
					},
				},
				warning = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
					disabled = {
						backgroundColor = Color3.fromHex("#1D222B"),
						borderColor = Color3.fromHex("#343B49"),
						textColor = Color3.fromHex("#697386"),
					},
				},
				danger = {
					default = {
						textColor = Color3.fromHex("#FFFFFF"),
					},
					disabled = {
						backgroundColor = Color3.fromHex("#1D222B"),
						borderColor = Color3.fromHex("#343B49"),
						textColor = Color3.fromHex("#697386"),
					},
				},
			},
		},
		input = {
			borderColor = Color3.fromHex("#3A4352"),
			borderThickness = 1,
			cornerRadius = 8,
			placeholder = {
				color = Color3.fromHex("#697386"),
			},
			iconColor = Color3.fromHex("#697386"),
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
			optGroup = {
				textColor = Color3.fromHex("#8892A6"),
				spacing = {
					xs = 4,
					sm = 6,
					md = 8,
					lg = 10,
					xl = 12,
				},
			},
			search = {
				spacing = {
					xs = 4,
					sm = 6,
					md = 8,
					lg = 10,
					xl = 12,
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
		switch = {
			width = 40,
			height = 22,
			cornerRadius = "100%",
			borderThickness = 1,
			disabledTransparency = 0.5,
			animation = {
				duration = 0.15,
			},
			track = {
				backgroundColor = Color3.fromHex("#2A303B"),
				backgroundTransparency = 0,
				borderColor = Color3.fromHex("#3A4352"),
			},
			thumb = {
				inset = 2,
				cornerRadius = "100%",
				backgroundColor = Color3.fromHex("#E8EDF8"),
				backgroundTransparency = 0,
				borderColor = Color3.fromHex("#4B74C7"),
				borderThickness = 1,
				boxShadow = "0px 0px 2px 1px",
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
		pagination = {
			backgroundColor = Color3.fromHex("#14181F"),
			backgroundTransparency = 0,
			borderColor = Color3.fromHex("#343B49"),
			borderThickness = 1,
			cornerRadius = 8,
			spacing = {
				xs = 2,
				sm = 4,
				md = 6,
				lg = 8,
				xl = 12,
			},
			item = {
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
						disabled = {
							backgroundTransparency = 1,
							borderColor = Color3.fromHex("#343B49"),
							textColor = Color3.fromHex("#697386"),
						},
					},
				},
			},
		},
		accordion = {
			borderColor = Color3.fromHex("#4B5568"),
			header = {
				indicatorColor = Color3.fromHex("#C9CDD5"),
				intents = {
					primary = {
						default = {
							backgroundColor = Color3.fromHex("#252B36"),
							textColor = Color3.fromHex("#E8EDF8"),
						},
						hover = {
							backgroundColor = Color3.fromHex("#303949"),
							textColor = Color3.fromHex("#FFFFFF"),
						},
						focus = {
							backgroundColor = Color3.fromHex("#3A414D"),
							textColor = Color3.fromHex("#FFFFFF"),
						},
						disabled = {
							backgroundColor = Color3.fromHex("#1D222B"),
							textColor = Color3.fromHex("#697386"),
						},
					},
				},
			},
			content = {
				backgroundColor = Color3.fromHex("#171B22"),
			},
		},
		table = {
			backgroundColor = Color3.fromHex("#171B22"),
			borderColor = Color3.fromHex("#4B5568"),
			rowDividerColor = Color3.fromHex("#343C4A"),
			header = {
				backgroundColor = Color3.fromHex("#252B36"),
			},
		},
		draggable = {
			placeholder = {
				backgroundColor = Color3.fromHex("#2A303B"),
				backgroundTransparency = 0.35,
				borderColor = Color3.fromHex("#4B74C7"),
				borderThickness = 1,
				cornerRadius = 8,
			},
		},
		card = {
			borderThickness = 1,
			cornerRadius = 8,
			header = {
				intents = {
					primary = {
						default = {
							backgroundColor = Color3.fromHex("#20252E"),
							backgroundTransparency = 0,
						},
					},
				},
			},
			footer = {
				intents = {
					primary = {
						default = {
							backgroundColor = Color3.fromHex("#20252E"),
							backgroundTransparency = 0,
						},
					},
				},
			},
		},
		slider = {
			height = 20,
			bar = {
				height = "50%",
				padding = 10,
				backgroundColor = Color3.fromHex("#2A303B"),
				borderThickness = 1,
				backgroundTransparency = 0,
				borderColor = Color3.fromHex("#3A4352"),
				cornerRadius = 8,
				highlight = {
					backgroundColor = Color3.fromHex("#3d57ff"),
					backgroundTransparency = 0.7,
					borderColor = Color3.fromHex("#3A4352"),
				},
			},
			handle = {
				backgroundColor = Color3.fromHex("#365FAF"),
				borderThickness = 1,
				backgroundTransparency = 0,
				borderColor = Color3.fromHex("#6B96F0"),
				cornerRadius = "100%",
			},
		},
		toast = {
			width = 300,
			fadeDuration = 0.5,
			header = {},
			body = {},
		},
		charts = {
			colors = { Color3.fromHex("#4CC47A"), Color3.fromHex("#E35B5B"), Color3.fromHex("#F0B74A"), Color3.fromHex("#4D9EEA"), Color3.fromHex("#A676F0"), Color3.fromHex("#43C2BA"), Color3.fromHex("#F48A52"), Color3.fromHex("#E06AAE"), Color3.fromHex("#6FA8DC"), Color3.fromHex("#9CCC4A") },
			bar = {
				borderColor = Color3.fromHex("#111827"),
				axis = {
					color = Color3.fromHex("#AAB4C3"),
				},
				xAxis = {
					tickColor = Color3.fromHex("#AAB4C3"),
				},
				yAxis = {
					tickColor = Color3.fromHex("#AAB4C3"),
				},
				gridLines = {
					color = Color3.fromHex("#6B7688"),
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
})
return {
	DarkTheme = DarkTheme,
}
