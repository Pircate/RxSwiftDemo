//
//  UIResponder+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/25.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIResponder {
    
    var becomeFirstResponder: Binder<Void> {
        return Binder(base) { responder, _ in
            responder.becomeFirstResponder()
        }
    }
    
    var resignFirstResponder: Binder<Void> {
        return Binder(base) { responder, _ in
            responder.resignFirstResponder()
        }
    }
}
