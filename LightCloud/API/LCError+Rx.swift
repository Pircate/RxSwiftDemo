//
//  LCError+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import LeanCloud
import RxSwift

extension Error {
    
    var errorReason: String {
        if let error = self as? LCError {
            return error.reason ?? "服务器异常"
        }
        return "未知错误"
    }
}

extension ObservableConvertibleType {
    
    func trackLCState(_ relay: PublishRelay<UIState>,
                      loading: Bool = true,
                      success: String? = nil,
                      failure: @escaping (Error) -> String? = { $0.errorReason }) -> Observable<E> {
        return trackState(relay, loading: loading, success: success, failure: failure)
    }
}
