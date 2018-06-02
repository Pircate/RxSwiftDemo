//
//  TextFieldDelegate.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/2.
//

public final class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    public typealias ShouldChangeCharacters = (UITextField, NSRange, String) -> Bool
    
    public var shouldChangeCharacters: ShouldChangeCharacters = { _, _, _ in true }
    
    public init(_ textField: UITextField?) {
        super.init()
        textField?.delegate = self
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return shouldChangeCharacters(textField, range, string)
    }
}
