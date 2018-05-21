//
//  LCQuery+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

extension Reactive where Base: LCQuery {
    
    static func queryForID(_ className: String, start: Int, offset: Int) -> Observable<[LCObject]> {
        return Observable.create { (observer) -> Disposable in
            let query = LCQuery(className: className)
            query.whereKey("id", .greaterThanOrEqualTo(start))
            query.whereKey("id", .lessThan(start + offset))
            query.find({ (result) in
                switch result {
                case .success(let objects):
                    observer.onNext(objects)
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
