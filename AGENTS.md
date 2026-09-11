# Agent Instructions

This is an existing production codebase. Make focused, conservative changes that preserve current behaviour and public APIs unless the task explicitly requires otherwise.

## Subagent Usage

A specialized subagent exists for most work in this repo. Check the mapping below before doing matching work yourself, and delegate to the matching subagent even if the request did not explicitly ask for a subagent:

* Changes or fixes under `src/Components/**` (including theme/interface/context wiring) → **Component Writer**
* `.mdx` documentation under `docs/content/docs` → **Documentation Writer**
* `*.story.tsx` files under `/Stories/` → **Story Writer**
* `*.loom.tsx` scene files under `/Scenes/` → **Loom Scene Writer**
* npm helper scripts under `/scripts` (and their `package.json` entries) → **Script Coder**
* `@rbxts/lunit` test files (`**/*.{test,spec}.{ts,tsx}`) under `src/Tests/` → **Test Writer**

Rules for delegation:

1. Always run subagents in the background. This is a hard requirement: never block the conversation waiting on a subagent's result, even when it looks like the fastest path or the only remaining step. `run_in_background: false` is not an acceptable choice for these tasks.
2. Do not duplicate a subagent's work yourself while it runs — don't investigate, edit, or re-derive the same thing in parallel.
3. When a task is assigned to a subagent, tell the user which subagent it was assigned to and that it is running in the background.
4. When a subagent's result comes back, report what it found/changed to the user rather than re-verifying or re-explaining it from scratch.

## Before Making Changes

1. Read the relevant implementation files and their surrounding modules.
2. Review similar existing implementations to understand established patterns.
3. Check for applicable specifications:

   * Architecture specifications: `/.claude/architecture/*.md` (including `shared-modules.md`, the implementation notes for `src/Helpers`, `src/Interfaces`, `src/Contexts` and `src/Providers`)
   * Feature specifications: `/.claude/specifications/*.md` (including `testing.md` for `src/Tests`)
   * Component specs and their **Implementation notes**: `/.claude/specifications/components/<category>/<component>.md`. `src/` has no comments, so these notes are the only record of why non-obvious code is the way it is.
4. When a feature specification is located in a directory containing an `index.md`, read that file as additional context.
5. Identify existing helpers, components, types, and abstractions that can be reused.

Do not begin implementation until you understand the existing behaviour and conventions relevant to the task.

## Implementation Guidelines

* Match the existing coding style and formatting exactly.
* Follow established naming conventions.
* Reuse existing helpers and abstractions instead of introducing duplicates.
* Prefer the smallest change that fully satisfies the request.
* Keep changes scoped to the requested task.
* Do not reformat, rename, or refactor unrelated code.
* Avoid introducing new dependencies unless explicitly required.
* Preserve public APIs and existing behaviour unless explicitly asked to change them.
* **No comments in `src/`** (components, helpers, interfaces, contexts, providers, theme, and tests alike): no `//` lines, no trailing comments, no `/* */` or JSDoc blocks. If you delete code, delete its comment too, and remove any comment you find while editing a file. Rationale, pitfalls, rejected approaches and "why is this here" knowledge go in the matching `.claude/` file instead:
  * a component → the **Implementation notes** section of its spec at `.claude/specifications/components/<category>/<component>.md`
  * helpers, interfaces, contexts, providers → `.claude/architecture/shared-modules.md`
  * tests and test helpers → `.claude/specifications/testing.md`

  Write each note so a reader can find what it refers to without line numbers: name the symbol, prop or file. Read the relevant notes before changing that code.

  **The one exception:** the trailing colour-name comments on palette entries in `src/Theme/themes/*.theme.ts` (e.g. `Color3.fromHex("#2E9D63"), // Green`) stay. Keep them, and add one for any palette colour you add or change.
* Do not introduce speculative abstractions for potential future requirements.
* Prefer consistency with the codebase over generic best practices when the two differ.

## Architectural Changes

Before making a significant architectural change:

1. Explain why the existing architecture cannot reasonably support the requested change.
2. Describe the proposed approach and its trade-offs.
3. Prefer extending an existing pattern over introducing a new one.

