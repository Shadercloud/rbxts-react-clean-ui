import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Navigation",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Navigation"),
   ],
};

export = storybook;
