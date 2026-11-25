import React from "@rbxts/react";
import { Textarea } from "../../src/Components/Input/Textarea";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

const INITIAL_NOTES = ["Patch notes", "- New map: Harbor", "- Faster matchmaking", "- Fixed inventory sorting", "- Rebalanced the bow", "- Added emote wheel", "- Minor UI polish"].join("\n");

function TextareaPreview() {
    const [notes, setNotes] = React.useState(INITIAL_NOTES);

    return <Textarea value={notes} onChange={setNotes} controlled rows={4} placeholder="Write your notes..." maxLength={200} showCount />;
}

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="220" center>
                <Box>
                    <TextareaPreview />
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Textarea",
} as const;
