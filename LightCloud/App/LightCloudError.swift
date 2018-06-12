//
//  LightCloudError.swift
//  LightCloud
//
//  Created by GorXion on 2018/6/12.
//  Copyright © 2018年 gaoX. All rights reserved.
//

protocol LightCloudError: Error {
    
    var errorMessage: String { get }
}

extension Error {
    
    var errorMessage: String {
        if let error = self as? LightCloudError {
            return error.errorMessage
        }
        return "未知错误"
    }
}
