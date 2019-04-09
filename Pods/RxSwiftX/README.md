# RxSwiftX

[![CI Status](https://img.shields.io/travis/Pircate/RxSwiftX.svg?style=flat)](https://travis-ci.org/Pircate/RxSwiftX)
[![Version](https://img.shields.io/cocoapods/v/RxSwiftX.svg?style=flat)](https://cocoapods.org/pods/RxSwiftX)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxSwiftX.svg?style=flat)](https://cocoapods.org/pods/RxSwiftX)
![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg) 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 9.0+
* Swift 4.2

## Installation

RxSwiftX is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxSwiftX'
```

### Optional

```ruby
pod 'RxSwiftX/DataSources'
pod 'RxSwiftX/MJRefresh'
```

### Usage

#### DataSources
```swift

private lazy var proxy: RxTableViewSectionedReloadProxy<TodoSectionModel> = {
    RxTableViewSectionedReloadProxy<TodoSectionModel>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! TodoItemCell
        cell.bindViewModel(item)
        return cell
    }, canEditRowAtIndexPath: { _, _ in
        return true
    }, canMoveRowAtIndexPath: { _, _ in
        return true
    }, heightForRowAtIndexPath: { _, _, item in
        return 60
    }, heightForHeaderInSection: { _, _ -> CGFloat in
        return 50
    }, viewForHeaderInSection: { _, _, _  -> UIView? in
        return UILabel().chain.text("云推荐").textAlignment(.center).build
    })
}()

// Bind to proxy not dataSource
items.drive(tableView.rx.items(proxy: proxy)).disposed(by: disposeBag)

```

### Demo

https://github.com/Pircate/RxSwiftDemo

## Author

Pircate, gao497868860@163.com

## License

RxSwiftX is available under the MIT license. See the LICENSE file for more info.
