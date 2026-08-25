# Loom

- Loom files will be put into context directories such as `/Scenes/Chart/*`
- Demonstration components in loom scenes should be placed within a `<Container>` component.  
The `Container` should have a specific pixel height that is appropriate for the demo.  The container should have either a 100% width, or some slightly less % width if it would be appropriate to have a board around the demo component.
- If demonstrated component has it's size determined by it's contents, such as a `<Text>` or `<Button>` component, then it does not need any `<Container>`