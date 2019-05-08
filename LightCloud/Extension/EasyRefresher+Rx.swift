// 
//  EasyRefresher+Rx.swift
//  LightCloud
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/5/8
//  Copyright © 2019 gaoX. All rights reserved.
//

import RxSwift
import EasyRefresher

extension Reactive where Base: RefreshComponent {
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { component, _ in
            component.beginRefreshing()
        }
    }
    
    var refreshing: ControlEvent<Void> {
        return ControlEvent(events: Observable.create({ [weak base] (observer) -> Disposable in
            base?.refreshClosure = {
                observer.onNext(())
            }
            return Disposables.create {
                observer.onCompleted()
            }
        }))
    }
    
    var endRefreshing: Binder<Void> {
        return Binder(base) { component, _ in
            component.endRefreshing()
        }
    }
}
