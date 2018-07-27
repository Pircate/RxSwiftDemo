//
//  RxCollectionViewSectionedReloadProxy.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/6/4.
//

import RxSwift
import RxCocoa
import RxDataSources

open class RxCollectionViewSectionedReloadProxy<S: SectionModelType>: RxCollectionViewSectionedReloadDataSource<S>, UICollectionViewDelegateFlowLayout {
    
    public typealias SizeForItemAtIndexPath = (RxCollectionViewSectionedReloadProxy<S>, UICollectionViewLayout, IndexPath) -> CGSize
    public typealias InsetForSectionAtSection = (RxCollectionViewSectionedReloadProxy<S>, UICollectionViewLayout, Int) -> UIEdgeInsets
    public typealias MinimumLineSpacingForSectionAtSection = (RxCollectionViewSectionedReloadProxy<S>, UICollectionViewLayout, Int) -> CGFloat
    public typealias MinimumInteritemSpacingForSectionAtSection = (RxCollectionViewSectionedReloadProxy<S>, UICollectionViewLayout, Int) -> CGFloat
    public typealias ReferenceSizeForHeaderInSection = (RxCollectionViewSectionedReloadProxy<S>, UICollectionViewLayout, Int) -> CGSize
    public typealias ReferenceSizeForFooterInSection = (RxCollectionViewSectionedReloadProxy<S>, UICollectionViewLayout, Int) -> CGSize
    
    open var sizeForItemAtIndexPath: SizeForItemAtIndexPath         
    open var insetForSectionAtSection: InsetForSectionAtSection
    open var minimumLineSpacingForSectionAtSection: MinimumLineSpacingForSectionAtSection
    open var minimumInteritemSpacingForSectionAtSection: MinimumInteritemSpacingForSectionAtSection
    open var referenceSizeForHeaderInSection: ReferenceSizeForHeaderInSection
    open var referenceSizeForFooterInSection: ReferenceSizeForFooterInSection
    
    public init(configureCell: @escaping ConfigureCell,
                configureSupplementaryView: ConfigureSupplementaryView? = nil,
                moveItem: @escaping MoveItem = { _, _, _ in () },
                canMoveItemAtIndexPath: @escaping CanMoveItemAtIndexPath = { _, _ in false },
                sizeForItemAtIndexPath: @escaping SizeForItemAtIndexPath = { _, layout, _ in RxCollectionViewSectionedReloadProxy.itemSize(for: layout)  },
                insetForSectionAtSection: @escaping InsetForSectionAtSection = { _, layout, _ in RxCollectionViewSectionedReloadProxy.sectionInset(for: layout) },
                minimumLineSpacingForSectionAtSection: @escaping MinimumLineSpacingForSectionAtSection = { _, layout, _ in RxCollectionViewSectionedReloadProxy.minimumLineSpacing(for: layout) },
                minimumInteritemSpacingForSectionAtSection: @escaping MinimumInteritemSpacingForSectionAtSection = { _, layout, _ in RxCollectionViewSectionedReloadProxy.minimumInteritemSpacing(for: layout) },
                referenceSizeForHeaderInSection: @escaping ReferenceSizeForHeaderInSection = { _, layout, _ in RxCollectionViewSectionedReloadProxy.headerReferenceSize(for: layout) },
                referenceSizeForFooterInSection: @escaping ReferenceSizeForFooterInSection = { _, layout, _ in RxCollectionViewSectionedReloadProxy.footerReferenceSize(for: layout) }) {
        
        self.sizeForItemAtIndexPath = sizeForItemAtIndexPath
        self.insetForSectionAtSection = insetForSectionAtSection
        self.minimumLineSpacingForSectionAtSection = minimumLineSpacingForSectionAtSection
        self.minimumInteritemSpacingForSectionAtSection = minimumInteritemSpacingForSectionAtSection
        self.referenceSizeForHeaderInSection = referenceSizeForHeaderInSection
        self.referenceSizeForFooterInSection = referenceSizeForFooterInSection
        
        super.init(configureCell: configureCell,
                   configureSupplementaryView: configureSupplementaryView,
                   moveItem: moveItem,
                   canMoveItemAtIndexPath: canMoveItemAtIndexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAtIndexPath(self, collectionViewLayout, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSectionAtSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSectionAtSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacingForSectionAtSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSizeForHeaderInSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSizeForFooterInSection(self, collectionViewLayout, section)
    }
}

public extension RxCollectionViewSectionedReloadProxy {
    
    static func itemSize(for layout: UICollectionViewLayout) -> CGSize {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGSize.zero }
        return flowLayout.itemSize
    }
    
    static func sectionInset(for layout: UICollectionViewLayout) -> UIEdgeInsets {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return UIEdgeInsets.zero }
        return flowLayout.sectionInset
    }
    
    static func minimumLineSpacing(for layout: UICollectionViewLayout) -> CGFloat {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGFloat.leastNormalMagnitude }
        return flowLayout.minimumLineSpacing
    }
    
    static func minimumInteritemSpacing(for layout: UICollectionViewLayout) -> CGFloat {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGFloat.leastNormalMagnitude }
        return flowLayout.minimumInteritemSpacing
    }
    
    static func headerReferenceSize(for layout: UICollectionViewLayout) -> CGSize {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGSize.zero }
        return flowLayout.headerReferenceSize
    }
    
    static func footerReferenceSize(for layout: UICollectionViewLayout) -> CGSize {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGSize.zero }
        return flowLayout.footerReferenceSize
    }
}
