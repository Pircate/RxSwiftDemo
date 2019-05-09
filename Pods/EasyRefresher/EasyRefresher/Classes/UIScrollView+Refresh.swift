// 
//  UIScrollView+Refresh.swift
//  Refresher
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/26
//  Copyright © 2019 Pircate. All rights reserved.
//

import UIKit
import ObjectiveC

public typealias Refresher = Refreshable & HasStateTitle & HasActivityIndicator & Displayable

extension UIScrollView {
    
    var _refreshHeader: Refresher {
        get {
            if let obj = objcGetAssociatedObject(for: &AssociatedKeys.header) as? Refresher {
                return obj
            }
            
            let header = RefreshHeader()
            header.scrollView = self
            
            objcSetAssociatedObject(header, for: &AssociatedKeys.header)
            
            return header
        }
        set {
            objcSetAssociatedObject(newValue, for: &AssociatedKeys.header)
            
            guard let header = newValue as? RefreshComponent else { return }
            
            header.scrollView = self
        }
    }
    
    var _refreshFooter: Refresher {
        get {
            if let obj = objcGetAssociatedObject(for: &AssociatedKeys.footer) as? Refresher {
                return obj
            }
            
            let footer = RefreshFooter()
            footer.scrollView = self
            
            objcSetAssociatedObject(footer, for: &AssociatedKeys.footer)
            
            return footer
        }
        set {
            objcSetAssociatedObject(newValue, for: &AssociatedKeys.footer)
            
            guard let footer = newValue as? RefreshComponent else { return }
            
            footer.scrollView = self
        }
    }
    
    var _refreshInset: UIEdgeInsets {
        get {
            if let obj = objcGetAssociatedObject(for: &AssociatedKeys.inset) as? UIEdgeInsets {
                return obj
            }
            
            objcSetAssociatedObject(UIEdgeInsets.zero, for: &AssociatedKeys.inset)
            
            return .zero
        }
        set {
            objcSetAssociatedObject(newValue, for: &AssociatedKeys.inset)
        }
    }
}

private extension UIScrollView {
    
    func objcGetAssociatedObject(for key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }
    
    func objcSetAssociatedObject(_ value: Any?, for key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

struct AssociatedKeys {
    
    static var header = "com.pircate.github.refresh.header"
    
    static var footer = "com.pircate.github.refresh.footer"
    
    static var inset = "com.pircate.github.refresh.inset"
}
