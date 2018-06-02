//
//  UITextField+Rx.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/1.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UITextField {
    
    var shouldChangeCharacters: (Observable<String>) -> (@escaping TextFieldDelegate.ShouldChangeCharacters) -> Disposable {
        return { [weak base] source in
            return { shouldChangeCharacters in
                let delegate = TextFieldDelegate(base)
                return source.bind(onNext: { _ in
                    delegate.shouldChangeCharacters = shouldChangeCharacters
                })
            }
        }
    }
    
    var shouldReturn: ControlEvent<UITextField> {
        let delegate = TextFieldDelegate(base)
        return ControlEvent(events: Observable.create({ (observer) -> Disposable in
            delegate.shouldReturn = { textField in
                observer.onNext(textField)
                return true
            }
            return Disposables.create()
        }))
    }
    
    var shouldClear: ControlEvent<UITextField> {
        let delegate = TextFieldDelegate(base)
        return ControlEvent(events: Observable.create({ (observer) -> Disposable in
            delegate.shouldClear = { textField in
                observer.onNext(textField)
                return true
            }
            return Disposables.create()
        }))
    }
    
    func limit(_ maxLength: Int) -> Disposable {
        return base.rx.text.orEmpty.asDriver().drive(base.rx.shouldChangeCharacters) { (textField, range, string) -> Bool in
            if string.isEmpty { return true }
            guard let text = textField.text else { return true }
            let length = text.count + string.count - range.length
            return length <= maxLength
        }
    }
}
