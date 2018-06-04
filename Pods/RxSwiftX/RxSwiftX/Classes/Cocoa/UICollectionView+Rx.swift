//
//  UICollectionView+Rx.swift
//  RxSwiftX
//
//  Created by GorXion on 2018/6/4.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UICollectionView {
    
    func items<Proxy: RxCollectionViewDataSourceType & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, O: ObservableType>(proxy: Proxy)
        -> (_ source: O)
        -> Disposable
        where Proxy.Element == O.E
    {
        return { source in
            return source.subscribeCollectionViewProxy(
                self.base,
                proxy: proxy as (UICollectionViewDataSource & UICollectionViewDelegateFlowLayout),
                retainProxy: true,
                binding: { [weak collectionView = self.base] (_, _, event) in
                    guard let collectionView = collectionView else { return }
                    proxy.collectionView(collectionView, observedEvent: event)
            })
        }
    }
}

extension ObservableType {
    
    func subscribeCollectionViewProxy(_ collectionView: UICollectionView, proxy: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, retainProxy: Bool, binding: @escaping (RxCollectionViewDataSourceProxy, RxCollectionViewDelegateProxy, Event<E>) -> Void)
        -> Disposable {
            let dataSourceProxy = RxCollectionViewDataSourceProxy.proxy(for: collectionView)
            let delegateProxy = RxCollectionViewDelegateProxy.proxy(for: collectionView)
            
            let unregisterDataSource = RxCollectionViewDataSourceProxy.installForwardDelegate(proxy, retainDelegate: retainProxy, onProxyForObject: collectionView)
            let unregisterDelegate = RxCollectionViewDelegateProxy.installForwardDelegate(proxy, retainDelegate: retainProxy, onProxyForObject: collectionView)
            
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            collectionView.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
                    bindingError(error)
                    return Observable.empty()
                }
                // source can never end, otherwise it would release the subscriber, and deallocate the data source
                .concat(Observable.never())
                .takeUntil(collectionView.rx.deallocated)
                .subscribe { [weak collectionView] (event: Event<E>) in
                    
                    if let collectionView = collectionView {
                        assert(dataSourceProxy === RxCollectionViewDataSourceProxy.currentDelegate(for: collectionView), "Proxy changed from the time it was first set.\nOriginal: \(dataSourceProxy)\nExisting: \(String(describing: RxCollectionViewDataSourceProxy.currentDelegate(for: collectionView)))")
                        assert(delegateProxy === RxCollectionViewDelegateProxy.currentDelegate(for: collectionView), "Proxy changed from the time it was first set.\nOriginal: \(delegateProxy)\nExisting: \(String(describing: RxCollectionViewDelegateProxy.currentDelegate(for: collectionView)))")
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
            
            return Disposables.create { [weak collectionView] in
                subscription.dispose()
                collectionView?.layoutIfNeeded()
                unregisterDataSource.dispose()
                unregisterDelegate.dispose()
            }
    }
}
