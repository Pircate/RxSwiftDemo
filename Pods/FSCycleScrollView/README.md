# FSCycleScrollView

[![CI Status](https://img.shields.io/travis/G-Xi0N/FSCycleScrollView.svg?style=flat)](https://travis-ci.org/G-Xi0N/FSCycleScrollView)
[![Version](https://img.shields.io/cocoapods/v/FSCycleScrollView.svg?style=flat)](https://cocoapods.org/pods/FSCycleScrollView)
[![License](https://img.shields.io/cocoapods/l/FSCycleScrollView.svg?style=flat)](https://cocoapods.org/pods/FSCycleScrollView)
[![Platform](https://img.shields.io/cocoapods/p/FSCycleScrollView.svg?style=flat)](https://cocoapods.org/pods/FSCycleScrollView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FSCycleScrollView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FSCycleScrollView'
```

## Usage

``` swift
let cycleScrollView = FSCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
cycleScrollView.automaticSlidingInterval = 5            // 自动滚动间隔
cycleScrollView.hidesPageControl = false                // 是否隐藏 page control
cycleScrollView.hidesPageControlForSinglePage = false   // 只有一页的时候隐藏 page control
cycleScrollView.pageControlBottomOffset = 20            // page control 距底部距离
cycleScrollView.isInfinite = true                       // 是否无限轮播
cycleScrollView.placeholder = nil                       // 占位图片
cycleScrollView.dataSourceType = .onlyImage(images: []) // 只显示图片
cycleScrollView.dataSourceType = .onlyTitle(titles: []) // 只显示文本
cycleScrollView.dataSourceType = .both(items: [])       // 图片加文本
```

## Author

G-Xi0N, gao497868860@163.com

## License

FSCycleScrollView is available under the MIT license. See the LICENSE file for more info.
