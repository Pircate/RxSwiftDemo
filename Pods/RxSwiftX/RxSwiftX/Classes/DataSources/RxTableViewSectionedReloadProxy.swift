//
//  RxTableViewSectionedReloadProxy.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/6/4.
//

import RxSwift
import RxCocoa
import RxDataSources

open class RxTableViewSectionedReloadProxy<S: SectionModelType>: RxTableViewSectionedReloadDataSource<S>, UITableViewDelegate {
    
    public typealias HeightForRowAtIndexPath = (RxTableViewSectionedReloadProxy<S>, UITableView, IndexPath, I) -> CGFloat
    public typealias HeightForHeaderInSection = (RxTableViewSectionedReloadProxy<S>, UITableView, Int) -> CGFloat
    public typealias HeightForFooterInSection = (RxTableViewSectionedReloadProxy<S>, UITableView, Int) -> CGFloat
    public typealias ViewForHeaderInSection = (RxTableViewSectionedReloadProxy<S>, UITableView, Int) -> UIView?
    public typealias ViewForFooterInSection = (RxTableViewSectionedReloadProxy<S>, UITableView, Int) -> UIView?
    
    open var heightForRowAtIndexPath: HeightForRowAtIndexPath
    open var heightForHeaderInSection: HeightForHeaderInSection
    open var heightForFooterInSection: HeightForFooterInSection
    open var viewForHeaderInSection: ViewForHeaderInSection
    open var viewForFooterInSection: ViewForFooterInSection
    
    public init(configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
                sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
                sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
                heightForRowAtIndexPath: @escaping HeightForRowAtIndexPath = { _, tableView, _, _ in tableView.rowHeight },
                heightForHeaderInSection: @escaping HeightForHeaderInSection = { _, tableView, _  in tableView.sectionHeaderHeight },
                heightForFooterInSection: @escaping HeightForFooterInSection = { _, tableView, _  in tableView.sectionFooterHeight },
                viewForHeaderInSection: @escaping ViewForHeaderInSection = { _, _, _ in nil },
                viewForFooterInSection: @escaping ViewForFooterInSection = { _, _, _ in nil }) {
        
        self.heightForRowAtIndexPath = heightForRowAtIndexPath
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
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAtIndexPath(self, tableView, indexPath, self[indexPath])
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection(self, tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection(self, tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection(self, tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection(self, tableView, section)
    }
}
