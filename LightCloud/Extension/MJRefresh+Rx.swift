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

public enum RefreshState {
    case none
    case isHeaderRefreshing
    case endHeaderRefresh
    case isFooterRefreshing
    case endFooterRefresh
}

extension Reactive where Base: MJRefreshHeader {
    
    public var beginRefreshing: Binder<Void> {
        return Binder(base) { header, _ in
            header.beginRefreshing()
        }
    }
    
    public var refreshClosure: ControlEvent<Void> {
        return ControlEvent(events: Observable.create({ [weak base] (observer) -> Disposable in
            base?.refreshingBlock = {
                observer.onNext(())
            }
            return Disposables.create()
        }))
    }
}

extension Reactive where Base: MJRefreshFooter {
    
    public var beginRefreshing: Binder<Void> {
        return Binder(base) { footer, _ in
            footer.beginRefreshing()
        }
    }
    
    public var refreshClosure: ControlEvent<Void> {
        return ControlEvent(events: Observable.create({ [weak base] (observer) -> Disposable in
            base?.refreshingBlock = {
                observer.onNext(())
            }
            return Disposables.create()
        }))
    }
}

extension Reactive where Base: UIScrollView {
    
    public var endRefreshing: Binder<RefreshState> {
        return Binder(base) { (scrollView, status) in
            switch status {
            case .endHeaderRefresh:
                scrollView.endHeaderRefreshing()
            case .endFooterRefresh:
                scrollView.endFooterRefreshing()
            default:
                break
            }
        }
    }
}

extension UIScrollView {
    
    func endHeaderRefreshing() {
        guard let mj_header = mj_header else { return }
        if mj_header.isRefreshing {
            mj_header.endRefreshing()
        }
    }
    
    func endFooterRefreshing() {
        guard let mj_footer = mj_footer else { return }
        if mj_footer.isRefreshing {
            mj_footer.endRefreshing()
        }
    }
}
