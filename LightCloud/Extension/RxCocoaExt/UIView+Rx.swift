//
//  UIView+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/25.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    
    var endEditing: Binder<Bool> {
        return Binder(base) { view, force in
            view.endEditing(force)
        }
    }
}
