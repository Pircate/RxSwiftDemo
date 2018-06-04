//
//  UIScrollView+Rx.swift
//  RxExtension
//
//  Created by Pircate on 2018/5/25.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UITableView {
    
    var isEditing: Binder<Bool> {
        return Binder(base) { tableView, isEditing in
            tableView.setEditing(isEditing, animated: true)
        }
    }
}

public extension Reactive where Base: UIScrollView {
    
    var bounces: Binder<Bool> {
        return Binder(base) { scrollView, bounces in
            scrollView.bounces = bounces
        }
    }
}
