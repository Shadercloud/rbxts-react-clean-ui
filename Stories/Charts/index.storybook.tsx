import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Charts",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Charts"),
   ],
};

export = storybook;