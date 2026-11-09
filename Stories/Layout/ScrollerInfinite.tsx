import React from "@rbxts/react";
import { Button, Container, FlexItem, HStack, Scroller as ScrollerComponent, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const PAGE_SIZE = 15;
const LOAD_DELAY = 0.6;

function ScrollerInfinite(props: { nearEndThreshold?: number; maxItems?: number; screenshot?: boolean } = {}) {
    const maxItems = props.maxItems ?? 60;
    const scrollerRef = React.useRef<ScrollingFrame>();
    const loadingRef = React.useRef(false);
    const mountedRef = React.useRef(true);
    const [count, setCount] = React.useState(PAGE_SIZE);
    const [loading, setLoading] = React.useState(false);
    const [scrollY, setScrollY] = React.useState(0);

    React.useEffect(() => {
        mountedRef.current = true;
        return () => {
            mountedRef.current = false;
        };
    }, []);

    const visibleCount = math.min(count, maxItems);
    const reachedEnd = visibleCount >= maxItems;

    const loadMore = () => {
        if (loadingRef.current || reachedEnd) return;
        loadingRef.current = true;
        setLoading(true);

        task.delay(LOAD_DELAY, () => {
            loadingRef.current = false;
            if (!mountedRef.current) return;
            setCount((current) => math.min(current + PAGE_SIZE, maxItems));
            setLoading(false);
        });
    };

    const rows: React.ReactElement[] = [];
    for (let index = 1; index <= visibleCount; index++) {
        rows.push(<Text key={`Item${index}`} text={`Item ${index}`} LayoutOrder={index} />);
    }
    rows.push(
        <Text
            key="Status"
            text={loading ? "Loading more..." : reachedEnd ? "End of list" : " "}
            variant="caption"
            LayoutOrder={visibleCount + 1}
        />,
    );

    const content = (
        <Container width={320} height={280}>
            <VStack spacing="sm">
                <Container width="100%">
                    <HStack Wraps={false} valign="Center">
                        <FlexItem>
                            <Text text={`${visibleCount}/${maxItems} items, scrolled ${scrollY}px`} />
                        </FlexItem>
                        <Button
                            text="Top"
                            icon="arrow-up"
                            Event={{
                                Activated: () => {
                                    if (scrollerRef.current) scrollerRef.current.CanvasPosition = new Vector2(0, 0);
                                },
                            }}
                        />
                    </HStack>
                </Container>
                <ScrollerComponent
                    ref={scrollerRef}
                    width="100%"
                    height="220"
                    spacing="sm"
                    nearEndThreshold={props.nearEndThreshold ?? 40}
                    onNearEnd={loadMore}
                    onScroll={(position) => setScrollY(math.floor(position.Y))}
                >
                    <VStack spacing="sm">{rows}</VStack>
                </ScrollerComponent>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ScrollerInfinite;
