//
//  UITableView+Rx.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/6/4.
//

import RxSwift
import RxCocoa

// MARK: - delegate
public extension Reactive where Base: UITableView {

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

// MARK: - binder
public extension Reactive where Base: UITableView {
    
    var isEditing: Binder<Bool> {
        return Binder(base) { tableView, isEditing in
            tableView.setEditing(isEditing, animated: true)
        }
    }
    
    func deselectRow(animated: Bool) -> Binder<IndexPath> {
        return Binder(base) { tableView, indexPath in
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
}

fileprivate extension ObservableType {
    
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

fileprivate func bindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
    #if DEBUG
    fatalError(error)
    #else
    print(error)
    #endif
}
