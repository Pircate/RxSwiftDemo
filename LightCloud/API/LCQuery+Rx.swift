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
    
    static func query(_ className: String, keyword: String, page: Int = -1) -> Observable<[LCObject]> {
        return Observable.create { (observer) -> Disposable in
            guard !keyword.isEmpty else {
                observer.onNext([])
                return Disposables.create()
            }
            let query = LCQuery(className: className)
            query.whereKey("name", .matchedSubstring(keyword))
            if page >= 0 {
                query.whereKey("page", .equalTo(page))
            }
            query.find({ (result) in
                switch result {
                case .success(let objects):
                    observer.onNext(objects)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
