//
//  NetworkError+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxNetwork

extension Network {
    
    enum Error: Swift.Error {
        case status(code: Int, message: String)
        
        var message: String {
            switch self {
            case let .status(_, message):
                return message
            }
        }
    }
}

extension Error {
    
    var errorMessage: String {
        if let error = self as? Network.Error {
            return error.message
        }
        return "未知错误"
    }
}

extension ObservableConvertibleType {
    
    func trackNWState(_ relay: PublishRelay<UIState>,
                      loading: Bool = true,
                      success: String? = nil,
                      failure: @escaping (Error) -> String? = { $0.errorMessage }) -> Observable<E> {
        return trackState(relay, loading: loading, success: success, failure: failure)
    }
}
