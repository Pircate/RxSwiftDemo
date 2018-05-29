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
    
    var state: Binder<UIState> {
        return Binder(base) { view, state in
            switch state {
            case .idle:
                break
            case .loading:
                Toast.loading()
            case .success(let info):
                if let info = info {
                    Toast.show(info: info)
                } else {
                    Toast.hide()
                }
            case .failure(let info):
                if let info = info {
                    Toast.show(info: info)
                } else {
                    Toast.hide()
                }
            }
        }
    }
}
