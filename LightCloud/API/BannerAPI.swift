//
//  BannerAPI.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Moya

enum BannerAPI {
    case items
}

extension BannerAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://news-at.zhihu.com/api")!
    }
    
    var path: String {
        return "4/news/latest"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .items:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
