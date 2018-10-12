//
//  Response+LightCloud.swift
//  LightCloud
//
//  Created by GorXion on 2018/7/12.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Moya
import RxNetwork
import CleanJSON

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Single<T> {
        return map { try $0.mapObject(type) }
    }
}

extension ObservableType where E == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Observable<T> {
        return map { try $0.mapObject(type) }
    }
}

public extension Response {
    
    func mapObject<T: Codable>(_ type: T.Type) throws -> T {
        let response = try map(Network.Response<T>.self, using: CleanJSONDecoder())
        if response.success { return response.data }
        throw Network.Error.status(code: response.code, message: response.message)
    }
}
