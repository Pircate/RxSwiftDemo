//
//  ShareOnce+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/26.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    func shareOnce() -> Observable<E> {
        return share(replay: 1)
    }
}
