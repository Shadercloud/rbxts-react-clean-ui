import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Forms",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Forms"),
   ],
};

export = storybook;