//
//  Countdown+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/18.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift

extension Int {
    
    func countdown(_ resend: String = "重新发送") -> Observable<(title: String, isEnabled: Bool)> {
        return Observable.of(self).flatMap({ (until) -> Observable<(title: String, isEnabled: Bool)> in
            Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance).map({
                if until > $0 {
                    return ("\(until - $0)s", false)
                }
                throw NSError()
            }).catchErrorJustReturn((resend, true))
        })
    }
}
