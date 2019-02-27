# Final Project

The final project is an enhancement of Virtual Tourist using the concept of Persistence and Core Data in Udacity iOS Nanodegree. 

The app is designed to download and show photos from Flicker.com. It lets the user tours in the map and as soon as they drop pins, the user will be able to downlaod pictures of the location the pin on. Users can also move pins to download new pictures and remove pins if they no longer need it. 


## Implementation

There are two View Controllers that are the interface:

**TouristVC** It showes the map around the world and the user has full control of pins, they can drop them anywhere and as soon as they dropped, photos will be downloaded from Flicker for that sepcific place. Downlaoding pictures occurs in AlbumVC.

**AlbumVC** It let's the user downlaods pictures and edit an album. New collection can be adjusted however the user like. 

CoreData is used to store pins and photos. 

## Requirements

 Xcode 10.1
 Swift 4.2
 
 ## License

Copyright (c) 2019 Mesheal Sulami 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
