# React Clean UI

An easy-to-use, theme-aware React component library for building polished Roblox interfaces with [`roblox-ts`](https://roblox-ts.com/) and [`@rbxts/react`](https://www.npmjs.com/package/@rbxts/react).

Stop hand-rolling sizes, spacing, colours, and layout on every screen — compose your UI from reusable, styled components instead.

[**📖 Read the full docs**](https://shadercloud.github.io/rbxts-react-clean-ui/) · [**📦 npm package**](https://www.npmjs.com/package/@rbxts/react-clean-ui)

## Install

```bash
npm install @rbxts/react-clean-ui
```

## Preview

| | | |
|---|---|---|
| ![Card](https://shadercloud.github.io/rbxts-react-clean-ui/images/card_preview.png) | ![Checkbox](https://shadercloud.github.io/rbxts-react-clean-ui/images/checkbox_preview.png) | ![Toast](https://shadercloud.github.io/rbxts-react-clean-ui/images/toast_preview.gif) |
| ![Select](https://shadercloud.github.io/rbxts-react-clean-ui/images/select_preview.gif) | ![Menu](https://shadercloud.github.io/rbxts-react-clean-ui/images/menu_preview.gif) | ![Slider](https://shadercloud.github.io/rbxts-react-clean-ui/images/slider_preview.gif) |
| ![Input](https://shadercloud.github.io/rbxts-react-clean-ui/images/input_preview.gif) | ![Tooltip](https://shadercloud.github.io/rbxts-react-clean-ui/images/tooltip_preview.gif) | ![Draggable](https://shadercloud.github.io/rbxts-react-clean-ui/images/draggable_preview.gif) |

More components, including layouts, forms, charts, and navigation, are in the [docs](https://shadercloud.github.io/rbxts-react-clean-ui/).

## Why React Clean UI?

Roblox gives you powerful low-level UI instances, but every screen ends up repeating the same work: calculating sizes and positions, configuring layout and spacing, applying colours/typography/corners/shadows, and keeping it all visually consistent.

React Clean UI moves that repeated work into reusable components, helpers, and theme definitions — you describe **what** the interface should contain, the library handles **how** it's presented.

## Features

- 🧩 **Composable components** — containers, stacks, boxes, buttons, text, fieldsets, inputs, selects, and more
- 🎨 **Theme-driven design** — colours, spacing, typography, radii, and semantic intent colours (`primary`, `info`, `success`, `danger`) defined centrally; light/dark and custom themes supported
- 📐 **Familiar sizing & spacing** — concise, CSS-like props translated into native Roblox `UDim`/`UDim2`
- 📱 **Responsive layouts** — breakpoint-aware components for phone, tablet, desktop, and console
- ⚛️ **Built for Roblox React** — renders ordinary Roblox GUI instances through `@rbxts/react`; plays nicely with hooks, contexts, Rojo, and UI Labs stories

## Quick start

First set up a roblox-ts project (`npm init roblox-ts`), then:

```bash
npm install @rbxts/react-clean-ui
```

```tsx
// src/client/demo.client.tsx
import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { CleanUiProvider, DefaultTheme, Container, Box, VStack, HStack, FlexItem, Text, Button, Fieldset, Input, Select } from "@rbxts/react-clean-ui";

const playerGui = game.GetService("Players").LocalPlayer.WaitForChild("PlayerGui") as PlayerGui;

const screenGui = new Instance("ScreenGui");
screenGui.ResetOnSpawn = false;
screenGui.IgnoreGuiInset = true;
screenGui.Parent = playerGui;

const root = ReactRoblox.createRoot(screenGui);

root.render(
  <CleanUiProvider theme={DefaultTheme}>
    <Container width="90%" center>
      <Box>
        <VStack>
          <Container>
            <HStack>
              <FlexItem>
                <Text text="Basic Form" variant="title" />
              </FlexItem>
              <Button icon="times" />
            </HStack>
          </Container>
          <Fieldset>
            <Fieldset.Label>
              <Text text="Enter Name:" />
            </Fieldset.Label>
            <Fieldset.Control>
              <Input placeholder="John Doe" value="" />
            </Fieldset.Control>
          </Fieldset>
          <Fieldset>
            <Fieldset.Label>
              <Text text="Country:" />
            </Fieldset.Label>
            <Fieldset.Control>
              <Select>
                <Select.Option text="United Kingdom" />
                <Select.Option text="United States" />
                <Select.Option text="Canada" />
              </Select>
            </Fieldset.Control>
          </Fieldset>
          <Container>
            <Button text="Submit Form" intent="info" icon="arrow-circle-right" />
          </Container>
        </VStack>
      </Box>
    </Container>
  </CleanUiProvider>
);
```

See the [Quick Start docs](https://shadercloud.github.io/rbxts-react-clean-ui/quickstart) for the full walkthrough (including `default.project.json` setup), and the [`Stories`](./Stories) directory for live UI Labs examples you can open directly in Roblox Studio.

## Project status

React Clean UI is under active development and being built in public. APIs, component props, and installation details may still change before a first stable release. Feedback, issues, and contributions are welcome.

## License

[ISC](./LICENSE)
