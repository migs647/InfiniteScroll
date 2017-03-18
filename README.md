# InfiniteScroll
An iOS control to indefinitely scroll vertically without hitting the end of a scrollview.

## Installation

```bash
$ git clone git@github.com:migs647/InfiniteScroll.git
$ cd InfiniteScroll
$ git submodule init && git submodule update
```

## Synopsis

Code sample that demonstrates the ability to scroll indefinitely with a limited amount of cells. This challenge is interesting for cell reuse, user interaction issues and expandability.

Included is a networking layer to read iTunes RSS feed and load up the scrollview with data.

## Original Request

- Each label should display three lines of text with 32px margins on top/bottom and 16px left/right - we haven’t decided on a font. (We also might be changing the margins). This would be considered the minimized state.

- The labels respond to taps by growing to show their full text, preserving the margins. We probably want this to animate somehow. Scrolling should be fluid and seamless.

- On startup, labels start in a “minimized” state (thinking about possibly making this persistent across launches, but not sure).

- After startup, the user should be able to scroll up or down.

- Assume that there are enough views and the view heights are such that you’ll never see the views cycle in the visible area of the screen (e.g., I wouldn’t ever see view A, B, C, A, B on the screen at once.) This requirement might change.

- The view should support landscape and portrait mode.

- We might want to have an image next to each label, but haven’t decided yet. Please implement this exercise in Objective-C

- Use the control that you built to display 10 records from an RSS feed (https://itunes.apple.com/us/rss/topsongs/limit=10/xml). Feel free to use AFNetworking, or another frameworks as needed. Be as creative as you like.

## Tactics

It was tough to decide which path to go down as far as layout techniques. On one hand using frames would be easy to work with, but animating size changes when cells expand along with updating the positions of all of the following cells could pose a challenge. On the other hand, managing constraints for autolayout could prove difficult but make animating and changing orientation much easier. I decided the curve would be easier to manage if I went down the autolayout route. In the end did both tactics to prove out what would be easier to deal with and figure out the pain points.

**Autolayout**

Pros:
- Easy to manage the content view in a scrollview.
- Rotation is easily managed with constraints

Cons:
- Difficult to manipulate easy scrolling by moving cells around by updating constraints.
- Amount of code is high with code based constraints.

Remaining Issues:
- Skips when scrolling at certain points. To fix this, this would involve manipulating the position of the cells and maintaining a constraint on the content area. Perhaps another approach would be to remove autolayout on the parent and maintain a large content area?

**Frame Based**

Pros:
- Easy to manage the individual labels.
- Recycling is a bit easier.
- 1:1 relation on the content frame based movements vs the frames of the labels moving.
- Math is reusable.
- Less code and easier to read.

Cons:
- Difficult to manage animations since it means adjusting other views.
- Amount of code is high with code based constraints.

Remaining Issues:
- If a cell has been tapped an expanded, changing the orientation loses that state. A potential fix for this involves not asking for new labels and completely reloading from scratch. Instead, use the current labels with a different reload option. This would require not asking for for new labels and adjusting the layout method to change the vertical size if a cell has numberOfLines=0.

- Flickering during fast scrolls. The flickering is related to drawing speed as the cells are moved when the content area is moved. A potential fix for this would be to have three sets of cells like the autolayout version has and keep track of state when a cell is expanded.

- Orientation to landscape and back has a large gap. Potential fix is to recalibrate the content offset so it is a bit lower.

## Tests

Minor Unit Test coverage is provided to cover the models and their logic.
