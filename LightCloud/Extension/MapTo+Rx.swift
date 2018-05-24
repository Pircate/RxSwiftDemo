//
//  MapTo+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/22.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    func map<T>(to element: T) -> Observable<T> {
        return map({ _ in element })
    }
    
    func flatMap<T>(to element: Observable<T>) -> Observable<T> {
        return flatMap({ _ in element })
    }
}

extension Driver {
    
    func map<T>(to element: T) -> SharedSequence<S, T> {
        return map({ _ in element })
    }
    
    func flatMap<T>(to element: SharedSequence<S, T>) -> SharedSequence<S, T> {
        return flatMap({ _ in element })
    }
}
