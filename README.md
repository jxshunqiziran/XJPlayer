

[![Build Status](https://img.shields.io/github/release/jxshunqiziran/XJPlayer.svg)](https://img.shields.io/github/release/jxshunqiziran/XJPlayer.svg)
![vv](http://progressed.io/bar/28)
![vvv](https://img.shields.io/badge/XJ-Play-yellowgreen.svg)
![vvvdd](https://img.shields.io/github/license/mashape/apistatus.svg)
![vvvvvvdd](https://img.shields.io/badge/buding-oc-blue.svg)

This library provides an video player,only need a video url to play,it can fullScreen,seekto time,play and pause.

## Features

- [x] Play a video with a URL
- [x] Custom a special Show Play control view


## Supported Image Formats

- MP4

## Requirements

- iOS 7.0 or later
- tvOS 9.0 or later
- watchOS 2.0 or later
- Xcode 7.3 or later


## Getting Started

- Read this Readme doc


## How To Use

* Objective-C

```objective-c
#import <XJPlayerView.h>
...
player = [[XJPlayView alloc]initWithURl:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" controlView:nil frame:CGRectMake(0, 0, SCREENWIDTH, 200)];
player.backgroundColor = [UIColor redColor];
[self.view addSubview:player];
```



## Installation

There are three ways to use XJPlayer in your project:
- using CocoaPods

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

#### Podfile
```
platform :ios, '7.0'
pod 'XJPlayer', '~> 1.0.1'
```

If you are using Swift, be sure to add `use_frameworks!` and set your target to iOS 8+:
```
platform :ios, '8.0'
use_frameworks!
```



### Import headers in your source files

In the source files where you need to use the library, import the header file:

```objective-c
#import <XJPlayer/XJPlayerView>
```

### Build Project

At this point your workspace should build without error. If you are having problem, post to the Issue and the
community can help you solve it.

## Author
- [顺其自然](http://jxshunqiziran.com/)


## Licenses

All source code is licensed under the [MIT License](https://github.com/jxshunqiziran/XJPlayer/blob/master/LICENSE).
