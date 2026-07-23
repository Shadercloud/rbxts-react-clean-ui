-- Compiled with roblox-ts v3.0.0
local font = Enum.Font.SourceSans
local SandstoneTheme = {
	colors = {
		intents = {
			primary = {
				default = {
					textColor = Color3.fromHex("#244F4A"),
					borderColor = Color3.fromHex("#4E8179"),
					backgroundColor = Color3.fromHex("#D9E9E5"),
				},
				hover = {
					textColor = Color3.fromHex("#183B37"),
					borderColor = Color3.fromHex("#376A63"),
					backgroundColor = Color3.fromHex("#C4DDD7"),
				},
			},
			success = {
				default = {
					textColor = Color3.fromHex("#2E6245"),
					borderColor = Color3.fromHex("#5B8A6A"),
					backgroundColor = Color3.fromHex("#DDEBDD"),
				},
				hover = {
					textColor = Color3.fromHex("#214E35"),
					borderColor = Color3.fromHex("#467554"),
					backgroundColor = Color3.fromHex("#C9E0CB"),
				},
			},
			danger = {
				default = {
					textColor = Color3.fromHex("#8A3D3A"),
					borderColor = Color3.fromHex("#B46861"),
					backgroundColor = Color3.fromHex("#F2D9D5"),
				},
				hover = {
					textColor = Color3.fromHex("#6F2D2B"),
					borderColor = Color3.fromHex("#9F504A"),
					backgroundColor = Color3.fromHex("#EBC5C0"),
				},
			},
			warning = {
				default = {
					textColor = Color3.fromHex("#7A5721"),
					borderColor = Color3.fromHex("#C3994C"),
					backgroundColor = Color3.fromHex("#F5E8C8"),
				},
				hover = {
					textColor = Color3.fromHex("#644515"),
					borderColor = Color3.fromHex("#AA7E34"),
					backgroundColor = Color3.fromHex("#EED9A7"),
				},
			},
			info = {
				default = {
					textColor = Color3.fromHex("#365F78"),
					borderColor = Color3.fromHex("#6F98AE"),
					backgroundColor = Color3.fromHex("#DDEAF0"),
				},
				hover = {
					textColor = Color3.fromHex("#294A5D"),
					borderColor = Color3.fromHex("#578097"),
					backgroundColor = Color3.fromHex("#C8DDE7"),
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
		sm = 2,
		md = 4,
		lg = 8,
		default = "md",
	},
	typography = {
		display = {
			font = font,
			weight = Enum.FontWeight.Bold,
			size = Enum.FontSize.Size48,
			lineHeight = 1.05,
		},
		title = {
			font = font,
			weight = Enum.FontWeight.SemiBold,
			size = Enum.FontSize.Size32,
			lineHeight = 1.15,
		},
		heading = {
			font = font,
			weight = Enum.FontWeight.SemiBold,
			size = Enum.FontSize.Size24,
			lineHeight = 1.2,
		},
		body = {
			font = font,
			size = Enum.FontSize.Size18,
			lineHeight = 1.45,
		},
		label = {
			font = font,
			weight = Enum.FontWeight.SemiBold,
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
			barColor = Color3.fromHex("#9B8B73"),
		},
		boxShadow = {
			color = Color3.fromHex("#4F4538"),
			transparency = 0.82,
		},
		box = {
			backgroundColor = Color3.fromHex("#FFF9ED"),
			backgroundTransparency = 0,
			borderColor = Color3.fromHex("#D8CDBA"),
			borderThickness = 1,
			cornerRadius = 4,
			boxShadow = "0px 3px 8px 0px",
		},
		button = {
			backgroundTransparency = 0,
			borderThickness = 1,
			cornerRadius = 4,
			intents = {
				primary = {
					default = {
						textColor = Color3.fromHex("#244F4A"),
					},
				},
				success = {
					default = {
						textColor = Color3.fromHex("#2E6245"),
					},
				},
				info = {
					default = {
						textColor = Color3.fromHex("#365F78"),
					},
				},
				warning = {
					default = {
						textColor = Color3.fromHex("#7A5721"),
					},
				},
				danger = {
					default = {
						textColor = Color3.fromHex("#8A3D3A"),
					},
				},
			},
		},
		input = {
			borderColor = Color3.fromHex("#CDBFA8"),
			borderThickness = 1,
			cornerRadius = 4,
		},
		select = {
			dropDownBackgroundColor = Color3.fromHex("#FFF9ED"),
			maxDropDownHeight = 200,
			borderColor = Color3.fromHex("#CDBFA8"),
			borderThickness = 1,
			cornerRadius = 4,
			intents = {
				primary = {
					default = {
						textColor = Color3.fromHex("#4A4034"),
						backgroundColor = Color3.fromHex("#FFF9ED"),
					},
					hover = {
						textColor = Color3.fromHex("#244F4A"),
						backgroundColor = Color3.fromHex("#E7F0EB"),
					},
					focus = {
						textColor = Color3.fromHex("#FFFFFF"),
						borderColor = Color3.fromHex("#376A63"),
						backgroundColor = Color3.fromHex("#4E8179"),
					},
				},
			},
		},
		checkbox = {
			borderColor = Color3.fromHex("#CDBFA8"),
			borderThickness = 1,
			cornerRadius = 4,
			spacing = {
				xs = 1,
				sm = 2,
				md = 4,
				lg = 6,
				xl = 8,
			},
		},
		tabs = {
			borderColor = Color3.fromHex("#D8CDBA"),
			backgroundColor = Color3.fromHex("#FFF9ED"),
			borderThickness = 1,
			cornerRadius = 4,
			list = {
				backgroundColor = Color3.fromHex("#EFE5D3"),
				borderThickness = 0,
				cornerRadius = 2,
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
				cornerRadius = 2,
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
							textColor = Color3.fromHex("#746754"),
						},
						hover = {
							backgroundTransparency = 1,
							textColor = Color3.fromHex("#244F4A"),
						},
						focus = {
							textColor = Color3.fromHex("#244F4A"),
							backgroundColor = Color3.fromHex("#FFF9ED"),
							backgroundTransparency = 0,
							boxShadow = "0px 2px 5px 0px",
							typography = {
								weight = Enum.FontWeight.SemiBold,
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
	SandstoneTheme = SandstoneTheme,
}
