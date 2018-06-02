//
//  RxTextFieldDelegateProxy.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/3.
//

import RxSwift
import RxCocoa

extension UITextField: HasDelegate {
    
    public typealias Delegate = UITextFieldDelegate
}

open class RxTextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {
    
    public weak private(set) var textField: UITextField?
    
    init(textField: ParentObject) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxTextFieldDelegateProxy(textField: $0) }
    }
    
    fileprivate var _shouldClearPublishSubject: PublishSubject<UITextField>?
    fileprivate var _shouldReturnPublishSubject: PublishSubject<UITextField>?
    
    internal var shouldClearPublishSubject: PublishSubject<UITextField> {
        if let subject = _shouldClearPublishSubject {
            return subject
        }
        
        let subject = PublishSubject<UITextField>()
        _shouldClearPublishSubject = subject
        
        return subject
    }
    
    internal var shouldReturnPublishSubject: PublishSubject<UITextField> {
        if let subject = _shouldReturnPublishSubject {
            return subject
        }
        
        let subject = PublishSubject<UITextField>()
        _shouldReturnPublishSubject = subject
        
        return subject
    }
    
    public typealias ShouldChangeCharacters = (UITextField, NSRange, String) -> Bool
    
    public var shouldChangeCharacters: ShouldChangeCharacters = { _, _, _ in true }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return shouldChangeCharacters(textField, range, string)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        shouldClearPublishSubject.onNext(textField)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturnPublishSubject.onNext(textField)
        return true
    }
}
