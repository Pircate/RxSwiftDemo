//
//  Refresh+Rx.swift
//  Refresh
//
//  Created by Pircate on 2018/3/12.
//  Copyright © 2018年 pircate. All rights reserved.
//

import RxSwift
import RxCocoa
import MJRefresh

public extension Reactive where Base: MJRefreshComponent {
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { component, _ in
            component.beginRefreshing()
        }
    }
    
    var refreshing: ControlEvent<Void> {
        return ControlEvent(events: Observable.create({ [weak base] (observer) -> Disposable in
            base?.refreshingBlock = {
                observer.onNext(())
            }
            return Disposables.create()
        }))
    }
    
    var endRefreshing: Binder<Void> {
        return Binder(base) { component, _ in
            component.endRefreshing()
        }
    }
}
