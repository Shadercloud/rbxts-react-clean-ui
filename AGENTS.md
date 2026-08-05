# Agent Instructions

This is an existing production codebase. Make focused, conservative changes that preserve current behaviour and public APIs unless the task explicitly requires otherwise.

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
