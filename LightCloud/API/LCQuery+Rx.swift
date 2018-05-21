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

extension Error {
    
    var reason: String? {
        if let error = self as? LCError {
            return error.reason
        }
        return "未知错误"
    }
}

extension Reactive where Base: LCQuery {
    
    static func query(_ className: String, keyword: String, start: Int = 0) -> Observable<[LCObject]> {
        return Observable.create { (observer) -> Disposable in
            let query = LCQuery(className: className)
            query.whereKey("name", .matchedSubstring(keyword))
            let query1 = LCQuery(className: className)
            query1.whereKey("id", .greaterThanOrEqualTo(start))
            let query2 = LCQuery(className: className)
            query2.whereKey("id", .lessThan(start + 10))
            query.and(query1).and(query2).find({ (result) in
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