Do not make broad architectural changes when a local solution is sufficient.

## Specifications

Specifications are authoritative when they apply to the requested task.

* Follow applicable files in `/.claude/architecture/`.
* Follow applicable files in `/.claude/specifications/`.
* Resolve ambiguity by comparing the specification with existing implementation patterns.
* Do not silently contradict a specification.
* If the implementation and specification disagree, clearly identify the conflict before changing behaviour, and add an entry to `/.claude/ISSUES.md` describing it (unless you're fixing it in the same change) so it stays tracked instead of getting rediscovered later.
* Do not edit a specification file unless specifically told to, **except** the per-component behaviour specs under `/.claude/specifications/components/`, which are updated as part of ordinary component work per "Components and Documentation" below.

## Components and Documentation

Unless explicitly instructed otherwise, when creating or updating a component:

* Create or update the corresponding `.mdx` documentation file.
* Match the structure and style of existing component documentation.
* Document the component’s purpose, public props, typical usage, and any important behaviour.
* Update relevant documentation indexes or navigation files when required by the existing documentation structure.
* Create or update the component's behaviour spec at `/.claude/specifications/components/<category>/<component>.md` (category is the lowercase form of its `src/Components/<Category>/` folder). Do this even for a component created ad hoc without an explicit request for a spec — it is not optional follow-up work. Keep the spec minimal: only what's needed to reimplement similar behaviour, public API, theming, and layout — not a restatement of the code. Match the depth and structure of existing specs such as `layout/accordion.md` and `chart/barchart.md`, scaled down for simpler components, and reference (rather than repeat) shared conventions already documented in `components/index.md` or the category's own `index.md`.

Documentation changes should remain scoped to the component being changed.

## Stories and Loom demos

When updating or creating components:

* Create or update the corresponding `*.story.tsx` file under `/Stories/`.
* Story will give a demonstration of the component
* Create or update the corresponding `*.loom.tsx` file under `/Scenes/`.
* Loom file will be a simplistic demonstration of the component.
* Story and Loom files will be put into context directories such as `/Stories/Chart/*` and `/scenes/Chart/*`
* When creating `.mdx` documentation files use a `<Demo>` component to embed the Loom file near the top of the documentation and an approciate code demo.
* Utilize the `/.claude/specifications/stories.md` for story specifications.
* Utilize the `/.claude/specifications/documentation.md` for documentation specifications.
* Utilize the `/.claude/specifications/loom.md` for loom scene specifications.

## Validation

After making changes:

* Review the final diff for unrelated modifications.
* Confirm that formatting matches the surrounding code.
* Run the most relevant available type checks, tests, linting, or build commands.
* Add or update tests when behaviour changes and an established test pattern exists.
* Do not claim validation succeeded unless the relevant command was actually run successfully.
* Clearly report any checks that could not be run.

## Final Response

Summarize:

* What changed.
* Any important implementation decisions.
* Which tests or validation commands were run.
* Any unresolved issues, assumptions, or specification conflicts.

## Git Commit Message

After completing and validating a code change, generate a suggested Git commit message.

* Do not create the commit unless explicitly asked.
* Base the message only on changes included in the final diff.
* Follow the repository’s existing commit-message convention when one can be identified from recent Git history.
* Otherwise, use Conventional Commits format:
  `<type>(optional-scope): <concise summary>`

* Use an imperative, present-tense summary.
* Keep the first line concise, preferably no longer than 72 characters.
* Use a scope only when it adds useful context.
* Add a body when the change requires explanation, has multiple significant parts, or includes an important implementation decision.
* Describe why the change was made when that is not obvious from the summary.
* Do not mention tests, documentation, or refactoring unless they were actually changed.
* Do not include unrelated changes in the message.

Common commit types include:

* `feat`: Adds or changes user-facing functionality.
* `fix`: Corrects faulty behaviour.
* `docs`: Changes documentation only.
* `test`: Adds or updates tests only.
* `refactor`: Restructures code without changing behaviour.
* `style`: Changes formatting without affecting behaviour.
* `chore`: Updates tooling, configuration, or maintenance code.
* `perf`: Improves performance.

Include the suggested commit message in the final response in a copyable code block.

<!-- BEGIN lunit-test-explorer:agent-instructions -->
<!-- Auto-generated by the "Lunit: Add/Update Agent Instructions" VS Code command.
     Re-running it replaces only the text between these markers, so anything
     you add outside them is preserved. -->

## Testing (`@rbxts/lunit`, via the "Lunit Test Explorer" VS Code extension)

This project's tests are written with **@rbxts/lunit** (a class + decorator
based test framework) and are discovered/run through the **Lunit Test
Explorer** VS Code extension's Test Explorer integration -- not a script you
invoke yourself. See "Verifying your work" below before trying to run them.

