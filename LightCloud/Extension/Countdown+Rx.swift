//
//  Countdown+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/18.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift

extension Observable where Element == Int {
    
    func countdown(_ retry: String = "重新发送") -> Observable<String> {
        return flatMap({ (until) -> Observable<String> in
            Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance).map({ index -> String in
                if until > index {
                    return "\(until - index)s"
                }
                throw NSError()
            }).catchErrorJustReturn(retry)
        })
    }
}
