import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Interaction",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Interaction"),
   ],
};

export = storybook;