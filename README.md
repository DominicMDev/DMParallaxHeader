# DMParallaxHeader

[![Version](https://img.shields.io/cocoapods/v/DMParallaxHeader.svg?style=flat)](http://cocoapods.org/pods/DMParallaxHeader)
![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/DMParallaxHeader.svg?style=flat)](http://cocoapods.org/pods/DMParallaxHeader)
[![License](https://img.shields.io/cocoapods/l/DMParallaxHeader.svg?style=flat)](http://cocoapods.org/pods/DMParallaxHeader)

DMParallaxHeader is a Swift conversion from https://github.com/maxep/MXParallaxHeader.

## Usage

If you want to try it, simply run:

```
pod try DMParallaxHeader
```

+ Adding a parallax header to a UIScrollView is straightforward, e.g:

```swift
let headerView = UIImageView(frame: imageFrame)
headerView.image = UIImage(named:"success-baby")
headerView.contentMode = .scaleAspectFill
   
let scrollView = UIScrollView(frame: frame) 
scrollView.parallaxHeader.view = headerView
scrollView.parallaxHeader.height = 150
scrollView.parallaxHeader.mode = .fill
scrollView.parallaxHeader.minimumHeight = 20
```

+ The DMScrollViewController is a container with a child view controller that can be added programmatically or using the custom segue DMScrollViewControllerSegue.

+ Please check examples for **Swift** implementations.

## Installation

MXParallaxHeader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DMParallaxHeader'
```

## License

DMParallaxHeader is available under the MIT license. See the LICENSE file for more info.
