//  SnapKit+UIViewController.swift
//  Created on 2018/8/30
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author gaoxiang(gaoxiang@huami.com)

import SnapKit

public struct ConstraintViewControllerDSL {
    
    fileprivate let base: UIViewController
    
    init(_ base: UIViewController) {
        self.base = base
    }
}

extension UIViewController {
    
    public var snp: ConstraintViewControllerDSL {
        return ConstraintViewControllerDSL(self)
    }
}

public extension ConstraintViewControllerDSL {
    
    var topLayoutGuide: ConstraintItem {
        if #available(iOS 11.0, *) {
            return base.view.safeAreaLayoutGuide.snp.top
        } else {
            return base.topLayoutGuide.snp.bottom
        }
    }
    
    var bottomLayoutGuide: ConstraintItem {
        if #available(iOS 11.0, *) {
            return base.view.safeAreaLayoutGuide.snp.bottom
        } else {
            return base.bottomLayoutGuide.snp.top
        }
    }
}
