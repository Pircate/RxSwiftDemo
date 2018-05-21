//
//  CatchError+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/18.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import LeanCloud

extension ObservableType {
    
    func catchErrorJustShowForAVUser() -> Observable<E> {
        return catchError({
            Toast.show(info: $0.statusMessage)
            return Observable.empty()
        })
    }
    
    func catchErrorJustShowForLCQuery() -> Observable<E> {
        return catchError({
            if let error = $0 as? LCError {
                Toast.show(info: error.reason)
            }
            return Observable.empty()
        })
    }
}
