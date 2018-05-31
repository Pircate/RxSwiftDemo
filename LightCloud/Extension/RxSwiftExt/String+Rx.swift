//
//  String+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/31.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift

public extension Observable where E == String {
    
    var isEmpty: Observable<Bool> {
        return map { $0.isEmpty }
    }
}
