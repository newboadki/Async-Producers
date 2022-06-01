# Async Producers

##  Overview

This project is a sample app to practice with Swift Concurrency actors having to serialize the high-frequency access of multiple producers (Async Sequences) into a shared resource container.

## Technical description 
Several producers are trying to add pixels (position and color) into a 2D grid.
- These producers conform to _AsyncSequence. 
- There's an image serializer, an _actor_, that synchronizes access to the 2D image since all producers are concurrent.
Coordinating everything is the _PaintingProcess_ class, which creates an async cancellable execution context. Inside, there's a task group with all producers as subtasks.

## Updating the UI
- Whenever the presenter's array of colors changes, only the appropriate views will be re-computed. However, this is not enough to prevent a poor refresh performance. See the next point.
- Since the producers are yielding values frequently, their corresponding updates to the UI will keep the main thread too busy, affecting the scrolling performance. The solution is to throttle these updates to a rate that allows the main thread to still take on other events from the RunLoop, like scrolling events.

## Presentation Type Erasers
- In order to provide preview-specific presenters, there's a _GridViewPresenter_ that all presenters would conform to, but it has associated types because it inherits from ObservableObject. The solution I went for was to create an _AnyGridViewPresenter_ type eraser. 

## Additional features
- iOS 15 material blurred backgrounds.
- Support for Light and Dark modes.
- Dependency injection using Resolver.

<img src="https://user-images.githubusercontent.com/199423/171458355-cbf59bad-1f9e-42af-b7f5-3eeb23948f22.gif" width="50%">

