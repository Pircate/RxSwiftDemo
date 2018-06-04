//
//  CatchError.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/4.
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
        return asDriver(onErrorRecover: { _ in
            return Driver.just(onErrorJustReturnClosure())
        })
    }
}