### Where tests live

Test source files match the glob `**/*.{test,spec}.{ts,tsx}` (relative to the
workspace folder), excluding `**/node_modules/**`. A file is usually one
test class.

### How a test file is structured

```ts
import { Test, Assert } from "@rbxts/lunit";

class MyFeature {
	@Test
	public doesTheThing() {
		Assert.equal(1 + 1, 2);
	}
}

export = MyFeature;
```

- The class must be the module's sole export via `export = ClassName`, not a
  named `export class` -- the test runner requires the compiled module and
  expects it to evaluate directly to the class.
- `@Test` marks a method as a test case (with or without `()`).
- Other `@rbxts/lunit` decorators, usable at class or method level:
  `@DisplayName("...")`, `@Skip(condition, "reason")`, `@Only`,
  `@Each([[...], [...]])` (one independent result per row), `@Retry(n)`,
  `@Repeat(n)`, `@Timeout(ms)`, `@Order(n)`, `@Disabled("reason")`,
  `@Negated`, and the lifecycle hooks `@Before`/`@BeforeEach`/`@BeforeAll`,
  `@After`/`@AfterEach`/`@AfterAll`.

### Running under Lune vs. Roblox Studio -- `@Tag("Studio")` / `@Tag("Lune")`

This extension runs tests two ways: a fast, headless **"Run with Lune"**
profile, and a **"Run in Roblox Studio"** profile for tests that need real
Roblox APIs.

Tag a test `@Tag("Studio")` (class or method level) if it touches `game`,
mounts a `@rbxts/react`/`@rbxts/react-roblox` component, creates real
`Instance`s, or otherwise needs actual Roblox Studio to run -- it will then
be skipped entirely under "Run with Lune" (never attempted, never shown as a
failure there). Tag `@Tag("Lune")` for the rare test that should *only* run
under Lune, excluding it from "Run in Roblox Studio". An untagged test runs
under both. Don't leave a Studio-only test untagged expecting it to "skip
gracefully" under Lune -- tag it, or it will either fail to load or (worse)
partially execute against APIs that don't exist there.

```ts
import { Test, Tag } from "@rbxts/lunit";

@Tag("Studio")
class MountsAComponent {
	@Test
	public rendersWithoutErrors() {
		// uses game / Instance.new / React mounting -- Studio only
	}
}

export = MountsAComponent;
```

### Verifying your work: run the tests from the terminal

