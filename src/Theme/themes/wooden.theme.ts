import { createTheme } from "../theme.factory";

const font = Enum.Font.PatrickHand;

export const WoodenTheme = createTheme({
    typography: {
        display: {
            font,
            size: Enum.FontSize.Size60,
            letterSpacing: 5,
        },
        title: {
            font,
            size: Enum.FontSize.Size48,
            letterSpacing: 3,
        },
        heading: {
            font,
            size: Enum.FontSize.Size32,
            letterSpacing: 2,
        },
        body: {
            font,
            size: Enum.FontSize.Size24,
        },
        label: {
            font,
            size: Enum.FontSize.Size18,
        },
        caption: {
            font,
            size: Enum.FontSize.Size14,
        },
    },
    colors: {
        intents: {
            primary: {
                default: {
                    textColor: Color3.fromHex("#FFF7CF"),
                }
            }
        }
    },
    components: {
        button: {
            cornerRadius: 0,
            backgroundTransparency: 1,
            borderThickness: 0,
            intents: {
                primary: {
                    default: {
                        textColor: Color3.fromHex("#FFF7CF"),
                        backgroundImage: {
                            image: 92016395170536,
                            slice: "10 5 240 40",
                            tintColor: Color3.fromHex("#A16B30"),
                        }
                    },
                    hover: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#BA854A"),
                        }
                    },
                    disabled: {
                        textColor: Color3.fromHex("#a4a29f"),
                        backgroundImage: {
                            transparency: 0.3,
                        }
                    }
                },
                success: {
                    default: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#63ff00"),
                        }
                    },
                    hover: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#29ff52"),
                        }
                    }
                },
                info: {
                    default: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#00bfff"),
                        }
                    },
                    hover: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#29d4ff"),
                        }
                    }
                },
                warning: {
                    default: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#ffbf00"),
                        }
                    },
                    hover: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#ffd429"),
                        }
                    }
                },
                danger: {
                    default: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#ff0000"),
                        }
                    },
                    hover: {
                        backgroundImage: {
                            tintColor: Color3.fromHex("#ff2929"),
                        }
                    }
                }
            }
        },
        box: {
            borderThickness: 0,
            boxShadow: 0,
            cornerRadius: 0,
            backgroundTransparency: 1,
            padding: "35px 40px 40px 40px",
            backgroundImage: {
                image: 89050878990049,
                slice: "54 55 969 565",
            },
        },
        input: {
            cornerRadius: 0,
            borderThickness: 0,
            backgroundImage: {
                image: 92016395170536,
                slice: "10 5 248 44",
                tintColor: Color3.fromHex("#295896")
            },
            placeholder: {
                color: Color3.fromHex("#546b8a"),
            }
        },
        increment: {
            button: {
                intents: {
                    primary: {
                        default: {
                            backgroundImage: {
                                tintColor: Color3.fromHex("#6c6c6c")
                            }
                        },
                        hover: {
                            backgroundImage: {
                                tintColor: Color3.fromHex("#847f7f")
                            }
                        }
                    }
                }
            }
        },
        checkbox: {
            cornerRadius: 4,
            borderThickness: 3,
            borderTransparency: 0,
            backgroundImage: {
                image: 84686427750506,
                tintColor: Color3.fromHex("#A16B30"),
            },
            intents: {
                primary: {
                    default: {
                        borderColor: Color3.fromHex("#3D2712"),
                        textColor: Color3.fromHex("#FFF7CF"),
                    },
                },
                success: {
                    default: {
                        borderColor: Color3.fromHex("#311f0e"),
                    },
                },
                info: {
                    default: {
                        textColor: Color3.fromHex("#00bfff"),
                    }
                },
                danger: {
                    default: {
                        textColor: Color3.fromHex("#ff0000")
                    }
                }
            },
        },
    },
});