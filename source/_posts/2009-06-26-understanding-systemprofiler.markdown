---
layout: post
status: publish
published: true
title: Understanding system_profiler
author: Rob Napier
author_login: rnapier
author_email: robnapier@gmail.com
author_url: http://robnapier.net
excerpt: "It thought I was going to be quiet for two weeks, now three posts in a day.
  There was a <a href=\"http://stackoverflow.com/questions/1050377/machine-id-for-mac-os/1050569#1050569\">good
  question</a> on Stack Overflow about getting system information. The actual question
  is \"what does system_profiler actually do?\"  But it's a good way to show how to
  begin to understand how any program works on the Mac. Here are some of  the most
  basic tools of the trade. This is not a deep tutorial on reverse engineering. It's
  a whirlwind tour of how you begin to attack programs using pretty standard tools.
  I'm not getting into any of the anti-obfuscation tools like Onyx the Black Cat or
  commercial tools like IDA Pro, or even code injection like SIMBL or F-ScriptAnywhere.
  When you think you're going to hide how your program works, make sure you research
  those first. You'll learn quickly how hard that really is. Maybe you should read
  my thoughts about <a href=\"http://robnapier.net/blog/obfuscating-cocoa-389\">Obfuscating
  Cocoa</a>.\r\n"
wordpress_id: 393
wordpress_url: http://robnapier.net/blog/?p=393
date: 2009-06-26 17:25:53.000000000 -04:00
categories:
- cocoa
tags: []
---
It thought I was going to be quiet for two weeks, now three posts in a day. There was a <a href="http://stackoverflow.com/questions/1050377/machine-id-for-mac-os/1050569#1050569">good question</a> on Stack Overflow about getting system information. The actual question is "what does system_profiler actually do?"  But it's a good way to show how to begin to understand how any program works on the Mac. Here are some of  the most basic tools of the trade. This is not a deep tutorial on reverse engineering. It's a whirlwind tour of how you begin to attack programs using pretty standard tools. I'm not getting into any of the anti-obfuscation tools like Onyx the Black Cat or commercial tools like IDA Pro, or even code injection like SIMBL or F-ScriptAnywhere. When you think you're going to hide how your program works, make sure you research those first. You'll learn quickly how hard that really is. Maybe you should read my thoughts about <a href="http://robnapier.net/blog/obfuscating-cocoa-389">Obfuscating Cocoa</a>.
<!-- more -->
Of course you start with the obvious, "man system_profiler". But that doesn't give as much information as we want. So let's tear apart the binary and see what's going on, shall we?

``` bash
$ otool -L /usr/sbin/system_profiler
system_profiler:
	/System/Library/PrivateFrameworks/SPSupport.framework/Versions/A/SPSupport (compatibility version 1.0.0, current version 1.0.0)
	/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation (compatibility version 300.0.0, current version 677.22.0)
	/usr/lib/libgcc_s.1.dylib (compatibility version 1.0.0, current version 1.0.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 111.1.4)
	/usr/lib/libobjc.A.dylib (compatibility version 1.0.0, current version 227.0.0)
	/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 476.17.0)
```

So we see it's using CoreFoundation and a private framework. Let's see what we can learn from that private framework.

``` bash
$ otool -L /System/Library/PrivateFrameworks/SPSupport.framework/Versions/A/SPSupport
/System/Library/PrivateFrameworks/SPSupport.framework/Versions/A/SPSupport:
	/System/Library/PrivateFrameworks/SPSupport.framework/Versions/A/SPSupport (compatibility version 1.0.0, current version 1.0.0)
	/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit (compatibility version 1.0.0, current version 275.0.0)
	/System/Library/PrivateFrameworks/DiskManagement.framework/Versions/A/DiskManagement (compatibility version 1.0.0, current version 1.0.0)
	/System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa (compatibility version 1.0.0, current version 12.0.0)
	/System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration (compatibility version 1.0.0, current version 212.2.0)
	/usr/lib/libcurl.4.dylib (compatibility version 5.0.0, current version 5.0.0)
	/usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.3)
	/usr/lib/libgcc_s.1.dylib (compatibility version 1.0.0, current version 1.0.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 111.1.4)
	/usr/lib/libobjc.A.dylib (compatibility version 1.0.0, current version 227.0.0)
	/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 476.17.0)
	/System/Library/Frameworks/AppKit.framework/Versions/C/AppKit (compatibility version 45.0.0, current version 949.45.0)
	/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation (compatibility version 300.0.0, current version 677.22.0)
```

We see it's in Cocoa. Nice, we can use <a href="http://www.codethecode.com/projects/class-dump/">class-dump</a> on it. And we see a bunch of public and private frameworks in there. We won't go into all of those here. But you can tear them apart using the same techniques we're going to use on DiskManagement:

``` objc
$ class-dump /System/Library/PrivateFrameworks/DiskManagement.framework/Versions/A/DiskManagement
...
@interface DMManager : NSObject
{
    id _instPriv;
}

+ (BOOL)systemResourcesSufficient;
+ (BOOL)systemAtMountPoint:(id)fp8 lowVersion:(int)fp12 lowInclusive:(BOOL)fp16 highVersion:(int)fp20 highInclusive:(BOOL)fp24;
+ (id)sharedManager;
+ (id)sharedManagerWithoutAuthentication;
+ (void)initialize;
- (id)initWithAuthentication:(BOOL)fp8;
- (void)dealloc;
- (id)agent;
- (void)updateGID:(int)fp8;
- (id)getPartitionStartLocationForDisk:(id)fp8;
- (id)getInfoForChildrenOfDisk:(id)fp8 sortedBy:(id)fp12;
- (void)enableVirtualDisks;
- (void)disableVirtualDisks;
- (id)diskWithIdentifier:(id)fp8;
- (id)diskWithDiskIdentifier:(id)fp8;
- (id)diskWithDeviceTreePath:(id)fp8;
- (id)diskWithUUID:(id)fp8;
- (id)diskWithUUIDInDisk:(id)fp8;
- (id)diskWithDisk:(id)fp8;
- (id)rootDisk;
...
```

