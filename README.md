# NZ Herald #

I wanted to play around with a Medium style article/parallax view, UIPageViewController and custom UIViewController transitions, and then this happened.

![Screenshot](https://photos-5.dropbox.com/t/0/AACoQd0m-Oq9SNBe6s4AW5BW0gZQTOMGvCH5xDu7AQgFSg/12/43738758/png/2048x1536/3/1403784000/0/2/Screenshot-2014-06-26-22.26.03.png/x8rQ3gVssBNqnjL8vK-rx7Oq49uIrWnoA4HD3ezvPZc)

A subjectively more enjoyable way to browse the NZHerald on your iPhone.

## About ##

It's rough, I know, I spent a few nights hacking on this, though I thought I'd make it public as some of you may like it on your phone. I do.

### Issues ###

There are a few issues I've not got around to investigating/fixing (and probably won't), the main being that sometime the attributed string generated with NSDocumentTypeDocumentAttribute NSHTMLTextDocumentType doesn't work all the time. Oh and it crashes on the Weather tab if you swipe, so don't do that thanks.

## Setup ##

Run `pod install`

This will install the CocoaPod dependencies.
