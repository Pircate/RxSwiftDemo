//
//  MJRefresh+Rx.swift
//  ChengTayTong
//
//  Created by GorXion on 2018/3/12.
//  Copyright © 2018年 adinnet. All rights reserved.
//

import RxSwift
import RxCocoa
import MJRefresh

public extension Reactive where Base: MJRefreshHeader {
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { header, _ in
            header.beginRefreshing()
        }
    }
    
    var refreshClosure: ControlEvent<Void> {
        return ControlEvent(events: Observable.create({ [weak base] (observer) -> Disposable in
            base?.refreshingBlock = {
                observer.onNext(())
            }
            return Disposables.create()
        }))
    }
    
    var endRefreshing: Binder<Void> {
        return Binder(base) { header, _ in
            header.endRefreshing()
        }
    }
}

public extension Reactive where Base: MJRefreshFooter {
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { footer, _ in
            footer.beginRefreshing()
        }
    }
    
    var refreshClosure: ControlEvent<Void> {
        return ControlEvent(events: Observable.create({ [weak base] (observer) -> Disposable in
            base?.refreshingBlock = {
                observer.onNext(())
            }
            return Disposables.create()
        }))
    }
    
    var endRefreshing: Binder<Void> {
        return Binder(base) { footer, _ in
            footer.endRefreshing()
        }
    }
}
