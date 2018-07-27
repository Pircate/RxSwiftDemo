//
//  Collection+Rx.swift
//  RxSwiftX
//
//  Created by GorXion on 2018/7/17.
//

import RxSwift

public extension ObservableType where E: Collection {
    
    var count: Observable<Int> {
        return map { $0.count }
    }
}
