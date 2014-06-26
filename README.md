# NZ Herald #

I wanted to play around with a Medium style article/parallax view, UIPageViewController and custom UIViewController transitions, and then this happened.

![Screenshot](http://i.imgur.com/azdLnXt.png)

A subjectively more enjoyable way to browse the NZHerald on your iPhone.

## About ##

It's rough, I know, I spent a few nights hacking on this, though I thought I'd make it public as some of you may like it on your phone. I do.

### Issues ###

There are a few issues I've not got around to investigating/fixing (and probably won't), the main being that sometime the attributed string generated with NSDocumentTypeDocumentAttribute NSHTMLTextDocumentType doesn't work all the time. Oh and it crashes on the Weather tab if you swipe, so don't do that thanks.

## Setup ##

Run `pod install`

This will install the CocoaPod dependencies.
