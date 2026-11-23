# Shared modules

Implementation notes for src/Helpers, src/Interfaces, src/Contexts and src/Providers — src/ carries no comments, so non-obvious rationale lives here.

## src/Helpers/color.helper.ts

- `ColorHelper.getIntentColors`: the tier cascade and layer order are specified in [components/index.md](../specifications/components/index.md#theming). A component or override entry can be either per-state `InlineIntentColors` or a flat `Partial<IntentScheme>`. A flat entry is applied as that tier's `default` layer for every requested state and never adds a state layer.
- `defaultMatching` (`theme.colors.intents[selectedIntent]`) is optional-chained because `ThemeTemplate.colors.intents` types `secondary` as optional. A hand-written `ThemeTemplate` that predates `secondary` still resolves it, falling back to the primary layers. Keep any new intent optional the same way, or adding it breaks every custom theme literal.
- `IntentScheme.borderThickness` is an ordinary last-wins scalar. Only `Button` and the `Tabs` title button read it.
- `isInlineIntentColors` only checks for a `default`, `hover` or `focus` key. An entry that sets only `disabled` is treated as a flat scheme, so its `disabled` override is silently ignored.
- `mergeLayers` merges `backgroundImage`, `backgroundGradient` and `typography` field by field. Every other field is last-wins. A new nested-object field on `IntentScheme` needs its own accumulator here, or a partial state layer will silently drop the earlier layers' fields. Inside `backgroundGradient`, `colors`/`stops` are leaf values: a layer that sets `colors` replaces the whole array and also resets `stops` to its own `stops` (or `undefined`, so even spacing, when it sets none), because stops tuned for a different colour list would be misplaced. A layer that sets `stops` without `colors` overrides `stops` on the inherited colours, and a layer that sets neither keeps both.

## src/Helpers/css.helper.ts

- `parseCssSize` supports exactly one calc() shape: `"<n>% - <n>px"` or `"<n>% + <n>px"`. It splits on the literal `" - "`/`" + "`, so the spaces are required, and it keeps only the left term's Scale and the right term's Offset. Any other string falls through to single-token parsing.
- `resolveBackgroundGradient` takes a `Partial<CssBackgroundGradient>`, so `Gradient` can pass a merged `IntentScheme.backgroundGradient` straight through. It returns `undefined` when `value` is `undefined`, `colors` is unset, or `colors` is an empty array. Keep that guard here, where the partial is resolved, rather than at call sites. `buildColorSequence` indexes `colors[0]`, so it must never see an empty array.
- `buildColorSequence` always forces the first color to Time `0` and the last to Time `1`, because Roblox rejects a `ColorSequence` otherwise. As a result, the first and last `stops` entries are always overridden. It then sorts keypoints by Time, because Roblox also throws on non-ascending times (out-of-order interior `stops`). The sort tie-breaks on array index because Luau's `table.sort` isn't stable, so colors that share a Time keep their authored order.

## src/Helpers/element.helper.ts

- `ElementHelper.assignRef(ref, instance)` hands an instance to a forwarded ref: it calls a function ref, or sets `.current` on an object ref. Use it whenever a component merges a forwarded ref with an internal callback ref (`Text`, `Scroller`, `BreakpointProvider`). The object branch uses a truthiness check (`elseif ref then` in Luau), not `ref !== undefined`, on purpose. In Roblox React an absent forwarded ref is `nil`, but in browser React (the docs' Loom preview) it is `null`, which passes a `!== undefined` check and crashes on `.current`.
- `ElementHelper.cloneWithEvents(element, props, events)` clones an element and adds event handlers. The original handler runs first, then the new one. Use it instead of `React.cloneElement(child, { Event: {...} })` whenever the child may be a native element. `@rbxts/react` only turns `Event={{...}}` into `React.Event.*` keys inside its own `createElement`. `cloneElement` skips that step, so a raw `Event` table on a host element is assigned as `instance.Event` and throws, unmounting the root. The same applies to reading a native child's existing handler: it lives under `props[React.Event.Name]`, and `props.Event` is always `undefined`. Component children still get a merged `Event` table, because that is what they receive and forward.
- `React.Event` isn't in `@rbxts/react`'s typings, so `getEventKey` reaches it through a cast. The keys are cached per event name by react-lua, so they compare equal to the ones `createElement` produced.

## src/Helpers/gamepad.helper.ts

- `GamepadHelper` and `useGamepadSelection` are specified with `GamepadSelectionGuard` in [interaction/gamepadselectionguard.md](../specifications/components/interaction/gamepadselectionguard.md). `Modal` uses the hook, so changes affect both.
- It reads `UserInputService` directly, not `CustomInputService`: ui-labs' `Environment.InputListener` has no `GetLastInputType`/`LastInputTypeChanged`. In a ui-labs preview the last input type is whatever Studio reports, and assignments to `SelectedObject` fail silently (see `trySetSelectedObject`).
- `trySetSelectedObject` wraps the assignment in `pcall`, because it throws when the target isn't under a `PlayerGui`.
- `targetRef`/`optionsRef` are synced by an effect with no dependency array declared before the main effect, so the main effect (keyed on `enabled` only) always sees the latest target, scope and callbacks without reconnecting. `clearOnSelectionChange` is the exception: it decides whether a connection exists, so it is read once when the hook becomes enabled.
- If the target doesn't resolve on enable, the hook polls on `RunService.Heartbeat` (`pendingSelect`) until it does, instead of adding the target to the effect's dependencies: the target is usually a ref or a closure, so a dependency wouldn't change when the instance appears.
- The main effect remembers the last non-nil `scope.current` (`lastScope`). React detaches refs before passive cleanups run on unmount, so reading `scope.current` at cleanup alone would see `undefined`. A `scope` option that is set but unresolved counts as "nothing inside", never as "whole place".
- `typeIs(target, "function")` tells a getter from a ref. React refs are plain tables in Luau.

## src/Helpers/gui.helper.ts

- `getGuiRoot` returns the parent of the element's outermost `LayerCollector` (PlayerGui, CoreGui, PluginGuiService, StarterGui, ...). It used to return PlayerGui whenever the game was running and otherwise require a PluginGuiService ancestor, throwing `"No root"` for anything under CoreGui (where the Studio tests mount).
- `isGuiObjectHitAtPoint`: rect contains the point, the object and every `GuiObject` ancestor are `Visible`, no ancestor with `ClipsDescendants` (or a `CanvasGroup`) clips the point away, and the nearest `LayerCollector` is `Enabled` and not a `SurfaceGuiBase` (3D GUIs' absolute rects are in surface space, not screen space). Rotation is ignored. An object with no `LayerCollector` ancestor isn't drawn, so it never hits.
- `isRenderedAbove(a, b)` compares two objects' draw order without walking the whole GUI tree. `getGuiRenderOrder` would be too slow to run on every mouse move. Different surfaces: `ScreenGui.DisplayOrder` (0 for other `LayerCollector`s), then tree order. Same surface, `Global`: own `ZIndex`, then descendants above ancestors, then tree order. Same surface, `Sibling`: descendants above ancestors, then the `ZIndex` of the two diverging sibling branches, then child index. Tree order means the child index of the diverging branches under the lowest common ancestor, with the later child on top. Non-`GuiObject` branches (e.g. a `Folder`) fall back to child index. Callers should scan with it rather than sort, because Luau's `table.sort` isn't stable.
- Every point and rect `GuiHelper` compares is in screen pixels (input positions, `AbsolutePosition`, `AbsoluteSize`), so hit-testing is already correct under a `UiScaleRoot` and must not be converted with `toDesignPixels`.
- `getGuiObjectsAtPosition` is kept for API compatibility, but Draggable no longer uses it. It only searches under the highest `Frame` ancestor and sorts by `ZIndex` alone.
- `getGuiRenderOrder`: both sorts tie-break on child index (`rootIndex` for surfaces, `siblingIndex` for siblings) because Luau's `table.sort` is not stable. Without that, siblings with equal `DisplayOrder`/`ZIndex` come out in arbitrary order. A nested `LayerCollector` becomes its own render surface and is not recursed into from its parent surface.

## src/Helpers/size.helper.ts

- `"Auto"` for `width`/`height`: `GetAutoSize` treats it as unset when it picks the AutomaticSize axes, while `GetSize` resolves it to `0` on that axis. Together, that gives a zero base size that grows with content.

- `resolveRadius(theme, radius)` maps a radius token (`"sm"`/`"md"`/`"lg"`) to `theme.radius[token]` and returns any other value unchanged, so a call site keeps its own size parser (`toUDim` or `CssHelper.parseCssSize`, which differ on whitespace and invalid input) and existing pixel/percent values resolve exactly as before. `toRadius(theme, radius)` is `toUDim(resolveRadius(...))`. Every call site that turns a theme or prop radius into a `UDim` must go through one of them (or through `Corners`), or tokens fail: `toUDim("md")` asserts. `theme.radius.default` is not a token and isn't read anywhere.
- `size.helper.ts` imports `ThemeTemplate` from `../Theme` for types only. The import is elided in the compiled Luau, so there is no runtime require cycle with the theme files.
- `GetSizeConstraint(props)` returns `undefined` when none of `minWidth`/`maxWidth`/`minHeight`/`maxHeight` is set, so call sites render no `UISizeConstraint` at all and the instance tree is unchanged for existing code. Otherwise an unset minimum maps to `0` and an unset maximum to `math.huge` (the engine defaults). Values go through `toUDim(...).Offset`, so `"25px"`/`"25"`/numbers all work. Negative minimums clamp to `0`, and each maximum is raised to at least its minimum, because a `MaxSize` below `MinSize` is not a valid pair for `UISizeConstraint`. The engine applies `MinSize` to auto-sized instances but `MaxSize` doesn't stop `AutomaticSize` growth from child instances, so maximums only take effect on explicit or `%` axes (and on a `TextLabel`'s own wrapped text).

## src/Helpers/spacing.helper.ts

- `GetExplicitPadding` returns only a theme's tier-3 component padding, with no fallback to the spacing scale, and returns `undefined` when the theme sets none. Use it for an opt-in floor that must be a no-op in themes that don't configure padding (Card's wood-frame clearance). `GetResolvedPadding` always produces a value and would engage in every theme.

## src/Helpers/text.helper.ts

- `TextHelper` is the one place for anything that treats a string as characters rather than bytes. Luau strings are bytes: `#text`, `string.sub`, `string.lower` and Lua patterns all work per byte, so they cut or ignore multi-byte UTF-8 (accented Latin, Cyrillic, CJK, emoji). Splitting a string with `string.sub(i, i)` produces invalid single bytes that Roblox draws as "?" (the 2.1.1 letter-spaced `Text` bug).
- The file has no imports on purpose, so `lowercase`, `isComplexScript` and `isValidUtf8` can be required and tested headlessly under Lune. Only `splitGraphemes` needs Roblox: its non-ASCII path calls `utf8.graphemes`, which Lune does not have (`utf8.graphemes` is `nil` there). Its pure-ASCII, invalid-UTF-8 and complex-script paths do not reach that call.
- `utf8Length` is `utf8.len` cast to a single-return function instead of destructuring the `LuaTuple` (`const [length] = utf8.len(text)`). In Luau the call site simply takes the first return value (a number, or `nil` for invalid UTF-8; the typings say `false`, the engine returns `nil`, so the code checks `typeIs(length, "number")`). The Loom docs preview runtime's `utf8.len` returns a bare number, and destructuring that throws in the browser, which would crash every scene with letter-spaced `Text` or a searchable `Select`.
- "Pure ASCII" is detected as `utf8.len(text) === text.size()` (code points equal bytes). No byte-range Lua pattern is used because roblox-ts may emit a `"\x80"`-style TypeScript escape as a UTF-8 encoded code point rather than the raw byte.
- `lowercase(text)`: returns `string.lower(text)` for pure-ASCII or invalid-UTF-8 input (byte-identical to before). Otherwise it maps each code point: ASCII `A-Z`; Latin-1 `U+00C0..U+00DE` except `U+00D7` (multiplication sign); Latin Extended-A `U+0100..U+017F` (upper/lower pairs, `U+0178` to `U+00FF`); Greek `U+0391..U+03AB` plus the accented capitals `U+0386`, `U+0388..U+038A`, `U+038C`, `U+038E`, `U+038F`; Cyrillic `U+0400..U+042F`. Deliberately left alone: `U+0130`/`U+0131` (Turkish dotted/dotless i), `U+00DF` and `U+017F` (sharp s, long s), Greek final sigma `U+03C2` (not folded to `U+03C3`), every other script, and any normalisation of composed versus decomposed forms. It uses only `utf8.len`/`utf8.codes`/`utf8.char`, not the Roblox-only `utf8.nfcnormalize`, to stay Lune-testable.
- `isComplexScript(text)`: `true` when any code point falls in `COMPLEX_SCRIPT_RANGES`; `false` for pure-ASCII and for invalid UTF-8 (`utf8.codes` errors on invalid input, so validity is checked first). The ranges are right-to-left scripts, bidi controls, and scripts whose letters join or reorder when shaped, so they must not be drawn one cluster per `TextLabel`: `U+0590..U+0DFF` (Hebrew, Arabic, Syriac, Thaana, N'Ko, Samaritan, Mandaic, Arabic Extended, then Devanagari through Sinhala), `U+0F00..U+109F` (Tibetan, Myanmar), `U+1780..U+18AF` (Khmer, Mongolian), `U+200E..U+200F`, `U+202A..U+202E`, `U+2066..U+2069` (bidi marks, embeddings, isolates; `U+061C` is inside the first range), `U+FB1D..U+FDFF` and `U+FE70..U+FEFF` (Hebrew/Arabic presentation forms), `U+10800..U+11FFF` (supplementary right-to-left scripts and the supplementary Brahmic scripts), `U+1E800..U+1EFFF` (Mende Kikakui, Adlam, Arabic mathematical symbols). Thai and Lao (`U+0E00..U+0EFF`) are left out: their letters do not join and their marks stay inside the grapheme cluster. Zero-width joiner/non-joiner are left out too, because emoji sequences use the joiner and `utf8.graphemes` keeps those together.
- `splitGraphemes(text)` returns `undefined` to mean "do not split" (invalid UTF-8, or `isComplexScript`). Pure-ASCII input is split per byte, not through `utf8.graphemes`, because grapheme rules would merge `"\r\n"` into one cluster and change today's output. Everything else goes through `utf8.graphemes`, so a base letter with combining marks, a Hangul syllable, or an emoji/flag sequence is one entry. `""` returns an empty array.

## src/Helpers/typography.helper.ts

- `getClosestTypography`: for a per-scale `ScaledTypographyStyle`, it tries the exact scale, then the nearest smaller scale, then the nearest larger one.
- `toFontFace` is the only way components should turn a theme `Enum.Font` into a `FontFace`. Don't go back to `Font.fromName(font.Name, weight)`: it loads `rbxasset://fonts/families/<EnumName>.json`, and for legacy enums whose name isn't the family file (`Fantasy` -> `Balthazar`, `Garamond` -> `Guru`, `Bodoni` -> `AccanthisADFStd`, `Antique` -> `RomanAntique`, `SciFi` -> `Zekton`, `Cartoon` -> `ComicNeueAngular`, `Highway` -> `HighwayGothic`, `SourceSans*` -> `SourceSansPro`, ...) that file doesn't exist and Roblox silently renders Builder Sans. `toFontFace` takes only `.Family` from `Font.fromEnum(font)` and builds `new Font(family, weight ?? Regular, style ?? Normal)`.
- `toFontFace` deliberately ignores the weight/style baked into the enum (`GothamBold`, `SourceSansBold` -> Bold): the caller's weight applies, as it did with `fromName`.
- `toFontFace` wraps `Font.fromEnum` in `pcall` and falls back to `Font.fromName(font.Name, ...)` when it throws or yields an empty `Family` (`Enum.Font.Unknown`, enums newer than the engine).
- `toTextSize(size)` turns an `Enum.FontSize` into its pixel `TextSize` by parsing the item name (`Size18` -> `18`); it returns `undefined` for any name not shaped `Size<n>`. Parsing avoids a table of `Enum.FontSize` members built at require time, which would throw on a runtime missing one. Only `PreferredTextSizePin` calls it, and only while the pin is on.

## src/Helpers/uiscale.helper.ts

- `toDesignPixels(value, scale)` is `value / scale` and `toScreenPixels(value, scale)` is `value * scale`, overloaded so a `number` stays a `number` and a `Vector2` stays a `Vector2`. They are the only place a screen/design conversion is written: components call them with `useUiScale()` instead of an inline `/ scale`. Use behaviour and the list of converted components are in [layout/uiscaleroot.md](../specifications/components/layout/uiscaleroot.md).
- The file has no imports and touches no Roblox service, so it can be required under Lune. Only the `number` overload can actually run there; Lune has no `Vector2` global without `@lune/roblox`.
- At scale `1` both are exact identities (IEEE `x / 1 === x`), which is what keeps existing trees unchanged with no `UiScaleRoot`.

## src/Interfaces/css.types.ts

- `CssRadius` (`CssSize | CssRadiusToken`) is likewise kept separate from `CssSize` and used only for radius values, so a token can't leak into a width/position/padding value, where nothing resolves it.
- `CssCalcSize` is kept separate from `CssSize` on purpose. Folding the calc template literals into `CssSize` multiplies through `CssDual`/`CssQuad` and hits TypeScript's "union type that is too complex to represent" error at call sites that spread props with several quad fields (e.g. `<BoxShadow {...props} />` in `Button`). Use `CssCalcSize` only where a calc term is needed (currently `CssPosition.width`).
- `CssPixelSize` (`number | "<n>" | "<n>px"`) is the pixel-only subset of `CssSize`, used by the `SizeElementProps` min/max props. `UISizeConstraint` only takes pixel `Vector2`s, so `%` and `"Auto"` are excluded at the type level instead of being silently dropped at runtime.

## src/Interfaces/element.props.ts

- `BorderElementProps` (`borderThickness`, `borderColor`, `borderTransparency`, `borderPosition`) is shared by `Container` and `HoverButton`. Values are plain, not `Binding`s, because `borderThickness > 0` decides whether a `UIStroke` is rendered at all. The theme-driven borders elsewhere (`Box`'s `border-thickness`/`border-color`, `IntentScheme.borderThickness`) are unrelated and unchanged.
- `SizeElementProps.minWidth`/`maxWidth`/`minHeight`/`maxHeight` are separate props rendered as one `UISizeConstraint`, rather than a CSS `clamp(min, val, max)` form of `CssSize`. A clamp form was rejected because the engine constraint is a separate instance from `Size` and pixel-only: a clamp string would still need a pixel-only outer pair while the middle term carries `%`, would need a new parser, and couldn't sit on `Size` bindings or responsive `width`. Plain values, not `Binding`s: whether a `UISizeConstraint` exists at all depends on them being set.
- Each consumer draws the constraint on every instance whose `Size` comes from the component's size props (`Container`'s inner `ImageLabel`, `FadeGroup`, `Scroller`, `Slider`, plus `Card`'s overlay wrapper, `ProgressBar`'s labelled outer frame and `Modal`'s input-shield panel, alongside the inner box that also gets it). It is never drawn on a full-parent centring wrapper whose `Size` is `fromScale(1, 1)`. A consumer that also passes its own `<uisizeconstraint>` child alongside these props gets two; Roblox honours only one.

## src/Contexts/breakpoint.context.ts

- `BreakpointContext`, `useBreakpoint` and `useBreakpointValue` are specified with their provider in [layout/breakpointprovider.md](../specifications/components/layout/breakpointprovider.md), including the implementation notes on hook ordering and the camera/viewport fallback.

## src/Contexts/uiscale.context.ts

- `UiScaleContext` holds the **effective** scale (default `1`); `UiScaleRoot` provides `parent * own`, so nested roots multiply. `useUiScale` and `useDesignViewportSize` live here next to the context, the same way `useBreakpoint` lives in `breakpoint.context.ts`. Specified with the component in [layout/uiscaleroot.md](../specifications/components/layout/uiscaleroot.md).
- `useDesignViewportSize` keeps the raw `ViewportSize` in state and divides at render, so a scale change re-renders through the context without reconnecting anything. The camera binding (`bindCamera` on `Workspace.CurrentCamera` changes, a `ViewportSize` connection per camera) mirrors `useBreakpoint`'s viewport fallback.
- `useBreakpoint`'s viewport fallback divides `ViewportSize.X` by `useUiScale()` and lists the scale in its effect's dependencies, so the camera signals reconnect with the new scale. `useUiScale` is called unconditionally, after the two existing `useContext` calls, so the hook order doesn't depend on whether a provider is present.

## src/Contexts/textsize.context.ts

- `IgnorePreferredTextSizeContext` (`boolean`, default `false`) carries `CleanUiProvider`'s `ignorePreferredTextSize`; `useIgnorePreferredTextSize` reads it, next to the context like `useUiScale`. Behaviour is specified in [components/index.md](../specifications/components/index.md#player-text-size-preferredtextsize) and [typography/pintextsize.md](../specifications/components/typography/pintextsize.md). Context survives portals, so overlay content (Tooltip, Select, Modal, Toast) follows the provider's value.
- The opt-out is a child `UITextSizeConstraint` with equal min and max on each text instance, because Roblox has no global switch. It overrides RichText `<font size="...">` markup on that instance, so a caller's sized runs render at the label's size while the switch is on. The library emits no size markup itself.

## src/Contexts/overlay.context.ts

- `OverlayContextValue.scale` is optional and is the effective `UiScaleContext` scale at the `OverlayProvider`. A hand-built context value without it is treated as `1`. Portalling components compare it against their own `useUiScale()` through `OverlayScaleFrame`; see the portal notes in [layout/uiscaleroot.md](../specifications/components/layout/uiscaleroot.md#implementation-notes).

## src/Contexts/modal.context.ts

- `ModalStackContextValue.isTopmost` is optional so hand-built context values (tests, custom providers) still type-check; callers optional-chain it and treat a missing one as "topmost". `ModalProvider` implements it from `stackRef`, so it reflects the latest committed stack without changing the context value's identity.

## src/Contexts/draggable.context.ts

- `DragEventInfo` is the trailing argument of every Draggable/Droppable callback. `inputType` is the input that *started* the drag, not the one that triggered the callback (that one is in `input`).
- `DragStateContext` (`{ preview, dragging }`, default both `false`) is provided by `Draggable`. `preview` is `true` inside the overlay drag preview, where `Draggable.Handle`, `Droppable` and nested `Draggable` go inert and `Tooltip` never opens. `dragging` is `true` inside an original whose drag is in progress (OR-ed down through nested Draggables), where `Tooltip` stays closed. Anything that attaches interaction to the dragged content should read it the same way. See [layout/draggable.md](../specifications/components/layout/draggable.md).

## src/Providers/registry.provider.tsx

- `createRegistry()` builds a standalone registry. `RegistryProvider` creates one per provider instance (kept in state, so the context value is stable across renders; it used to be rebuilt every render, which re-ran every registration effect). `GlobalRegistry` is a module-level instance shared by every React root in the Luau VM.
- Draggable and Droppable register in both `GlobalRegistry` and the context registry (when present), and Draggable looks up droppables and active drags in `GlobalRegistry` only. That keeps drag/drop working with no provider and across separate React roots, while `registry.get(instance, DroppableRegistryKey)` on a provider's registry still works.
- `DroppableRegistration.dragEnter`/`dragLeave` are optional and `drop`'s `info` is optional, so registrations built by hand against the old shape still type-check.

## src/Providers/app.provider.tsx

- `CleanUiProvider`'s `ignorePreferredTextSize` (default `false`) is provided outermost, around `RegistryProvider`, so `ToastContainer` and everything portalled through `OverlayProvider` read it. A provider renders no instance, so the tree is unchanged.
