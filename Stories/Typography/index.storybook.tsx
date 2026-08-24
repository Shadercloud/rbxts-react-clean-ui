import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Typography",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Typography"),
   ],
};

export = storybook;
