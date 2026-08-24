import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Surface",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Surface"),
   ],
};

export = storybook;
