export const appName = 'React Clean UI';
const basePath = process.env.NODE_ENV === "production"
  ? "/rbxts-react-clean-ui"
  : "";

export const docsRoute =  `${basePath}/`;
export const docsImageRoute =  `${basePath}/og/docs`;
export const docsContentRoute = `${basePath}/llms.mdx/docs`;

// fill this with your actual GitHub info, for example:
export const gitConfig = {
  user: 'shadercloud',
  repo: 'rbxts-react-clean-ui',
  branch: 'master',
};
