//
//  LCError+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import LeanCloud
import RxSwift

protocol LightError: Error {
    
    var errorMessage: String { get }
}

extension Error {
    
    var errorMessage: String {
        if let error = self as? LightError {
            return error.errorMessage
        }
        return "未知错误"
    }
}

extension LCError: LightError {
    
    var errorMessage: String {
        return reason ?? "服务器异常"
    }
}
