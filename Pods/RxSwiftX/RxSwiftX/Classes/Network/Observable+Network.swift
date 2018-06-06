//
//  Observable+Network.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

extension ObservableType where E: TargetType {
    
    public func request<T: Codable>(_ type: T.Type,
                                    atKeyPath keyPath: String? = nil,
                                    using decoder: JSONDecoder = .init()) -> Observable<T> {
        return flatMap { target -> Observable<T> in
            let source = target.request().map(type, atKeyPath: keyPath, using: decoder).storeCachedObject(for: target).asObservable()
            if let object = target.cachedObject(type) {
                return source.startWith(object)
            }
            return source
        }
    }
}
