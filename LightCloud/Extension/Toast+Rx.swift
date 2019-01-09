//
//  Toast+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

extension Toast: ReactiveCompatible {}

extension Reactive where Base: Toast {
    
    static var state: Binder<UIState> {
        return Binder(UIApplication.shared) { _, state in
            switch state {
            case .idle:
                break
            case .loading:
                Toast.loading()
            case .success(let info):
                if let info = info {
                    Toast.show(info: info)
                } else {
                    Toast.hideActivity()
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
