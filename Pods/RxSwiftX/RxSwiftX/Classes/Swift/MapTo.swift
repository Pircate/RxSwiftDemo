//
//  MapTo+Rx.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/5/22.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    
    func map<T>(to transform: @escaping @autoclosure () -> T) -> Observable<T> {
        return map { _ in transform() }
    }
    
    func flatMap<T>(to transform: @escaping @autoclosure () -> Observable<T>) -> Observable<T> {
        return flatMap { _ in transform() }
    }
}

public extension Driver {
    
    func map<T>(to transform: @escaping @autoclosure () -> T) -> SharedSequence<S, T> {
        return map { _ in transform() }
    }
    
    func flatMap<T>(to transform: @escaping @autoclosure () -> SharedSequence<S, T>) -> SharedSequence<S, T> {
        return flatMap { _ in transform() }
    }
}
