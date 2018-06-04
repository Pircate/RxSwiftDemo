//
//  UITableView+Rx.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/4.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UITableView {
    
    func items<Delegate: RxTableViewDataSourceType & UITableViewDelegate, O: ObservableType>(delegate: Delegate)
        -> (_ source: O)
        -> Disposable
        where Delegate.Element == O.E {
            return { source in
                _ = self.delegate
                return source.subscribeProxyDelegate(ofObject: self.base, delegate: delegate as UITableViewDelegate, retainDataSource: true) { [weak tableView = self.base] (_: RxTableViewDelegateProxy, event) -> Void in
                    guard let tableView = tableView else { return }
                    delegate.tableView(tableView, observedEvent: event)
                }
            }
    }
}

extension ObservableType {
    
    func subscribeProxyDelegate<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject,
                                                                  delegate: DelegateProxy.Delegate,
                                                                  retainDataSource: Bool,
                                                                  binding: @escaping (DelegateProxy, Event<E>) -> Void)
        -> Disposable
        where DelegateProxy.ParentObject: UIView
        , DelegateProxy.Delegate: AnyObject {
            let proxy = DelegateProxy.proxy(for: object)
            let unregisterDelegate = DelegateProxy.installForwardDelegate(delegate, retainDelegate: retainDataSource, onProxyForObject: object)
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            object.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
                    // bindingError(error)
                    return Observable.empty()
                }
                // source can never end, otherwise it would release the subscriber, and deallocate the data source
                .concat(Observable.never())
                .takeUntil(object.rx.deallocated)
                .subscribe { [weak object] (event: Event<E>) in
                    
                    if let object = object {
                        assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
                    }
                    
                    binding(proxy, event)
                    
                    switch event {
                    case .error(let error):
                        // bindingError(error)
                        print(error)
                        unregisterDelegate.dispose()
                    case .completed:
                        unregisterDelegate.dispose()
                    default:
                        break
                    }
            }
            
            return Disposables.create { [weak object] in
                subscription.dispose()
                object?.layoutIfNeeded()
                unregisterDelegate.dispose()
            }
    }
}
