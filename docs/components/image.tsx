import Zoom from "react-medium-image-zoom";

const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? "";

export function Image(props: React.ComponentProps<"img">) {
    let src = props.src;

    if (
        typeof src === "string" &&
        src.startsWith("/") &&
        !src.startsWith(basePath + "/")
    ) {
        src = `${basePath}${src}`;
    }

    return (
        <Zoom>
            <img {...props} src={src} />
        </Zoom>
    );
}