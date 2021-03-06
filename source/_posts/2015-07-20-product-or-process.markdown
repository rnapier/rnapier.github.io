---
layout: post
title: "Product or Process?"
date: 2015-07-20 11:20:17 -0400
comments: true
categories: 
---

Forgive a slight divergence. I'll bring it back to software development before the end.

A friend of mine is an arborist. He takes care of a large forest, trimming and culling trees. He's quite good at it and enjoys it, but he's worried about job security. He thinks cabinet making would be a good career move. He likes to work with wood, and high-end cabinets are very expensive so there's clearly a lot of money there. I'm a hobbyist woodworker, so we were talking about it.<!-- more -->

---

Me: So, what saws are you looking at?

Him: I have a Husqvarna 3120. That should be all I need.

Me: Husqvarna? Isn't that a...chainsaw?

Him: It's the best! I use it every day. I plan to do everything with it.

Me: It's a good saw, sure, but... um... How are you going to join the pieces?

Him: Dovetail joints. I've heard those are best and you just have to cut notches. My chainsaw will make quick work of that.

Me: Dovetails have really tight tolerances. I can barely get them to work with a dovetail saw. Maybe you should start with pocket screws? They're much easier and make great joints. A chainsaw...

Him: I've worked it all out. I modded this router table to hold my chainsaw upright so that's just like a table saw. And I can make the other cuts freehand. I'm really good with a chainsaw. See, I already have a proof-of-concept.

Me: Um... that's just a board with a notch in it.

Him: Yeah, but a cabinet is just a bunch of boards with notches. I'll make some more and they should snap together.

Me: Cabinet tolerances are really tight. I mean, it's not that hard to make a box, but making a full cabinet is difficult, even with proper tools. Why would you want to use some cobbled-together thing? That table looks terrifying.

Him: Look, I know chainsaws. I'm not going to go learn a bunch of new tools just to build cabinets. Wood is wood. Saws are saws. I'm using the saw I'm comfortable with. If I use the tools I know, I'm sure I can make really great cabinets.

Me: ...

---

In unrelated news, a lot of folks have asked if I'm excited that Go 1.5 can build iOS apps.

My wife's background is art education. When you're teaching art, she tells me, it's important to remember whether you're doing process art or product art in order to judge its success. Is the end result the goal, or how you got there? Am I trying to make the most beautiful painting I can, or am I trying to make a painting using only recycled materials? Does the audience need to know the process in order to appreciate the art, or does the end result stand on its own?

A lot of great hacks are process art. Can you run VMS on Linux? [Sure you can!](http://www.wherry.com/gadgets/retrocomputing/vax-simh.html) Is that awesome? It is absolutely awesome. Is there any commercial reason to develop new VMS apps to run on Linux? Of course not. That would be ridiculous.

Is it fun to get the Go runtime working on surprising platforms? Sure, and the process may improve Go. That's why process art is so common in art education. You put unnecessary restrictions on students so that they have to develop new skills that will be useful when they work on product art. "Draw without looking at your work" is an important exercise, but not usually how you create a masterpiece.

So let's get to the "unnecessary restrictions" I'm talking about if you want to write excellent iOS apps in Go (or C# or JavaScript or....) I don't want to spend too much time on the great memory management debate. Do modern concurrent garbage collection engines work well on dual-core, 1GB iPhones? I don't know. I'm still hearing a lot of complaints about GC pauses on Lollipop with 2x the memory. It's hard to imagine that Go GC on iOS is going to be faster and more memory efficient than Java GC on Android. But let's put that question aside for the moment. Let's assume there is a large genre of apps for which Go performance and memory usage is adequate, even excellent, on iOS devices. (This might even be true.)

The real question is "what's the hard part of iOS development?"

If you think the answer is "Objective-C" then you don't understand iOS development at all. Learning Objective-C is the *easiest* part of iOS development, doubly-so for anyone who is comfortable in a wacky (and awesome) language like Go. And when it finally settles down a bit, Swift will likely be easier to learn than Objective-C for Java-esque developers.

The sort-of hard piece of iOS development is UIKit, CloudKit, HomeKit, SpriteKit, SceneKit, HealthKit, WebKit, MapKit, StoreKit, GameplayKit, and another new Kit every release. It's power management and backgrounding and handoff and watch integration and multitasking and adaptive fonts and auto layout and animations and app thinning. You can sometimes ignore those pieces, but they're what separate barely acceptable apps from great apps. If your only goal is something that kind of works, fine. Anything can do that. Web apps can do that. But if you want to make a really great app, integrating with the platform is a must. And the platform is designed for Cocoa. And Cocoa is designed for ObjC and Swift. This stuff is hard when you're using the tools Apple *intends* you to use. Working through translation layers is surgery with welding gloves.

And that brings us around to the *really* hard piece of iOS development. It changes. Constantly. Apple moves forward fast and they deprecate old APIs mercilessly. Clever work-arounds have short half-lives. You have to adapt every release, and find ways to be backward compatible while still compiling against the latest SDK. Once you've lived through a few releases of iOS, you discover how hard this piece can be even in ObjC, even when you've followed all the rules. I don't envy anyone trying to deal with it through an unsupported layer. By the time anyone knows what the next iOS version breaks, the clock is already ticking. Whoever supports your extra layer has to fix their piece, and then you have to fix your piece. And with open iOS betas, your customers are already yelling.

So I may celebrate your chainsaw router table as a glorious (and terrifying) hack. But I'll stick with my table saw for cabinets and my chainsaw for cutting up trees. A good crafter is capable with many tools, not just their favorite. And most iOS apps are about product, not process.

[Swift on Android?](http://www.elementscompiler.com/elements/silver/) I'll take Java, thanks.

Lee Whitney has [an interesting take on this subject](http://www.whitneyland.com/2015/07/xamarin-review-2015.html) from the C# side.