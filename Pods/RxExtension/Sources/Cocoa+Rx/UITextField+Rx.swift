//
//  UITextField+Rx.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/1.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UITextField {
    
    func prefix(_ maxLength: Int) -> Binder<String> {
        return Binder(base) { textField, text in
            textField.text = String(text.prefix(maxLength))
        }
    }
}
