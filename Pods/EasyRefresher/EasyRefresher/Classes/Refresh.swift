// 
//  Refresh.swift
//  Refresher
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/26
//  Copyright © 2019 Pircate. All rights reserved.
//

import UIKit

public struct Refresh<Base> {
    
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

public protocol RefreshCompatible: class {
    
    associatedtype CompatibleType
    
    var refresh: CompatibleType { get set }
}

public extension RefreshCompatible {
    
    var refresh: Refresh<Self> {
        get { return Refresh(self) }
        set {}
    }
}

extension UIScrollView: RefreshCompatible {}

public extension Refresh where Base: UIScrollView {
    
    var header: Refresher {
        get { return base._refreshHeader }
        set { base._refreshHeader = newValue }
    }
    
    var footer: Refresher {
        get { return base._refreshFooter }
        set { base._refreshFooter = newValue }
    }
}
