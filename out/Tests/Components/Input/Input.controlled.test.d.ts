type EchoMode = "defer" | "delay";
declare class InputControlledValidation {
    focusedKeepsTyping(mode: EchoMode): void;
    blurShowsFormatted(): void;
    unfocusedSyncsValue(): void;
}
export = InputControlledValidation;
