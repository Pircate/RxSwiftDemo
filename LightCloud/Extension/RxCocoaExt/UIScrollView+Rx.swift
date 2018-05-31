//
//  UIScrollView+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/25.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    var isEditing: Binder<Bool> {
        return Binder(base) { tableView, isEditing in
            tableView.setEditing(isEditing, animated: true)
        }
    }
}

extension Reactive where Base: UIScrollView {
    
    var bounces: Binder<Bool> {
        return Binder(base) { scrollView, bounces in
            scrollView.bounces = bounces
        }
    }
}
