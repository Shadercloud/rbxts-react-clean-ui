import { Storybook } from "@rbxts/ui-labs";
import { ReplicatedStorage } from "@rbxts/services";

const storybook: Storybook = {
   name: "Chart",
   storyRoots: [
      ReplicatedStorage.WaitForChild("PackageStories").WaitForChild("Chart"),
   ],
};

export = storybook;