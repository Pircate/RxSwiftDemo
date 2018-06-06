//
//  ShareOnce+Rx.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/5/26.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift

public extension ObservableType {
    
    func shareOnce() -> Observable<E> {
        return share(replay: 1)
    }
}
