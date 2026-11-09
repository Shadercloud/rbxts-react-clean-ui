import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Card } from "../../../Components/Surface/Card";
import { Text } from "../../../Components/Typography/Text";
import {
	STUDIO_SKIP_MESSAGE,
	sizeConstraintsOf,
	soleSizeConstraint,
	waitForGuiObject,
	waitForWidth,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 300;

@Tag("Studio")
class CardSizeConstraint {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without min or max props neither the overlay wrapper nor the Card box gets a UISizeConstraint")
	@Test
	public noConstraintWhenUnset() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Card width="100%">
				<Card.Header overlay={true}>
					<Text text="Header" />
				</Card.Header>
				<Card.Body>
					<Text text="Body" />
				</Card.Body>
			</Card>,
			(mounted) => {
				const wrapper = waitForGuiObject<Frame>(mounted.host, "CardOverlayWrapper");
				const box = waitForGuiObject<GuiObject>(wrapper, "Card");

				Assert.equal(sizeConstraintsOf(wrapper).size(), 0);
				Assert.equal(sizeConstraintsOf(box).size(), 0);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With an overlay header the wrapper and the Card box both carry the constraint and clamp to the same width")
	@Test
	public overlayWrapperClamped() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Card width="100%" maxWidth={200}>
				<Card.Header overlay={true}>
					<Text text="Header" />
				</Card.Header>
				<Card.Body>
					<Text text="Body" />
				</Card.Body>
			</Card>,
			(mounted) => {
				const wrapper = waitForGuiObject<Frame>(mounted.host, "CardOverlayWrapper");
				const box = waitForGuiObject<GuiObject>(wrapper, "Card");

				Assert.equal(soleSizeConstraint(wrapper).MaxSize.X, 200);
				Assert.equal(soleSizeConstraint(box).MaxSize.X, 200);
				waitForWidth(wrapper, 200);
				waitForWidth(box, 200);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A centred Card clamps its box while the full-size centre wrapper gets no constraint")
	@Test
	public centerWrapperUnconstrained() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Card center={true} width="100%" maxWidth={180}>
				<Card.Body>
					<Text text="Body" />
				</Card.Body>
			</Card>,
			(mounted) => {
				const wrapper = waitForGuiObject<ImageLabel>(mounted.host, "CardCenterWrapper");
				const box = waitForGuiObject<GuiObject>(wrapper, "Card");

				Assert.equal(sizeConstraintsOf(wrapper).size(), 0);
				soleSizeConstraint(box);
				waitForWidth(box, 180);
			},
		);
	}
}

export = CardSizeConstraint;
