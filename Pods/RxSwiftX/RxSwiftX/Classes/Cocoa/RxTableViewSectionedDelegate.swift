//
//  RxTableViewSectionedDelegate.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/3.
//

import RxSwift
import RxCocoa

open class RxTableViewSectionedDelegate<Section>: NSObject, UITableViewDelegate {
    
    public typealias HeightForHeaderInSection = (RxTableViewSectionedDelegate<Section>, Int) -> CGFloat
    public typealias HeightForFooterInSection = (RxTableViewSectionedDelegate<Section>, Int) -> CGFloat
    public typealias ViewForHeaderInSection = (RxTableViewSectionedDelegate<Section>, Int) -> UIView?
    public typealias ViewForFooterInSection = (RxTableViewSectionedDelegate<Section>, Int) -> UIView?
    
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
    
    public init(heightForHeaderInSection: @escaping HeightForHeaderInSection = { _, _ in UITableViewAutomaticDimension },
                heightForFooterInSection: @escaping HeightForFooterInSection = { _, _ in UITableViewAutomaticDimension },
                viewForHeaderInSection: @escaping ViewForHeaderInSection = { _, _ in nil },
                viewForFooterInSection: @escaping ViewForFooterInSection = { _, _ in nil }) {
        self.heightForHeaderInSection = heightForHeaderInSection
        self.heightForFooterInSection = heightForFooterInSection
        self.viewForHeaderInSection = viewForHeaderInSection
        self.viewForFooterInSection = viewForFooterInSection
        
        super.init()
    }
    
    // MARK: - UITableViewDelegate
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
    
    // MARK: - Section Model
    private var _sections: [Section] = []
    
    open var sections: [Section] {
        return _sections
    }
    
    open func setSections(_ sections: [Section]) {
        _sections = sections
    }
    
    open subscript(section: Int) -> Section {
        return _sections[section]
    }
}

// MARK: - RxTableViewDataSourceType
extension RxTableViewSectionedDelegate: RxTableViewDataSourceType {
    
    public typealias Element = [Section]
    
    public func tableView(_ tableView: UITableView, observedEvent: Event<[Section]>) {
        Binder(self) { delegate, element in
            #if DEBUG
            self._delegateBound = true
            #endif
            delegate.setSections(element)
            tableView.reloadData()
            }.on(observedEvent)
    }
}
