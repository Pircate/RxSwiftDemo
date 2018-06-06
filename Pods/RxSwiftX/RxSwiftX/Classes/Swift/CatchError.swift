//
//  CatchError.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/6/4.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    
    func catchErrorJustReturn(closure: @escaping @autoclosure () -> E) -> Observable<E> {
        return catchError { _ in
            return Observable.just(closure())
        }
    }
}

public extension ObservableConvertibleType {
    
    func asDriver(onErrorJustReturnClosure: @escaping @autoclosure () -> E) -> Driver<E> {
        return asDriver { _ in
            Driver.just(onErrorJustReturnClosure())
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            Driver.empty()
        }
    }
}
