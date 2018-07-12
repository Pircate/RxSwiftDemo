//
//  LCObject+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/23.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

extension Reactive where Base: LCObject {
    
    func save() -> Observable<Bool> {
        return Observable.create({ [weak base] (observer) -> Disposable in
            base?.save({ (result) in
                switch result {
                case .success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        })
    }
    
    func delete() -> Observable<Bool> {
        return Observable.create({ [weak base] (observer) -> Disposable in
            base?.delete({ (result) in
                switch result {
                case .success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        })
    }
}
