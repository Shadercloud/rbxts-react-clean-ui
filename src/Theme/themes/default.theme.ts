import { CleanTheme } from "../theme.template"

const font = Enum.Font.Gotham
export const DefaultTheme: CleanTheme = {
    colors: {
        intents: {
            primary: {
                default: {
                    textColor: Color3.fromHex("#1D2433"),
                    borderColor: Color3.fromHex("#D9DEE8"),
                    backgroundColor: Color3.fromHex("#FFFFFF"),
                },
                hover: {
                    textColor: Color3.fromHex("#477FE8"),
                    borderColor: Color3.fromHex("#D9DEE8"),
                    backgroundColor: Color3.fromHex("F5F5F5"),
                },
            },

            success: {
                default: {
                    textColor: Color3.fromHex("#2E9D63"),
                    borderColor: Color3.fromHex("#237D4D"),
                    backgroundColor: Color3.fromHex("#2E9D63"),
                },
                hover: {
                    textColor: Color3.fromHex("#38AC70"),
                    borderColor: Color3.fromHex("#237D4D"),
                    backgroundColor: Color3.fromHex("#1f824e"),
                },
            },

            danger: {
                default: {
                    textColor: Color3.fromHex("#D64545"),
                    borderColor: Color3.fromHex("#B53535"),
                    backgroundColor: Color3.fromHex("#D64545"),
                },
                hover: {
                    textColor: Color3.fromHex("#E05252"),
                    borderColor: Color3.fromHex("#D64545"),
                    backgroundColor: Color3.fromHex("#b03131"),
                },
            },

            warning: {
                default: {
                    textColor: Color3.fromHex("#E7A92F"),
                    borderColor: Color3.fromHex("#C58B1D"),
                    backgroundColor: Color3.fromHex("#E7A92F"),
                },
                hover: {
                    textColor: Color3.fromHex("#F0B640"),
                    borderColor: Color3.fromHex("#C58B1D"),
                    backgroundColor: Color3.fromHex("#bf8a22"),
                },
            },

            info: {
                default: {
                    textColor: Color3.fromHex("#3187C8"),
                    borderColor: Color3.fromHex("#266CA2"),
                    backgroundColor: Color3.fromHex("#3187C8"),
                },
                hover: {
                    textColor: Color3.fromHex("#4097D8"),
                    borderColor: Color3.fromHex("#266CA2"),
                    backgroundColor: Color3.fromHex("#2977b3"),
                },

            },
        }
    },


    default: {
        scale: "md",
        spacing: "md"
    },

    breakpoints: {
        xs: 100,
        sm: 200,
        md: 300,
        lg: 400,
        xl: 500
    },

    spacing: {
        xs: 4,
        sm: 8,
        md: 12,
        lg: 16,
        xl: 24,
    },

    radius: {
        sm: 4,
        md: 8,
        lg: 12,
        default: "md"
    },

    typography: {
        display: {
            font: font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size48,
            lineHeight: 1.1,
        },
        title: {
            font: font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size32,
            lineHeight: 1.2,
        },
        heading: {
            font: font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size24,
            lineHeight: 1.25,
        },
        body: {
            font: font,
            size: Enum.FontSize.Size18,
            lineHeight: 1.4,
        },
        label: {
            font: font,
            weight: Enum.FontWeight.Bold,
            size: Enum.FontSize.Size14,
            lineHeight: 1.2,
        },
        caption: {
            font: Enum.Font.Gotham,
            size: Enum.FontSize.Size10,
            lineHeight: 1.3,
        },
    },

    typeScaleMap: {
        xs: "caption",
        sm: "label",
        md: "body",
        lg: "heading",
        xl: "title"
    },

    components: {
        scroller: {
            barColor: Color3.fromHex("#000000")
        },
        boxShadow: {
            color: Color3.fromHex("#000000"),
            transparency: 0.9,
        },
        box: {
            backgroundColor: Color3.fromHex("#FFFFFF"),
            backgroundTransparency: 0,
            borderColor: Color3.fromHex("#D9DEE8"),
            borderThickness: 1,
            cornerRadius: 8,
            boxShadow: "2px 2px 2px 2px",
        },

        button: {
            backgroundTransparency: 0,
            borderThickness: 1,
            cornerRadius: 8,
            intents: {
                primary: {
                    default: {
                        textColor: Color3.fromHex("#1D2433")
                    },
                },
                success: {
                    default: {
                        textColor: Color3.fromHex("#FFFFFF")
                    }
                },
                info: {
                    default: {
                        textColor: Color3.fromHex("#FFFFFF")
                    }
                },
                warning: {
                    default: {
                        textColor: Color3.fromHex("#FFFFFF")
                    }
                },
                danger: {
                    default: {
                        textColor: Color3.fromHex("#FFFFFF")
                    }
                }
            },
        },

        input: {
            borderColor: Color3.fromHex("#D9DEE8"),
            borderThickness: 1,
            cornerRadius: 8,
        },
        select: {
            dropDownBackgroundColor: Color3.fromHex("#FFFFFF"),
            maxDropDownHeight: 200,
            borderColor: Color3.fromHex("#D9DEE8"),
            borderThickness: 1,
            cornerRadius: 8,
            intents: {
                primary: {
                    default: {
                        textColor: Color3.fromHex("#1D2433"),
                    },
                    hover: {
                        textColor: Color3.fromHex("#000000"),
                        backgroundColor: Color3.fromHex("#CCCCCC")
                    },
                    focus: {
                        textColor: Color3.fromHex("#FFFFFF"),
                        backgroundColor: Color3.fromHex("#3187C8")
                    }
                }
            },
        },
        checkbox: {
            borderColor: Color3.fromHex("#D9DEE8"),
            borderThickness: 1,
            cornerRadius: 8,
            spacing: {
                xs: 1,
                sm: 2,
                md: 4,
                lg: 6,
                xl: 8,
            }
        },
        tabs: {
            borderColor: Color3.fromHex("#D9DEE8"),
            backgroundColor: Color3.fromHex("#FFFFFF"),
            borderThickness: 1,
            cornerRadius: 4,
            list: {
                backgroundColor: Color3.fromHex("#F5F5F5"),
                borderThickness: 0,
                cornerRadius: 8,
                spacing: {
                    xs: 2,
                    sm: 4,
                    md: 6,
                    lg: 8,
                    xl: 12,
                }
            },
            button: {
                borderThickness: 0,
                cornerRadius: 4,
                spacing: {
                    xs: 1,
                    sm: 2,
                    md: 4,
                    lg: 6,
                    xl: 8,
                },
                intents: {
                    primary: {
                        default: {
                            backgroundTransparency: 1,
                            textColor: Color3.fromHex("#4f4f4f"),
                        },
                        hover: {
                            backgroundTransparency: 1,
                            textColor: Color3.fromHex("#000000"),
                        },
                        focus: {
                            textColor: Color3.fromHex("#000000"),
                            backgroundColor: Color3.fromHex("#FFFFFF"),
                            backgroundTransparency: 0,
                            boxShadow: "2px 2px 2px 2px",
                            typography: {
                                weight: Enum.FontWeight.Bold
                            }
                        }
                    }
                }
            },
        },
        draggable: {
            placeholder: {
                backgroundColor: Color3.fromHex("#D9DEE8"),
                backgroundTransparency: 0.5,
                borderColor: Color3.fromHex("#D9DEE8"),
                borderThickness: 2,
                cornerRadius: 8,
            }
        },
        card: {
            borderThickness: 1,
            cornerRadius: 8,
            header: {
                intents: {
                    primary: {
                        default: {
                            backgroundColor: Color3.fromHex("#F5F5F5"),
                            backgroundTransparency: 0,
                            borderColor: Color3.fromHex("#D9DEE8"),
                        }
                    },
                    success: {
                        default: {
                            backgroundColor: Color3.fromHex("#2E9D63"),
                            backgroundTransparency: 0.7,
                            borderColor: Color3.fromHex("#237D4D"),
                        }
                    },
                    info: {
                        default: {
                            borderColor: Color3.fromHex("#266CA2"),
                            backgroundColor: Color3.fromHex("#3187C8"),
                            backgroundTransparency: 0.7,
                        }
                    },
                    warning: {
                        default: {
                            borderColor: Color3.fromHex("#C58B1D"),
                            backgroundColor: Color3.fromHex("#E7A92F"),
                            backgroundTransparency: 0.7,
                        }
                    },
                    danger: {
                        default: {
                            borderColor: Color3.fromHex("#B53535"),
                            backgroundColor: Color3.fromHex("#D64545"),
                            backgroundTransparency: 0.7,
                        }
                    }

                }
            },
            footer: {
                intents: {
                    primary: {
                        default: {
                            backgroundColor: Color3.fromHex("#F5F5F5"),
                            backgroundTransparency: 0,
                            borderColor: Color3.fromHex("#D9DEE8"),
                        }
                    },
                    success: {
                        default: {
                            backgroundColor: Color3.fromHex("#2E9D63"),
                            backgroundTransparency: 0.7,
                            borderColor: Color3.fromHex("#237D4D"),
                        }
                    },
                    info: {
                        default: {
                            borderColor: Color3.fromHex("#266CA2"),
                            backgroundColor: Color3.fromHex("#3187C8"),
                            backgroundTransparency: 0.7,
                        }
                    },
                    warning: {
                        default: {
                            borderColor: Color3.fromHex("#C58B1D"),
                            backgroundColor: Color3.fromHex("#E7A92F"),
                            backgroundTransparency: 0.7,
                        }
                    },
                    danger: {
                        default: {
                            borderColor: Color3.fromHex("#B53535"),
                            backgroundColor: Color3.fromHex("#D64545"),
                            backgroundTransparency: 0.7,
                        }
                    }
                }
            },

        },
        slider: {
            height: 20,
            bar: {
                backgroundColor: Color3.fromHex("#F5F5F5"),
                height: "30%",
                padding: 25,
                borderThickness: 1,
                backgroundTransparency: 0,
                borderColor: Color3.fromHex("#D9DEE8"),
                cornerRadius: 8,
                highlight: {
                    backgroundColor: Color3.fromHex("#333333"),
                    backgroundTransparency: 0.3,
                    borderColor: Color3.fromHex("#000000")
                }
            },
            handle: {
                boxShadow: "0px 0px 5px 5px",
                backgroundColor: Color3.fromHex("#F5F5F5"),
                borderThickness: 1,
                backgroundTransparency: 0,
                borderColor: Color3.fromHex("#D9DEE8"),
                cornerRadius: 8,
                aspectRation: 1
            }
        },
        toast: {
            fadeDuration: 0.5,
            width: 300,
            position: {
                right: 5,
                top: 5,
            },
            header: {
                typography: {
                    weight: Enum.FontWeight.Bold
                }
            },
            body: {},
            intents: {
                primary: {
                    backgroundTransparency: 0
                },
                success: {
                    backgroundColor: Color3.fromHex("#dcf5e8"),
                },
                info: {
                    backgroundColor: Color3.fromHex("#b3d7f2"),
                },
                warning: {
                    backgroundColor: Color3.fromHex("#f7e1b5"),
                    textColor: Color3.fromHex("#75520f"),
                },
                danger: {
                    backgroundColor: Color3.fromHex("#edafaf"),
                    textColor: Color3.fromHex("#731717"),
                },
            },
            statusBar: {
                height: 4,
                position: "Bottom",
                intents: {
                    primary: {
                        backgroundColor: Color3.fromHex("#000000"),
                        backgroundTransparency: 0.5
                    },
                    success: {
                        backgroundColor: Color3.fromHex("#237D4D"),
                    },
                    info: {
                        backgroundColor: Color3.fromHex("#3187C8"),
                    },
                    warning: {
                        backgroundColor: Color3.fromHex("#C58B1D"),
                    },
                    danger: {
                        backgroundColor: Color3.fromHex("#D64545"),
                    }
                }
            }
        },
        tooltip: {
            fadeDuration: 0.25,
            pointerSize: 10,
            spacing: {
                xs: 2,
                sm: 6,
                md: 10,
                lg: 12,
                xl: 20,
            },
            cornerRadius: 8,
            boxShadow: "2px 2px 2px 2px",
            intents: {
                success: {
                    textColor: Color3.fromHex("#FFFFFF")
                },
                warning: {
                    textColor: Color3.fromHex("#75520f")
                },
                danger: {
                    textColor: Color3.fromHex("#731717")
                },
                info: {
                    textColor: Color3.fromHex("#FFFFFF")
                }
            }

        },
        charts: {
            colors: [
                Color3.fromHex("#2E9D63"), // Green
                Color3.fromHex("#D64545"), // Red
                Color3.fromHex("#E7A92F"), // Amber
                Color3.fromHex("#3187C8"), // Blue

                Color3.fromHex("#8E5AD7"), // Purple
                Color3.fromHex("#2FA7A1"), // Teal
                Color3.fromHex("#F26D4F"), // Orange
                Color3.fromHex("#D94F9D"), // Pink
                Color3.fromHex("#6B7C93"), // Slate
                Color3.fromHex("#7CB342"), // Lime
            ],
            pie: {
                hoverDarken: 0.2,
                boxShadow: {
                    shadow: "0px 0px 8px 3px",
                    color: Color3.fromHex("#000000"),
                    transparency: 0.6,
                },

                labels: {
                    cornerRadius: 4,
                    typography: {
                        weight: Enum.FontWeight.Bold
                    }
                }
            }
        }
    },

    icons: {
        "shopping-cart": 112388431913339,
    },
    iconSize: {
        xs: 10,
        sm: 16,
        md: 20,
        lg: 24,
        xl: 30,
    }
};