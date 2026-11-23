import React from "@rbxts/react";
import { Workspace } from "@rbxts/services";
import { toDesignPixels } from "../Helpers/uiscale.helper";

export const UiScaleContext = React.createContext<number>(1);

export function useUiScale(): number {
    return React.useContext(UiScaleContext);
}

function getViewportSize(): Vector2 | undefined {
    return Workspace.CurrentCamera?.ViewportSize;
}

export function useDesignViewportSize(): Vector2 {
    const scale = useUiScale();
    const [viewportSize, setViewportSize] = React.useState<Vector2>(() => getViewportSize() ?? Vector2.zero);

    React.useEffect(() => {
        let viewportConnection: RBXScriptConnection | undefined;

        const update = () => {
            const resolved = getViewportSize();

            if (resolved !== undefined) {
                setViewportSize(resolved);
            }
        };

        const bindCamera = () => {
            viewportConnection?.Disconnect();
            viewportConnection = undefined;

            const camera = Workspace.CurrentCamera;

            if (camera !== undefined) {
                viewportConnection = camera.GetPropertyChangedSignal("ViewportSize").Connect(update);
            }

            update();
        };

        const cameraConnection = Workspace.GetPropertyChangedSignal("CurrentCamera").Connect(bindCamera);

        bindCamera();

        return () => {
            cameraConnection.Disconnect();
            viewportConnection?.Disconnect();
        };
    }, []);

    return toDesignPixels(viewportSize, scale);
}
