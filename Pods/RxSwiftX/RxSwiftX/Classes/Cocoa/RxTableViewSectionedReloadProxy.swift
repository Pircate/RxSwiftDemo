//
//  RxTableViewSectionedReloadProxy.swift
//  Alamofire
//
//  Created by GorXion on 2018/6/4.
//

import RxSwift
import RxCocoa
import RxDataSources

open class RxTableViewSectionedReloadProxy<S: SectionModelType>: RxTableViewSectionedReloadDataSource<S>, UITableViewDelegate {
    
    public typealias HeightForRowAtIndexPath = (RxTableViewSectionedReloadProxy<S>, IndexPath, I) -> CGFloat
    public typealias HeightForHeaderInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> CGFloat
    public typealias HeightForFooterInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> CGFloat
    public typealias ViewForHeaderInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> UIView?
    public typealias ViewForFooterInSection = (RxTableViewSectionedReloadProxy<S>, Int) -> UIView?
    
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
                heightForRowAtIndexPath: @escaping HeightForRowAtIndexPath = { _, _, _ in UITableViewAutomaticDimension },
                heightForHeaderInSection: @escaping HeightForHeaderInSection = { _, _ in UITableViewAutomaticDimension },
                heightForFooterInSection: @escaping HeightForFooterInSection = { _, _ in UITableViewAutomaticDimension },
                viewForHeaderInSection: @escaping ViewForHeaderInSection = { _, _ in nil },
                viewForFooterInSection: @escaping ViewForFooterInSection = { _, _ in nil }) {
        
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
}
