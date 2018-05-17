//
//  AsObservable.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift

protocol AsObservable {
    
    func asObservable() -> Observable<Self>
}

extension AsObservable {
    
    func asObservable() -> Observable<Self> {
        return Observable.of(self)
    }
}

extension Bool: AsObservable {}

extension Int: AsObservable {}

extension UInt: AsObservable {}

extension String: AsObservable {}

extension Double: AsObservable {}

extension CGFloat: AsObservable {}

extension Float: AsObservable {}

extension Date: AsObservable {}

extension Data: AsObservable {}

extension Array: AsObservable {}

extension Dictionary: AsObservable {}

extension Set: AsObservable {}
