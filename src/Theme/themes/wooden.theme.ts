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
        tabs: {
            list: {
                borderThickness: 0,
                cornerRadius: 0,
                // Same plaque asset as the buttons, stretched across the
                // full tab bar width — a darker/more muted stain than the
                // buttons' own default tint so the buttons still read as
                // distinct, raised elements sitting on top of this backing
                // strip. backgroundTransparency: 1 hides the flat fill so
                // only the image shows.
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
                    // Same cascade as `card.header.intents`/`card.footer.
                    // intents` above — only `primary` spells out the shared
                    // plaque (image/slice), text color, and transparency;
                    // the rest just override `backgroundImage.tintColor`.
                    // Tints reused from `button.intents` above since these
                    // are literal buttons too.
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
            }
        },
        card: {
            borderThickness: 0,
            cornerRadius: 0,
            header: {
                intents: {
                    // Every intent shares the same plaque (image/slice), text
                    // color, border color, and transparency — only the wood
                    // stain tint differs, so only `primary` spells those
                    // shared fields out. The others just override
                    // `backgroundImage.tintColor`; ColorHelper's cascade
                    // always layers the `primary` entry underneath the
                    // selected intent, and merges `backgroundImage` field-by-
                    // field rather than replacing it wholesale, so everything
                    // but `tintColor` falls through from `primary` below
                    // (same pattern already used by this theme's `button`/
                    // `checkbox` intents).
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
                // Mounted plaque look: centered horizontally on the box and
                // pulled up so it protrudes above the box's top edge instead
                // of sitting in-flow like a normal header bar.
                position: {
                    position: "absolute",
                    center: "x",
                    top: "-10px",
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
                    // Same cascade as `header.intents` above — only `primary`
                    // spells out the shared fields, the rest just override
                    // `backgroundImage.tintColor`.
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
                // Mounted plaque look, mirroring the header, but flush with
                // the box's bottom edge (no negative offset/protrusion) and
                // inset 50px on each side (left/right insets implicitly
                // center it and imply a width narrower than the box, same as
                // standard CSS absolute positioning).
                position: {
                    position: "absolute",
                    bottom: "-10px",
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
