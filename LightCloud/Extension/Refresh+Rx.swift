//
//  Refresh+Rx.swift
//  Refresh
//
//  Created by Pircate on 2018/3/12.
//  Copyright © 2018年 pircate. All rights reserved.
//

import RxSwift
import RxCocoa
import CRRefresh

extension Reactive where Base: CRRefreshComponent {
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { component, _ in
            component.beginRefreshing()
        }
    }
    
    var refreshHandler: ControlEvent<Void> {
        return ControlEvent(events: Observable.create({ [weak base] (observer) -> Disposable in
            base?.handler = {
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
