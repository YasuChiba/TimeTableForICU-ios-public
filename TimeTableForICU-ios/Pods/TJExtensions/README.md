# TJExtensions

Useful extensions for UIKit framework.

- TJColorExtensions
- TJViewExtensions
- TJLabelExtensions

[![Version](https://img.shields.io/cocoapods/v/TJExtensions.svg?style=flat)](http://cocoapods.org/pods/TJExtensions)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)
[![License](https://img.shields.io/cocoapods/l/TJExtensions.svg?style=flat)](http://cocoapods.org/pods/TJExtensions)
[![Platform](https://img.shields.io/cocoapods/p/TJExtensions.svg?style=flat)](http://cocoapods.org/pods/TJExtensions)
![Swift version](https://img.shields.io/badge/swift-3.0-orange.svg)

## Installation

### CocoaPods

TJExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TJExtensions"
```

### Carthage

```
github "taji-taji/TJExtensions"
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### TJColorExtensions

#### Initializers

- `convenience init(hex: Int, alpha: CGFloat)`
- `convenience init(intRed: Int, green: Int, blue: Int, alpha: CGFloat)`

#### Examples

```swift
let redColor = UIColor.init(hex: 0xFF0000, alpha: 1.0)
let greenColor = UIColor(intRed: 0, green: 255, blue: 0, alpha: 1.0)
```

### TJViewExtensins

#### Methods

- `func border(borderWidth borderWidth: CGFloat, borderColor: UIColor?, borderRadius: CGFloat?)`
- `func border(positions: [BorderPosition], borderWidth: CGFloat, borderColor: UIColor?)`

#### Inspectable Variables

- `var borderWidth: CGFloat`
- `var borderColor: UIColor?`
- `var cornerRadius: CGFloat`

![TJViewExtensions1](https://raw.githubusercontent.com/wiki/taji-taji/TJExtension/images/TJViewExtensions1.png)

#### Examples

```swift
let borderedView = UIView(frame: CGRectMake(0.0, 0.0, 200, 50))
borderedView.border([.Top, .Right], borderWidth: 3.5, borderColor: borderColor)
```


### TJLabelExtensions

#### Inspectable Variables

- `var underline: Bool`

![TJLabelExtensions1](https://raw.githubusercontent.com/wiki/taji-taji/TJExtension/images/TJLableExtensions1.png)


## Author

Yutaka Tajika

## License

TJExtensions is available under the MIT license. See the LICENSE file for more info.
