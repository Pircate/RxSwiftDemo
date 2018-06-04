//
//  CatchError.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/4.
//

import RxSwift

public extension ObservableType {
    
    func catchErrorJustReturn(closure: @escaping @autoclosure () -> E) -> Observable<E> {
        return catchError { _ -> Observable<E> in
            return Observable.just(closure())
        }
    }
}
