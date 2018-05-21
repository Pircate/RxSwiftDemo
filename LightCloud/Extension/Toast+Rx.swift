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
}

extension ObservableType {
    
    func hideToast() -> Observable<E> {
        return map({
            Toast.hide()
            return $0
        })
    }
}
