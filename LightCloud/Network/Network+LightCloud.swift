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
            return code == 200
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
