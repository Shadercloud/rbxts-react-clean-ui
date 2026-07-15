import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Layout",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Layout"),
   ],
};

export = storybook;