//
//  BannerAPI.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Moya

enum BannerAPI {
    case items(count: Int)
}

extension BannerAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://106.15.201.144:82/")!
    }
    
    var path: String {
        return "m/banner"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .items(let count):
            return .requestParameters(parameters: ["count": count], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
