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

   * Architecture specifications: `/docs/architecture/*.md`
   * Feature specifications: `/docs/specifications/*.md`
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
* Do not add comments unless they provide necessary context and are consistent with the surrounding file.
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

* Follow applicable files in `/docs/architecture/`.
* Follow applicable files in `/docs/specifications/`.
* Resolve ambiguity by comparing the specification with existing implementation patterns.
* Do not silently contradict a specification.
* If the implementation and specification disagree, clearly identify the conflict before changing behaviour.
* Do not edit a specification file unless specifically told to.

## Components and Documentation

Unless explicitly instructed otherwise, when creating or updating a component:

* Create or update the corresponding `.mdx` documentation file.
* Match the structure and style of existing component documentation.
* Document the component’s purpose, public props, typical usage, and any important behaviour.
* Update relevant documentation indexes or navigation files when required by the existing documentation structure.

Documentation changes should remain scoped to the component being changed.

## Stories and Loom demos

When updating or creating components:

* Create or update the corresponding `*.story.tsx` file under `/Stories/`.
* Story will give a demonstration of the component
* Create or update the corresponding `*.loom.tsx` file under `/Scenes/`.
* Loom file will be a simplistic demonstration of the component.
* Story and Loom files will be put into context directories such as `/Stories/Chart/*` and `/scenes/Chart/*`
* When creating `.mdx` documentation files use a `<Demo>` component to embed the Loom file near the top of the documentation and an approciate code demo.
* Utilize the `/docs/specifications/stories.md` for story specifications.
* Utilize the `/docs/specifications/documentation.md` for documentation specifications.
* Utilize the `/docs/specifications/loom.md` for loom scene specifications.

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

### Verifying your work

Don't compile and invoke Lunit's runner yourself from a terminal -- the
working test runner is regenerated fresh by this extension into VS Code's
own extension storage (outside the project) before every run, and
hand-invoking Lunit's own bundled scripts directly is known not to work with
roblox-ts's module resolution. Ask the user to run the tests from VS Code's
Test Explorer (or the "Lunit: Run All Tests" command), and read the results
there or in the "Lunit" output channel.
<!-- END lunit-test-explorer:agent-instructions -->
