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
                sizeForItemAtIndexPath: @escaping SizeForItemAtIndexPath = { _, _, _ in CGSize.zero },
                insetForSectionAtSection: @escaping InsetForSectionAtSection = { _, _, _ in UIEdgeInsets.zero },
                minimumLineSpacingForSectionAtSection: @escaping MinimumLineSpacingForSectionAtSection = { _, _, _ in 0 },
                minimumInteritemSpacingForSectionAtSection: @escaping MinimumInteritemSpacingForSectionAtSection = { _, _, _ in 0 },
                referenceSizeForHeaderInSection: @escaping ReferenceSizeForHeaderInSection = { _, _, _ in CGSize.zero },
                referenceSizeForFooterInSection: @escaping ReferenceSizeForFooterInSection = { _, _, _ in CGSize.zero }) {
        
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
