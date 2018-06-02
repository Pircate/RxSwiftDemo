//
//  UITextField+Rx.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/1.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UITextField {
    
    public var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        return RxTextFieldDelegateProxy.proxy(for: base)
    }
    
    var shouldChangeCharacters: (Observable<String>) -> (@escaping RxTextFieldDelegateProxy.ShouldChangeCharacters) -> Disposable {
        let proxy = RxTextFieldDelegateProxy.proxy(for: base)
        return { source in
            return { shouldChangeCharacters in
                return source.bind(onNext: { _ in
                    proxy.shouldChangeCharacters = shouldChangeCharacters
                })
            }
        }
    }
    
    var shouldClear: ControlEvent<UITextField> {
        let source = RxTextFieldDelegateProxy.proxy(for: base).shouldClearPublishSubject
        return ControlEvent(events: source)
    }
    
    var shouldReturn: ControlEvent<UITextField> {
        let source = RxTextFieldDelegateProxy.proxy(for: base).shouldReturnPublishSubject
        return ControlEvent(events: source)
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
