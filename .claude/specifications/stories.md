# Stories

- Story files will be name as `*.story.tsx` and are used to demonstrate components and features

- Story file are located at `/Stories/` and should be placed into context subdirectories such as `/Stories/Chart/`

- Each subdirectory should have an `index.storybook.tsx` which will load the story files within the subdirectory

- When applicable put the demonstrated component within a Box or Card to make it look better.

- Include custom control options in the story to demonstrate features that will make a significant difference to the output of the component (not more than 3 custom controls unless specifically told otherwise).

- A fixture's own `Container` must never hardcode an opaque background — it renders directly inside the themed story panel, so a baked-in color ignores the selected theme. When a fixture needs an opaque white backdrop for `npm run screenshots`, it accepts an optional `screenshot?: boolean` prop and conditionally wraps its content in the single shared `Stories/ScreenshotFrame.tsx` component (`scripts/generate-screenshots.js` passes `--props '{"screenshot":true}'` during capture). Never create a separate wrapper file per component for this.