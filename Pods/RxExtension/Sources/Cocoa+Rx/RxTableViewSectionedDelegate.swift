//
//  RxTableViewSectionedDelegate.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/3.
//

import RxSwift
import RxCocoa
import RxDataSources

open class RxTableViewSectionedDelegate<S: SectionModelType>: NSObject, UITableViewDelegate {
    
    public typealias I = S.Item
    public typealias Section = S
    
    public typealias HeightForRowAtIndexPath = (RxTableViewSectionedDelegate<S>, IndexPath, I) -> CGFloat
    public typealias HeightForHeaderInSection = (RxTableViewSectionedDelegate<S>, Int) -> CGFloat
    public typealias HeightForFooterInSection = (RxTableViewSectionedDelegate<S>, Int) -> CGFloat
    public typealias ViewForHeaderInSection = (RxTableViewSectionedDelegate<S>, Int) -> UIView?
    public typealias ViewForFooterInSection = (RxTableViewSectionedDelegate<S>, Int) -> UIView?
    
    open var heightForRowAtIndexPath: HeightForRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
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
    
    public init(heightForRowAtIndexPath: @escaping HeightForRowAtIndexPath = { _, _, _ in UITableViewAutomaticDimension },
                heightForHeaderInSection: @escaping HeightForHeaderInSection = { _, _ in UITableViewAutomaticDimension },
                heightForFooterInSection: @escaping HeightForFooterInSection = { _, _ in UITableViewAutomaticDimension },
                viewForHeaderInSection: @escaping ViewForHeaderInSection = { _, _ in nil },
                viewForFooterInSection: @escaping ViewForFooterInSection = { _, _ in nil }) {
        self.heightForRowAtIndexPath = heightForRowAtIndexPath
        self.heightForHeaderInSection = heightForHeaderInSection
        self.heightForFooterInSection = heightForFooterInSection
        self.viewForHeaderInSection = viewForHeaderInSection
        self.viewForFooterInSection = viewForFooterInSection
        
        super.init()
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAtIndexPath(self, indexPath, self[indexPath])
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
    
    // MARK: - Section Model
    public typealias SectionModelSnapshot = SectionModel<S, I>
    
    private var _sectionModels: [SectionModelSnapshot] = []
    
    open var sectionModels: [S] {
        return _sectionModels.map { Section(original: $0.model, items: $0.items) }
    }
    
    open func setSections(_ sections: [S]) {
        self._sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
    }
    
    open subscript(section: Int) -> S {
        let sectionModel = self._sectionModels[section]
        return S(original: sectionModel.model, items: sectionModel.items)
    }
    
    open subscript(indexPath: IndexPath) -> I {
        get {
            return self._sectionModels[indexPath.section].items[indexPath.item]
        }
        set(item) {
            var section = self._sectionModels[indexPath.section]
            section.items[indexPath.item] = item
            self._sectionModels[indexPath.section] = section
        }
    }
}

// MARK: - RxTableViewDataSourceType
extension RxTableViewSectionedDelegate: RxTableViewDataSourceType {
    
    public typealias Element = [S]
    
    public func tableView(_ tableView: UITableView, observedEvent: Event<[S]>) {
        Binder(self) { delegate, element in
            #if DEBUG
            self._delegateBound = true
            #endif
            delegate.setSections(element)
            tableView.reloadData()
            }.on(observedEvent)
    }
}

// MARK: - SectionedViewDataSourceType
extension RxTableViewSectionedDelegate: SectionedViewDataSourceType {
    
    public func model(at indexPath: IndexPath) throws -> Any {
        return self[indexPath]
    }
}
