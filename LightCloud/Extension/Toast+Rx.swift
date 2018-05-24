//
//  Toast+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

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
    
    func loading() -> Observable<E> {
        return Observable.using({ () -> LoadingToken<E> in
            Toast.loading()
            return LoadingToken(source: self.asObservable())
        }, observableFactory: {
            $0.asObservable()
        })
    }
    
    func catchErrorJustToast() -> Observable<E> {
        return asObservable().catchError({
            Toast.show(info: $0.reason)
            return Observable.empty()
        })
    }
    
    func catchErrorJustToast(return element: E) -> Observable<E> {
        return asObservable().catchError({
            Toast.show(info: $0.reason)
            return Observable.just(element)
        })
    }
    
    func hideToastOnSuccess() -> Observable<E> {
        return asObservable().do(onNext: { _ in
            Toast.hide()
        })
    }
    
    func showToast(onSuccess info: String) -> Observable<E> {
        return asObservable().do(onNext: { _ in
            Toast.show(info: info)
        })
    }
}
