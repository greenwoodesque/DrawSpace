# DrawSpace
Simple drawing app

Draw colorful pictures. Save, review, delete, or replay your drawings.

Drawings are collections of strokes, each of which in turn is a collection of points. The Stroke type also includes color, width, and timing information, used in replaying the drawing just as it was composed. The Drawing type includes an aspect ratio to eventually accomodate users viewing thumbnail images of drawings composed on different devices. 

Drawings and stroke data are JSON-encoded and persisted locally. To facilitate scrolling performance on the main view, drawings are also saved as PNGs. I had hoped to replace all this with a Cloud Firestore implementation. As it stands, the Persistance class is easily swapped out. 

Some divergences and shortcomings: 

I ran out of time before adding a UI component for selecting stroke width. The functionality to save and draw at different widths is however there for when the UI catches up.

One serious blight on the user experience I didn't have time to address is that when making the first stroke in a drawing, it disconcertingly remains invisible until the user lifts their finger. All subsequent strokes appear as they're drawn. 

Error handling is perfunctory and debug-oriented now. In some error cases the user will be alerted. Others just print to console. 

In the replay feature, I elected to ignore the time interval between strokes, on the grounds that a long period of artistic contemplation between one stroke and the next might not be as fun to experience in the third person. I went with a standard delay of about half a second between all strokes. The time a given stroke took to create, however, is accurately preserved. 

I cringe to admit that I haven't tested on device or simulated on anything smaller than an iPhone 8. I've noticed too late that I need to update xcode, make room for it on my drive... Apologies. 



