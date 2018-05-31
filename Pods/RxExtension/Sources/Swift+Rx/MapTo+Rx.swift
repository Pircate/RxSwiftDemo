//
//  MapTo+Rx.swift
//  RxExtension
//
//  Created by Pircate on 2018/5/22.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    
    func map<T>(to element: T) -> Observable<T> {
        return map { _ in element }
    }
    
    func flatMap<T>(to element: Observable<T>) -> Observable<T> {
        return flatMap { _ in element }
    }
}

public extension Driver {
    
    func map<T>(to element: T) -> SharedSequence<S, T> {
        return map { _ in element }
    }
    
    func flatMap<T>(to element: SharedSequence<S, T>) -> SharedSequence<S, T> {
        return flatMap { _ in element }
    }
}
