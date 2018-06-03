//
//  RxTableViewSectionedDelegate.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/3.
//

import RxSwift
import RxCocoa
import RxDataSources

extension ObservableType {
    func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, dataSource: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<E>) -> Void)
        -> Disposable
        where DelegateProxy.ParentObject: UIView
        , DelegateProxy.Delegate: AnyObject {
            let proxy = DelegateProxy.proxy(for: object)
            let unregisterDelegate = DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            object.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
//                    bindingError(error)
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
//                        bindingError(error)
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

public extension Reactive where Base: UITableView {
    
    func items<Proxy: RxTableViewDataSourceType & UITableViewDelegate & UITableViewDataSource, O: ObservableType>(proxy: Proxy)
        -> (_ source: O)
        -> Disposable
        where Proxy.Element == O.E {
            return { source in
                _ = self.delegate
                return source.subscribeProxyDataSource(ofObject: self.base, dataSource: proxy as (UITableViewDataSource & UITableViewDelegate), retainDataSource: true) { [weak tableView = self.base] (_: RxTableViewDataSourceProxy, event) -> Void in
                    guard let tableView = tableView else { return }
                    proxy.tableView(tableView, observedEvent: event)
                }
            }
    }
}

open class RxTableViewSectionedReloadProxy<S: SectionModelType>: RxTableViewSectionedReloadDataSource<S>, UITableViewDelegate {
    
    public typealias HeightForHeaderInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> CGFloat
    public typealias HeightForFooterInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> CGFloat
    public typealias ViewForHeaderInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> UIView?
    public typealias ViewForFooterInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> UIView?
    
    open var heightForHeaderInSection: HeightForHeaderInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var heightForFooterInSection: HeightForFooterInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var viewForHeaderInSection: ViewForHeaderInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var viewForFooterInSection: ViewForFooterInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public init(configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
                sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
                sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
                heightForHeaderInSection: @escaping HeightForHeaderInSection = { _, _ in 0 },
                heightForFooterInSection: @escaping HeightForFooterInSection = { _, _ in 0 },
                viewForHeaderInSection: @escaping ViewForHeaderInSection = { _, _ in nil },
                viewForFooterInSection: @escaping ViewForFooterInSection = { _, _ in nil }) {
        self.heightForHeaderInSection = heightForHeaderInSection
        self.heightForFooterInSection = heightForFooterInSection
        self.viewForHeaderInSection = viewForHeaderInSection
        self.viewForFooterInSection = viewForFooterInSection
        
        super.init(configureCell: configureCell,
                   titleForHeaderInSection: titleForHeaderInSection,
                   titleForFooterInSection: titleForFooterInSection,
                   canEditRowAtIndexPath: canEditRowAtIndexPath,
                   canMoveRowAtIndexPath: canMoveRowAtIndexPath,
                   sectionIndexTitles: sectionIndexTitles,
                   sectionForSectionIndexTitle: sectionForSectionIndexTitle)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection(self, section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection(self, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection(self, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection(self, section)
    }
    
    var _delegateBound: Bool = false
    
    private func ensureNotMutatedAfterBinding() {
        assert(!_delegateBound, "delegate is already bound. Please write this line before binding call (`bindTo`, `drive`). delegate must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
    }
}
