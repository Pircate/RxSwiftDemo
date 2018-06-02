//
//  UITextField+Rx.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/1.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UITextField {
    
    var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        return RxTextFieldDelegateProxy.proxy(for: base)
    }
    
    var shouldChangeCharacters: RxTextFieldDelegateProxy.ShouldChangeCharacters {
        get {
            return RxTextFieldDelegateProxy.proxy(for: base).shouldChangeCharacters
        }
        set {
            RxTextFieldDelegateProxy.proxy(for: base).shouldChangeCharacters = newValue
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
}

public extension UITextField {
    
    var maxLength: Int {
        get {
            return 0
        }
        set {
            RxTextFieldDelegateProxy.proxy(for: self).shouldChangeCharacters = { (textField, range, string) -> Bool in
                if string.isEmpty { return true }
                guard let text = textField.text else { return true }
                let length = text.count + string.count - range.length
                return length <= newValue
            }
        }
    }
}
