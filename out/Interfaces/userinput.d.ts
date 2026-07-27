export interface DisconnectableSignal {
    Disconnect(): void;
}
export interface ConnectableSignal<TArgs extends unknown[]> {
    Connect(callback: (...args: TArgs) => void): DisconnectableSignal;
}
interface InputSignalsLike {
    InputBegan: ConnectableSignal<[
        input: InputObject,
        gameProcessed: boolean
    ]>;
    InputChanged: ConnectableSignal<[
        input: InputObject,
        gameProcessed: boolean
    ]>;
    InputEnded: ConnectableSignal<[
        input: InputObject,
        gameProcessed: boolean
    ]>;
}
export declare const CustomInputService: InputSignalsLike;
export {};
