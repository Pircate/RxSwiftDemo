//
//  CatchError+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/18.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    func catchErrorJustToast() -> Observable<E> {
        return catchError({
            Toast.show(info: $0.reason)
            return Observable.empty()
        })
    }
}