Hey, that might be handy in trying to understand unique things about our system (the thing we happen to be interested in). You can continue this approach through any of the pieces that look interesting. Of course you're going to have to guess a bit about types, but you can call these methods in your code and then ask the resulting object for its -class.

We could do this all day (and you probably will, chasing down various libraries that look interesting and writing small projects to explore them), but let's take a completely different track. Let's go from static to dynamic and see what system_profiler actually <b>does</b> when it runs.

``` c
$ sudo dtruss /usr/sbin/system_profiler
...
stat("/System/Library/PrivateFrameworks/SPSupport.framework/Versions/A/SPSupport\0", 0xBFFFD3E8, 0xFFFFFFFFBFFFBCA4)		 = 0 0
open("/System/Library/PrivateFrameworks/SPSupport.framework/Versions/A/SPSupport\0", 0x0, 0x0)		 = 3 0
pread(0x3, "\312\376\272\276\0", 0x1000, 0x0)		 = 4096 0
pread(0x3, "\316\372\355\376\a\0", 0x1000, 0x1000)		 = 4096 0
mmap(0x3F000000, 0xD000, 0x5, 0x12, 0x3, 0x100000000)		 = 0x3F000000 0
...
open_nocancel("/System/Library/SystemProfiler/SPBluetoothReporter.spreporter/Contents\0", 0x100004, 0x316310)		 = 3 0
...
```

So we see all the frameworks it uses, and hey, /System/Library/SystemProfiler sure looks interesting. I wonder what we might do with that? 

``` objc
$ class-dump /System/Library/SystemProfiler/SPNetworkReporter.spreporter/Contents/MacOS/SPNetworkReporter
struct __SCDynamicStore;
...
@interface SPNetworkReporter : SPReporter
{
    struct __SCDynamicStore *_scStore;
    NSMutableDictionary *_localizedServiceNames;
}

- (id)_hardwareDictionaryForInterface:(id)fp8;
- (id)_proxyDictionaryForServiceID:(id)fp8;
- (id)_ipv4DictionaryForServiceID:(id)fp8;
- (id)_ipv6DictionaryForServiceID:(id)fp8;
- (id)_dnsDictionaryForServiceID:(id)fp8;
- (id)_appleTalkDictionaryForServiceID:(id)fp8;
- (id)_ethernetDictionaryForServiceID:(id)fp8 interfaceID:(id)fp12;
- (id)_dhcpDictionaryForServiceID:(id)fp8;
- (id)_dictionaryForServiceID:(id)fp8;
- (id)updateDictionary:(id)fp8;
- (void)dealloc;

@end
```

OK, but what does this one really do? Maybe if if we had a nice way to disassemble it.... Like maybe <a href="http://otx.osxninja.com/">otx</a>.

``` c-objdump
$ otx /System/Library/SystemProfiler/SPNetworkReporter.spreporter/Contents/MacOS/SPNetworkReporter
...
-(id)[SPNetworkReporter _hardwareDictionaryForInterface:]
    +0  00000f0e  55             pushl    %ebp
    +1  00000f0f  89e5           movl     %esp,%ebp
    +3  00000f11  57             pushl    %edi
    +4  00000f12  56             pushl    %esi
    +5  00000f13  53             pushl    %ebx
    +6  00000f14  e800000000     calll    0x00000f19
   +11  00000f19  5b             popl     %ebx
   +12  00000f1a  83ec5c         subl     $0x5c,%esp
   +15  00000f1d  8b83e7300000   movl     0x000030e7(%ebx),%eax
   +21  00000f23  89442404       movl     %eax,0x04(%esp)
   +25  00000f27  8b8377310000   movl     0x00003177(%ebx),%eax
   +31  00000f2d  890424         movl     %eax,(%esp)
   +34  00000f30  e8c3410000     calll    0x000050f8               +[NSMutableDictionary dictionary]
   +39  00000f35  89c7           movl     %eax,%edi
   +41  00000f37  8b4510         movl     0x10(%ebp),%eax
   +44  00000f3a  85c0           testl    %eax,%eax
   +46  00000f3c  0f8486020000   jel      0x000011c8
   +52  00000f42  8d45e4         leal     0xe4(%ebp),%eax
   +55  00000f45  89442404       movl     %eax,0x04(%esp)
   +59  00000f49  8b8313410000   movl     0x00004113(%ebx),%eax
   +65  00000f4f  8b00           movl     (%eax),%eax
   +67  00000f51  890424         movl     %eax,(%esp)
   +70  00000f54  e84a410000     calll    0x000050a3               _IOMasterPort
...
```

Digging through we'll see a lot of stuff starting "IO." Just a little googling will teach us that means IOKit. So maybe that's going to be a good place to study in understanding this better.

This is just the start, and the goal is to get people thinking in the right way and get some basic tools in their hands. These aren't black-hat tools. These are the basic tools of the trade. Any experienced Mac developer should know enough to tear apart Apple's code to figure out how they're doing what they do. That let's us write better Mac apps, even if we avoid using the private interfaces.