Don't compile and invoke Lunit's runner yourself -- the working test runner
is regenerated fresh by the extension before every run, and hand-invoking
Lunit's own bundled scripts directly is known not to work with roblox-ts's
module resolution. Instead, run the extension's own command-line entry point,
which executes the tests through the exact same code path as clicking "Run in
Roblox Studio" / "Run with Lune" in the Test Explorer and prints the same
per-test results (the run also shows up in the user's Testing view):

```sh
node "C:\Users\david\AppData\Roaming\Code\User\globalStorage\shadercloud.vscode-lunit-companion\lunit-cli.js" --studio
```

- `--studio` (default) runs in Roblox Studio; `--lune` runs headlessly with
  Lune (Lune can't run `@Tag("Studio")` tests, so prefer `--studio` to
  verify everything at once).
- Add one or more filters to run a subset, e.g. `... --studio MyFeature`
  or `... --studio src/foo.test.ts` -- case-insensitive substrings matched
  against each test's file path, class name, method name and display name.
- Add `--json` for a machine-readable summary on stdout (`tests[]` with
  `status`, `message`, `file`, `className`, `methodName`; `counts`).
- Exit code 0 means every test passed (or was skipped); 1 means at least one
  failed or errored (each is listed with its failure message); 2 means the run
  couldn't be performed at all -- read the printed reason, fix it if it's about
  your code, otherwise report it to the user.
- Studio runs can take a while (up to a few minutes if a new Studio process
  has to be launched); wait for the command to finish rather than assuming
  it hung. Use `--help` for every option.
<!-- END lunit-test-explorer:agent-instructions -->

## Running the tests in this repo (read before running)

The generated section above is generic; this package has a nested layout that
changes the exact invocation. Copy this rather than working it out:

```sh
# 1. Compile THIS package (the CLI's own compile step only builds the
#    dev-packages root, so skipping this runs stale Luau in Studio).
cd /c/Users/david/Documents/ROBLOX/dev-packages/Packages/rbxts-react-clean-ui && npx rbxtsc

# 2. Run from the dev-packages root -- that's the Rojo project synced into Studio.
cd /c/Users/david/Documents/ROBLOX/dev-packages && \
  node "$APPDATA/Code/User/globalStorage/shadercloud.vscode-lunit-companion/lunit-cli.js" \
  --studio --workspace "$(pwd -W)" [filter ...]
```

* Always use the `globalStorage/.../lunit-cli.js` launcher above. It is
  rewritten on every extension activation to point at the installed version;
  hard-coded `~/.vscode/extensions/shadercloud.vscode-lunit-companion-<ver>/out/cli.js`
  paths break whenever the extension updates.
* Scope runs with a filter (`Grid`, `Increment`, `Components/Layout`) while
  iterating; run unfiltered `--studio` before reporting done.
* `--lune` runs only `@Tag("Lune")`/untagged classes and finishes in seconds.
  It prints `failed to load test module ... module not found: .../@rbxts/react`
  warnings for every Studio-tagged file -- those are expected, not failures.
  Trust the final `[lunit] N tests via Lune: X passed, Y failed.` line and the
  exit code.
* Studio runs need `rojo serve` actively syncing into the open Studio. If
  previously-passing tests suddenly all fail, or results don't reflect your
  edit, suspect the sync first. Studio also keeps required modules cached for
  the session: after editing a component (not just a test), ask the user to
  restart Studio / re-sync before trusting the result.
* Studio mount tests that read layout must mount through
  `mountInScreenGui`/`withMounted` in `src/Tests/Helpers/layout.ts` (a
  `ScreenGui` in `CoreGui`) -- a detached Frame is never laid out, so
  `AbsoluteSize` and text bounds stay 0 or stale. `withMounted` always
  unmounts and destroys the host; with `mountInScreenGui`, call `unmount()`
  yourself. The same file has the `waitFor*`/`assert*` layout helpers.
* If a Studio test fails, confirm the behaviour is actually wrong (e.g. visible
  in the component's story) before changing `src/Components/**` -- don't bend
  a component to satisfy a test.
* Other fast checks: `npm run typecheck`, `npm run lint`, `npm run build`
  (all run from this package's folder).

## Test layout and naming (project conventions)

* `src/Tests/` mirrors `src/`: a test for `src/<path>/<Module>.ts(x)` lives at
  `src/Tests/<path>/<Module>.test.ts(x)` (e.g.
  `src/Tests/Components/Input/Increment.test.tsx`,
  `src/Tests/Components/Input/Increment.step.test.ts`,
  `src/Tests/Providers/modal.provider.test.tsx`). There are no `Lune/` or
  `Studio/` folders -- the runtime split is expressed only with `@Tag("Lune")`
  (pure logic) or `@Tag("Studio")` (mounts React / creates Instances) on the
  class.
* Test method names are short, punchy camelCase titles of a few words
  (`defaultStep`, `clampsToMax`, `noDecimalDrift`). Every `@Test` method also
  carries a `@DisplayName("...")` with a short sentence-case description of
  the scenario and expected outcome that adds detail rather than restating the
  method name.
