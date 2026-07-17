# React Clean UI

This project is similar to Bootstrap or Shadecn framework but for Roblox-ts React.

It will allow you create smart looking UIs quickly with premade themed components instead of having to use and style the native Roblox UI elements directly.

# Installation
*Package is not yet published to NPM; this install will not work yet*

`npm install @rbxts/react-clean-ui`

# Usage

Coming Soon

Look in the `/Stories` directory to see examples of the working syntax

# Development Environment

If you want to help build `React Clean UI` you can setup a local development environment using these steps (this assumes you are familiar with roblox-ts and rojo):

1) Create new project directory, for example `C:\Users\username\Documents\dev-game`

2) Setup rbxts in the new directory (Leave "Project directory" blank and "Y" to all questions):
```
cd C:\Users\username\Documents\dev-game
npm init roblox-ts game
```

3) Install some basic packages:
```
npm install @rbxts/react @rbxts/react-roblox @rbxts/ui-labs @rbxts/services
```

4) Create Packages directory in `src/Packages`:
```
cd src
mkdir Packages
cd Packages
```

5) Clone the `React Clean UI` git repo into your Packages directory
```
git clone https://github.com/Shadercloud/rbxts-react-clean-ui
```

6) Update your `tsconfig.json` file in the root `dev-game` project to the following:
```json
{
	"compilerOptions": {
		"allowSyntheticDefaultImports": true,
		"downlevelIteration": true,
		"jsx": "react",
		"jsxFactory": "React.createElement",
		"jsxFragmentFactory": "React.Fragment",
		"module": "commonjs",
		"moduleResolution": "Node",
		"noLib": true,
		"resolveJsonModule": true,
		"experimentalDecorators": true,
		"forceConsistentCasingInFileNames": true,
		"moduleDetection": "force",
		"strict": true,
		"target": "ESNext",
		"typeRoots": [
			"node_modules/@rbxts"
		],
		"types": [
			"types"
		],
		"rootDir": "src",
		"outDir": "out",
		"baseUrl": "src",
		"incremental": true,
		"tsBuildInfoFile": "out/tsconfig.tsbuildinfo",
		"paths": {
			"@rbxts/react": [
				"../node_modules/@rbxts/react"
			],
			"@rbxts/react-roblox": [
				"../node_modules/@rbxts/react-roblox"
			],
			"@rbxts/ui-labs": [
				"../node_modules/@rbxts/ui-labs"
			],
			"@rbxts/services": [
				"../node_modules/@rbxts/services"
			],
			"@rbxts/react-clean-ui": [
				"Packages/rbxts-react-clean-ui"
			]
		}
	},
	"exclude": [
		"src/Packages/**/src",
		"src/Packages/**/node_modules",
		"src/Packages/**/out",
		"src/Packages/**/.vscode"
	]
}
```

7) In your root `dev-game` directory create a `default.project.json` file (for Rojo) and paste the following config into it:
```json
{
	"name": "React Clean UI Dev Environment",
	"globIgnorePaths": [
		"**/package.json",
		"**/tsconfig.json"
	],
	"tree": {
		"$className": "DataModel",
		"ServerScriptService": {
			"$className": "ServerScriptService",
			"TS": {
				"$path": "out/server"
			}
		},
		"ReplicatedStorage": {
			"$className": "ReplicatedStorage",
			"rbxts_include": {
				"$path": "include",
				"node_modules": {
					"$className": "Folder",
					"@rbxts": {
						"$className": "Folder",
						"compiler-types": {
							"$path": "node_modules/@rbxts/compiler-types"
						},
						"react": {
							"$path": "node_modules/@rbxts/react"
						},
						"react-roblox": {
							"$path": "node_modules/@rbxts/react-roblox"
						},
						"ui-labs": {
							"$path": "node_modules/@rbxts/ui-labs"
						},
						"services": {
							"$path": "node_modules/@rbxts/services"
						},
						"types": {
							"$path": "node_modules/@rbxts/types"
						},
						"rbxts-react-clean-ui": {
							"$path": "out/Packages/rbxts-react-clean-ui/out"
						}
					},
					"@rbxts-js": {
						"$path": "node_modules/@rbxts-js"
					}
				}
			},
			"TS": {
				"$path": "out/shared"
			},
			"PackageStories": {
				"$path": "out/Packages/rbxts-react-clean-ui/Stories"
			}
		},
		"StarterPlayer": {
			"$className": "StarterPlayer",
			"StarterPlayerScripts": {
				"$className": "StarterPlayerScripts",
				"TS": {
					"$path": "out/client"
				}
			}
		},
		"Workspace": {
			"$className": "Workspace",
			"$properties": {
				"FilteringEnabled": true
			}
		},
		"HttpService": {
			"$className": "HttpService",
			"$properties": {
				"HttpEnabled": true
			}
		},
		"SoundService": {
			"$className": "SoundService",
			"$properties": {
				"RespectFilteringEnabled": true
			}
		}
	}
}
```

8) You will need to have 3 separate terminals running

```
cd C:\Users\username\Documents\dev-game
npx rbxtsc -w
```

```
cd C:\Users\username\Documents\dev-game\src\Packages\rbxts-react-clean-ui
npx rbxtsc -w
```

9) Run Rojo
```
cd C:\Users\username\Documents\dev-game
rojo serve
```

10) Open up Roblox and connect to Rojo

11) Install the UI Labs plugin for Roblox as this will allow you to preview your development work: https://ui-labs.luau.page/docs/installation

In Roblox Studio if you go to `Plugins -> UI Labs` you should see a "button" in the story explorer