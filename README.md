# InfiniteScroll
A control to infinitely scroll vertically up and down.

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

## Tests

Minor Unit Test coverage is provided to cover the models and their logic.
