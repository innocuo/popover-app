# popover-app

This is an app that does nothing except adding an icon to MacOS's menu bar. When you click on it, it shows a popover. 
If you right click on the icon, it shows a menu. It's intended as sample code for whoever needs it.

I originally used this code for [Inojournal](https://github.com/innocuo/ino-journal), but I'm in the process of 
removing it from that app, as most people say this sort of click behavior is not intuitive, and therefore Apple
doesn't recommend it. In theory, left or right clicking on a menu bar icon should show the same thing. 

Even so, some developers still want such a behavior in their apps, but achieving it needs some work arounds. I think
I solved them with this code (stuff like hilighting the icon when the menu appears, close the popup when you click on 
another icon, hide the popup when you press ESC, etc.)

That's it.

