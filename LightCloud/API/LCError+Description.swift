//
//  LCError+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import LeanCloud
import RxSwift

extension LCError {
    
    public var localizedDescription: String {
        return reason ?? "服务器异常"
    }
}
