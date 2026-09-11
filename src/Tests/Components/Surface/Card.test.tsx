import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Card } from "../../../Components/Surface/Card";
import { Text } from "../../../Components/Typography/Text";
import {
	STUDIO_SKIP_MESSAGE,
	assertAlignedLeft,
	assertAlignedTop,
	assertAllDescendantsContained,
	assertCenteredIn,
	assertContained,
	assertMinSize,
	assertNoSiblingOverlap,
	assertNonZeroSize,
	assertSizeApprox,
	assertStackedVertically,
	assertTextFits,
	findDescendant,
	findDescendantOfClass,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const SHORT_TITLE = "Card title";

const LONG_TITLE = string.rep("Averyverylongcardheadertitle ", 7).sub(1, 200);

type CardSection = "CardHeader" | "CardBody" | "CardFooter";

function cardWithSections(title: string) {
	return (
		<Card>
			<Card.Header>
				<Text text={title} />
			</Card.Header>
			<Card.Body>
				<Text text="Body copy for the card under test." />
			</Card.Body>
			<Card.Footer>
				<Text text="Footer" />
			</Card.Footer>
		</Card>
	);
}

function waitForCard(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Card");
}

function findSection(card: Instance, name: CardSection): GuiObject {
	return findDescendant<GuiObject>(card, name);
}

function findHeaderText(card: Instance): TextLabel {
	return findDescendantOfClass(findSection(card, "CardHeader"), "TextLabel");
}

@Tag("Studio")
class CardMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Mounting a Card with default props renders its root Box with a non-zero AbsoluteSize")
	@Test
	public mountsWithSize() {
		withMounted(400, 300, cardWithSections(SHORT_TITLE), (mounted) => {
			const card = waitForCard(mounted.host);

			assertNonZeroSize(card, "mounted card");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With only a body and default props, every visible descendant stays inside the Card")
	@Test
	public defaultPropsContained() {
		withMounted(
			400,
			300,
			<Card>
				<Card.Body>
					<Text text="Body copy for the card under test." />
				</Card.Body>
			</Card>,
			(mounted) => {
				const card = waitForCard(mounted.host);

				assertAllDescendantsContained(card, "default props");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With a short header, body and footer, every visible descendant stays inside the Card")
	@Test
	public shortHeaderContained() {
		withMounted(400, 300, cardWithSections(SHORT_TITLE), (mounted) => {
			const card = waitForCard(mounted.host);

			assertAllDescendantsContained(card, "short header");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A 200-character header in a 240px host stays inside the Card, and the Card stays inside its host")
	@Test
	public longHeaderContained() {
		withMounted(240, 600, cardWithSections(LONG_TITLE), (mounted) => {
			const card = waitForCard(mounted.host);

			assertContained(card, mounted.host, "long header (card vs host)");
			assertAllDescendantsContained(card, "long header");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A 200-character header stays inside a Card whose width is pinned to 240px")
	@Test
	public longHeaderFixedWidth() {
		withMounted(
			400,
			600,
			<Card width={240}>
				<Card.Header>
					<Text text={LONG_TITLE} />
				</Card.Header>
				<Card.Body>
					<Text text="Body copy for the card under test." />
				</Card.Body>
			</Card>,
			(mounted) => {
				const card = waitForCard(mounted.host);

				assertSizeApprox(card, 240, undefined, 1, "long header fixed width");
				assertAllDescendantsContained(card, "long header fixed width");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["short", SHORT_TITLE, 400],
		["long", LONG_TITLE, 240],
	])
	@DisplayName("The header's TextLabel reports its text as fitting for both short and long titles")
	@Test
	public headerTextFits(variant: string, title: string, hostWidth: number) {
		withMounted(hostWidth, 600, cardWithSections(title), (mounted) => {
			const card = waitForCard(mounted.host);
			const label = findHeaderText(card);

			assertTextFits(label, `${variant} header`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Header, body and footer are laid out as non-overlapping siblings inside the Card")
	@Test
	public sectionsDoNotOverlap() {
		withMounted(400, 300, cardWithSections(SHORT_TITLE), (mounted) => {
			const card = waitForCard(mounted.host);

			const header = findSection(card, "CardHeader");
			const body = findSection(card, "CardBody");
			const footer = findSection(card, "CardFooter");
			Assert.equal(header.Parent, card, "Expected CardHeader to be a direct child of the Card's Box");
			Assert.equal(footer.Parent, card, "Expected CardFooter to be a direct child of the Card's Box");
			Assert.equal(body.Parent?.Parent, card, "Expected CardBody's FlexItem wrapper to be a direct child of the Card's Box");

			assertNoSiblingOverlap(card, "card sections");

			assertStackedVertically([header, body, footer], "card sections");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("center={true} with a fixed width and height places the Card in the middle of the host")
	@Test
	public centeredInHost() {
		withMounted(
			400,
			300,
			<Card center={true} width={200} height={100}>
				<Card.Body>
					<Text text="Centered" />
				</Card.Body>
			</Card>,
			(mounted) => {
				const card = waitForCard(mounted.host);

				assertSizeApprox(card, 200, 100, 1, "centered card");
				assertCenteredIn(card, mounted.host, "both", 1, "centered card");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without center, a fixed-size Card sits flush with the host's top-left corner")
	@Test
	public leftAlignedByDefault() {
		withMounted(
			400,
			300,
			<Card width={200} height={100}>
				<Card.Body>
					<Text text="Top left" />
				</Card.Body>
			</Card>,
			(mounted) => {
				const card = waitForCard(mounted.host);

				assertAlignedLeft(card, mounted.host, 1, "uncentered card");
				assertAlignedTop(card, mounted.host, 1, "uncentered card");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[300, 150],
		[120, 80],
	])
	@DisplayName("Explicit width and height props pin the Card's AbsoluteSize to those pixel values")
	@Test
	public respectsExplicitSize(width: number, height: number) {
		withMounted(
			400,
			300,
			<Card width={width} height={height}>
				<Card.Body>
					<Text text="Sized" />
				</Card.Body>
			</Card>,
			(mounted) => {
				const card = waitForCard(mounted.host);

				assertSizeApprox(card, width, height, 1, "explicit size");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With only a width set, the Card keeps that width and grows in height to fit tall body content")
	@Test
	public growsWithContent() {
		withMounted(
			400,
			600,
			<Card width={300}>
				<Card.Body>
					<frame key="TallContent" BackgroundTransparency={1} Size={UDim2.fromOffset(50, 400)} />
				</Card.Body>
			</Card>,
			(mounted) => {
				const card = waitForGuiObject<ImageLabel>(
					mounted.host,
					"Card",
					(gui) => gui.AbsoluteSize.Y >= 400,
					"Timed out waiting for the Card to grow to at least its 400px body content",
				);

				assertSizeApprox(card, 300, undefined, 1, "auto-height card");
				assertMinSize(card, undefined, 400, "auto-height card");
				assertAllDescendantsContained(card, "auto-height card");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Narrowing the host from 400px to 240px keeps every descendant inside the Card")
	@Test
	public resizeKeepsContained() {
		withMounted(400, 600, cardWithSections(LONG_TITLE), (mounted) => {
			const card = waitForCard(mounted.host);
			assertAllDescendantsContained(card, "before resize");

			mounted.resize(240, 600);

			assertContained(card, mounted.host, "after resize (card vs host)");
			assertAllDescendantsContained(card, "after resize");
		});
	}
}

export = CardMountValidation;
