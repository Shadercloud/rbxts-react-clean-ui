import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Icons",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Icons"),
   ],
};

export = storybook;