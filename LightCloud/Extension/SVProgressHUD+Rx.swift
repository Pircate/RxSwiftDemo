//
//  SVProgressHUD+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

enum NetworkState {
    case idle
    case loading(String?)
    case success(String?)
    case failure(String?)
}

extension Reactive where Base: UIView {
    var loading: Binder<NetworkState> {
        return Binder(base) { _, state in
            switch state {
            case .idle:
                break
            case .loading(let status):
                SVProgressHUD.show(withStatus: status)
            case .success(let status):
                SVProgressHUD.showSuccess(withStatus: status)
            case .failure(let status):
                SVProgressHUD.showError(withStatus: status)
            }
        }
    }
}

struct LoadingToken<E> : ObservableConvertibleType, Disposable {
    
    private let _source: Observable<E>
    
    init(source: Observable<E>) {
        _source = source
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
    
    func dispose() {}
}

extension ObservableConvertibleType {
    func loading(_ status: String? = nil) -> Observable<E> {
        return Observable.using({ () -> LoadingToken<E> in
            SVProgressHUD.show(withStatus: status)
            return LoadingToken(source: self.asObservable())
        }, observableFactory: {
            $0.asObservable()
        })
    }
}
