import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Input",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Input"),
   ],
};

export = storybook;