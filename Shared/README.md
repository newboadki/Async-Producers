#  Overview

There are a number of producers trying to add pixels (position and color) into a 2D grid.
- These producers conform to AsyncSequence. 
- There's an image serializer, an actor that synchronizes access to the 2D image, since all producers are concurrent.
- Coordinating everything is the PaintingProcess class, which creates an async cancellable execution context, inside of which there's a task group with all producers as subtasks.


