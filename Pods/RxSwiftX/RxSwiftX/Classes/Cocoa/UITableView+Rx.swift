//
//  UITableView+Rx.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/4.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UITableView {
    
    func items<Proxy: RxTableViewDataSourceType & UITableViewDataSource & UITableViewDelegate, O: ObservableType>(proxy: Proxy)
        -> (_ source: O)
        -> Disposable
        where Proxy.Element == O.E
    {
        return { source in
            return source.subscribeTableViewProxy(
                self.base,
                proxy: proxy as (UITableViewDataSource & UITableViewDelegate),
                retainDelegate: true,
                binding: { [weak tableView = self.base] (_, _, event) in
                    guard let tableView = tableView else { return }
                    proxy.tableView(tableView, observedEvent: event)
            })
        }
    }
    
    func sections<Delegate: RxTableViewDataSourceType & UITableViewDelegate, O: ObservableType>(delegate: Delegate)
        -> (_ source: O)
        -> Disposable
        where Delegate.Element == O.E
    {
        return { source in
            return source.subscribeTableViewDelegate(
                self.base,
                delegate: delegate as UITableViewDelegate,
                retainDelegate: true,
                binding: { [weak tableView = self.base] (_, event) in
                    guard let tableView = tableView else { return }
                    delegate.tableView(tableView, observedEvent: event)
            })
        }
    }
}

fileprivate extension ObservableType {
    
    func subscribeTableViewProxy(_ tableView: UITableView,
                                 proxy: UITableViewDataSource & UITableViewDelegate,
                                 retainDelegate: Bool,
                                 binding: @escaping (RxTableViewDataSourceProxy, RxTableViewDelegateProxy, Event<E>) -> Void)
        -> Disposable {
            let dataSourceProxy = RxTableViewDataSourceProxy.proxy(for: tableView)
            let delegateProxy = RxTableViewDelegateProxy.proxy(for: tableView)
            
            let unregisterDataSource = RxTableViewDataSourceProxy.installForwardDelegate(proxy, retainDelegate: retainDelegate, onProxyForObject: tableView)
            let unregisterDelegate = RxTableViewDelegateProxy.installForwardDelegate(proxy, retainDelegate: retainDelegate, onProxyForObject: tableView)
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            tableView.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
                    bindingError(error)
                    return Observable.empty()
                }
                // source can never end, otherwise it would release the subscriber, and deallocate the data source
                .concat(Observable.never())
                .takeUntil(tableView.rx.deallocated)
                .subscribe { [weak tableView] (event: Event<E>) in
                    
                    if let tableView = tableView {
                        assert(dataSourceProxy === RxTableViewDataSourceProxy.currentDelegate(for: tableView), "Proxy changed from the time it was first set.\nOriginal: \(dataSourceProxy)\nExisting: \(String(describing: RxTableViewDataSourceProxy.currentDelegate(for: tableView)))")
                        assert(delegateProxy === RxTableViewDelegateProxy.currentDelegate(for: tableView), "Proxy changed from the time it was first set.\nOriginal: \(delegateProxy)\nExisting: \(String(describing: RxTableViewDelegateProxy.currentDelegate(for: tableView)))")
                    }
                    
                    binding(dataSourceProxy, delegateProxy, event)
                    
                    switch event {
                    case .error(let error):
                        bindingError(error)
                        unregisterDataSource.dispose()
                        unregisterDelegate.dispose()
                    case .completed:
                        unregisterDataSource.dispose()
                        unregisterDelegate.dispose()
                    default:
                        break
                    }
            }
            
            return Disposables.create { [weak tableView] in
                subscription.dispose()
                tableView?.layoutIfNeeded()
                unregisterDataSource.dispose()
                unregisterDelegate.dispose()
            }
    }
    
    func subscribeTableViewDelegate(_ tableView: UITableView,
                                    delegate: UITableViewDelegate,
                                    retainDelegate: Bool,
                                    binding: @escaping (RxTableViewDelegateProxy, Event<E>) -> Void)
        -> Disposable {
            let proxy = RxTableViewDelegateProxy.proxy(for: tableView)
            let unregisterDelegate = RxTableViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: retainDelegate, onProxyForObject: tableView)
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            tableView.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
                    bindingError(error)
                    return Observable.empty()
                }
                // source can never end, otherwise it would release the subscriber, and deallocate the data source
                .concat(Observable.never())
                .takeUntil(tableView.rx.deallocated)
                .subscribe { [weak tableView] (event: Event<E>) in
                    
                    if let tableView = tableView {
                        assert(proxy === RxTableViewDelegateProxy.currentDelegate(for: tableView), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: RxTableViewDelegateProxy.currentDelegate(for: tableView)))")
                    }
                    
                    binding(proxy, event)
                    
                    switch event {
                    case .error(let error):
                        bindingError(error)
                        unregisterDelegate.dispose()
                    case .completed:
                        unregisterDelegate.dispose()
                    default:
                        break
                    }
            }
            
            return Disposables.create { [weak tableView] in
                subscription.dispose()
                tableView?.layoutIfNeeded()
                unregisterDelegate.dispose()
            }
    }
}

func bindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
    #if DEBUG
    fatalError(error)
    #else
    print(error)
    #endif
}
