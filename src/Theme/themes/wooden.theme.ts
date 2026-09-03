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
        accordion: {
            borderColor: Color3.fromHex("#3D2712"),
            borderThickness: 2,
            cornerRadius: 0,
            header: {
                indicatorSize: 14,
                indicatorColor: Color3.fromHex("#FFF7CF"),
                intents: {
                    primary: {
                        default: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            backgroundTransparency: 1,
                            backgroundImage: {
                                image: 92016395170536,
                                slice: "10 5 240 40",
                                tintColor: Color3.fromHex("#7A4A20"),
                            },
                        },
                        hover: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            backgroundImage: {
                                tintColor: Color3.fromHex("#A16B30"),
                            },
                        },
                        focus: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            backgroundImage: {
                                tintColor: Color3.fromHex("#BA854A"),
                            },
                        },
                        disabled: {
                            textColor: Color3.fromHex("#a4a29f"),
                            backgroundTransparency: 1,
                            backgroundImage: {
                                transparency: 0.3,
                            },
                        },
                    },
                },
            },
            content: {
                backgroundColor: Color3.fromHex("#5C3A18"),
                backgroundTransparency: 0,
            },
        },
        table: {
            backgroundColor: Color3.fromHex("#5C3A18"),
            backgroundTransparency: 0,
            borderColor: Color3.fromHex("#3D2712"),
            borderThickness: 2,
            cornerRadius: 0,
            rowDividerColor: Color3.fromHex("#3D2712"),
            rowDividerThickness: 2,
            header: {
                backgroundColor: Color3.fromHex("#7A4A20"),
                backgroundTransparency: 0,
            },
        },
        tabs: {
            backgroundImage: {
                image: 137043424796720,
                tintColor: Color3.fromHex("#8a5a28"),
                size: "Tile",
                tileSize: "200px",
            },
            borderColor: Color3.fromHex("#331d07"),
            cornerRadius: 8,
            list: {
                borderThickness: 0,
                cornerRadius: 0,
                backgroundTransparency: 1,
                backgroundImage: {
                    image: 92016395170536,
                    slice: "10 5 240 40",
                    tintColor: Color3.fromHex("#5C3A18"),
                },
            },
            button: {
                cornerRadius: 0,
                borderThickness: 0,
                intents: {
                    primary: {
                        default: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            backgroundTransparency: 1,
                            backgroundImage: {
                                image: 92016395170536,
                                slice: "10 5 240 40",
                                tintColor: Color3.fromHex("#A16B30"),
                            },
                        },
                        hover: {
                            textColor: Color3.fromHex("#d3cba3"),
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#BA854A"),
                            },
                        },
                        focus: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#7A4A20"),
                            },
                        },
                    },
                    success: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#63ff00"),
                            },
                        },
                        hover: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#29ff52"),
                            },
                        },
                    },
                    info: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#00bfff"),
                            },
                        },
                        hover: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#29d4ff"),
                            },
                        },
                    },
                    warning: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#ffbf00"),
                            },
                        },
                        hover: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#ffd429"),
                            },
                        },
                    },
                    danger: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#ff0000"),
                            },
                        },
                        hover: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#ff2929"),
                            },
                        },
                    },
                },
            },
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
            },
            iconColor: Color3.fromHex("#FFF7CF"),
        },
        card: {
            borderThickness: 0,
            cornerRadius: 0,
            body: {
                padding: "10px 40px",
            },
            header: {
                intents: {
                    primary: {
                        default: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            borderColor: Color3.fromHex("#3D2712"),
                            backgroundTransparency: 1,
                            backgroundImage: {
                                image: 92016395170536,
                                slice: "10 5 240 40",
                                tintColor: Color3.fromHex("#7A4A20"),
                            },
                        },
                    },
                    success: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#4E6A24"),
                            },
                        },
                    },
                    info: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#2C5270"),
                            },
                        },
                    },
                    warning: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#A67A20"),
                            },
                        },
                    },
                    danger: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#7A3220"),
                            },
                        },
                    },
                },
                position: {
                    position: "absolute",
                    center: "x",
                    top: "0px",
                    zIndex: 2,
                },
            },
            footer: {
                spacing: {
                    xs: 1,
                    sm: 2,
                    md: 4,
                    lg: 6,
                    xl: 6
                },
                intents: {
                    primary: {
                        default: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            borderColor: Color3.fromHex("#3D2712"),
                            backgroundTransparency: 1,
                            backgroundImage: {
                                image: 92016395170536,
                                slice: "10 5 240 40",
                                tintColor: Color3.fromHex("#7A4A20"),
                            },
                        },
                    },
                    success: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#4E6A24"),
                            },
                        },
                    },
                    info: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#2C5270"),
                            },
                        },
                    },
                    warning: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#A67A20"),
                            },
                        },
                    },
                    danger: {
                        default: {
                            backgroundTransparency: 1,
                            backgroundImage: {
                                tintColor: Color3.fromHex("#7A3220"),
                            },
                        },
                    },
                },
                position: {
                    position: "absolute",
                    bottom: "0px",
                    left: "50px",
                    right: "50px",
                    zIndex: 2,
                },
            },
        },
        select: {
            cornerRadius: 0,
            borderThickness: 0,
            dropDownBackgroundColor: Color3.fromHex("#295896"),
            backgroundImage: {
                image: 92016395170536,
                slice: "10 5 248 44",
                tintColor: Color3.fromHex("#295896")
            },
            intents: {
                primary: {
                    default: {
                        textColor: Color3.fromHex("#FFF7CF"),
                        backgroundColor: Color3.fromHex("#295896"),
                    },
                    hover: {
                        textColor: Color3.fromHex("#FFF7CF"),
                        backgroundColor: Color3.fromHex("#376FAF"),
                    },
                    focus: {
                        textColor: Color3.fromHex("#FFF7CF"),
                        backgroundColor: Color3.fromHex("#1F477D"),
                    },
                },
            },
            optGroup: {
                textColor: Color3.fromHex("#FFF7CF"),
                backgroundColor: Color3.fromHex("#1F477D"),
                backgroundTransparency: 0,
                spacing: {
                    xs: 4,
                    sm: 6,
                    md: 8,
                    lg: 10,
                    xl: 12,
                },
            },
            search: {
                spacing: {
                    xs: 4,
                    sm: 6,
                    md: 8,
                    lg: 10,
                    xl: 12,
                },
            },
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
        switch: {
            track: {
                backgroundColor: Color3.fromHex("#5C3A18"),
                borderColor: Color3.fromHex("#3D2712"),
                intents: {
                    primary: {
                        default: {
                            backgroundColor: Color3.fromHex("#A16B30"),
                            borderColor: Color3.fromHex("#3D2712"),
                        },
                    },
                    success: {
                        default: {
                            backgroundColor: Color3.fromHex("#4E6A24"),
                            borderColor: Color3.fromHex("#3D2712"),
                        },
                    },
                    info: {
                        default: {
                            backgroundColor: Color3.fromHex("#2C5270"),
                            borderColor: Color3.fromHex("#3D2712"),
                        },
                    },
                    warning: {
                        default: {
                            backgroundColor: Color3.fromHex("#A67A20"),
                            borderColor: Color3.fromHex("#3D2712"),
                        },
                    },
                    danger: {
                        default: {
                            backgroundColor: Color3.fromHex("#7A3220"),
                            borderColor: Color3.fromHex("#3D2712"),
                        },
                    },
                },
            },
            thumb: {
                backgroundColor: Color3.fromHex("#BA854A"),
                borderColor: Color3.fromHex("#3D2712"),
            },
        },
        slider: {
            height: 20,
            bar: {
                height: "50%",
                padding: 10,
                backgroundColor: Color3.fromHex("#5C3A18"),
                backgroundTransparency: 0,
                borderThickness: 1,
                borderColor: Color3.fromHex("#3D2712"),
                cornerRadius: 4,
                highlight: {
                    backgroundColor: Color3.fromHex("#A16B30"),
                    backgroundTransparency: 0,
                    borderColor: Color3.fromHex("#3D2712"),
                }
            },
            handle: {
                boxShadow: "0px 0px 5px 5px",
                backgroundColor: Color3.fromHex("#BA854A"),
                backgroundTransparency: 0,
                borderThickness: 2,
                borderColor: Color3.fromHex("#3D2712"),
                cornerRadius: "100%",
            }
        },
        toast: {
            intents: {
                primary: {
                    backgroundTransparency: 1
                }
            }
        },
        tooltip: {
            cornerRadius: 0,
            intents: {
                primary: {
                    textColor: Color3.fromHex("#FFF7CF"),
                    backgroundColor: Color3.fromHex("#7A4A20"),
                    borderColor: Color3.fromHex("#3D2712"),
                    backgroundTransparency: 0,
                },
                success: {
                    backgroundColor: Color3.fromHex("#4E6A24"),
                },
                info: {
                    backgroundColor: Color3.fromHex("#2C5270"),
                },
                warning: {
                    backgroundColor: Color3.fromHex("#A67A20"),
                },
                danger: {
                    backgroundColor: Color3.fromHex("#7A3220"),
                },
            },
        },
    },
});
