//
//  RxNetworkExt.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/5/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxNetwork
import RxSwift
import Moya

extension Network {
    
    struct Response<T: Codable>: Codable {
        let code: Int
        let message: String
        let data: T
        
        var success: Bool {
            return code == 2000
        }
    }
}

extension Network {
    
    enum Error: LightError {
        case status(code: Int, message: String)
        
        var code: Int {
            switch self {
            case .status(let code, _):
                return code
            }
        }
        
        var message: String {
            switch self {
            case .status(_, let message):
                return message
            }
        }
        
        var errorMessage: String {
            return message
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            guard let resp = try? response.map(Network.Response<T>.self) else {
                return Single.error(MoyaError.jsonMapping(response))
            }
            if resp.success { return Single.just(resp.data) }
            return Single.error(Network.Error.status(code: resp.code, message: resp.message))
        }
    }
}

extension ObservableType where E == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Observable<T> {
        return map { response -> T in
            guard let resp = try? response.map(Network.Response<T>.self) else {
                throw MoyaError.jsonMapping(response)
            }
            if resp.success { return resp.data }
            throw Network.Error.status(code: resp.code, message: resp.message)
        }
    }
}
