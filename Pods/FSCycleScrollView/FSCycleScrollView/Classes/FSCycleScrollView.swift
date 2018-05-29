//
//  FSCycleScrollView.swift
//  FSPagerView
//
//  Created by GorXion on 2018/5/7.
//

import UIKit
import FSPagerView
import Kingfisher

public enum FSCycleScrollViewDataSourceType {
    case onlyImage(images: [String])
    case onlyTitle(titles: [String])
    case both(items: [(image: String, title: String)])
}

open class FSCycleScrollView: UIView {
    
    open var dataSourceType: FSCycleScrollViewDataSourceType = .onlyImage(images: []) {
        didSet {
            switch dataSourceType {
            case .onlyImage(let images):
                pageControl.numberOfPages = images.count
            case .onlyTitle(let titles):
                pageControl.numberOfPages = titles.count
            case .both(let items):
                pageControl.numberOfPages = items.count
            }
            pagerView.reloadData()
        }
    }
    
    open var placeholder: UIImage?
    
    open var scrollDirection: FSPagerViewScrollDirection = .horizontal {
        didSet {
            pagerView.scrollDirection = scrollDirection
        }
    }
    
    open var automaticSlidingInterval: CGFloat = 0.0 {
        didSet {
            pagerView.automaticSlidingInterval = automaticSlidingInterval
        }
    }
    
    open var isInfinite: Bool = false {
        didSet {
            pagerView.isInfinite = isInfinite
        }
    }
    
    open var isTracking: Bool {
        return pagerView.isTracking
    }
    
    open var removesInfiniteLoopForSingleItem: Bool = false {
        didSet {
            pagerView.removesInfiniteLoopForSingleItem = removesInfiniteLoopForSingleItem
        }
    }
    
    open var imageViewContentMode: UIViewContentMode = .scaleToFill
    
    open var selectItemAtIndex: (Int) -> Void = { _ in }
    
    /// Text label style
    open var textLabelTextColor: UIColor = UIColor.white
    
    open var textLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    open var textLabelBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)

    private lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: bounds)
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        pagerView.itemSize = bounds.size
        return pagerView
    }()
    
    public lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20))
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pagerView)
        addSubview(pageControl)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        pagerView.frame = bounds
        pagerView.itemSize = bounds.size
        pageControl.frame = CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20)
    }
}

extension FSCycleScrollView: FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        switch dataSourceType {
        case .onlyImage(let images):
            return images.count
        case .onlyTitle(let titles):
            return titles.count
        case .both(let items):
            return items.count
        }
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        switch dataSourceType {
        case .onlyImage(let images):
            cell.imageView?.contentMode = imageViewContentMode
            if let url = URL(string: images[index]) {
                cell.imageView?.kf.setImage(with: url, placeholder: placeholder)
            }
        case .onlyTitle(let titles):
            cell.textLabel?.text = titles[index]
            configureTitleLabelStyle(cell.textLabel)
        case .both(let items):
            cell.imageView?.contentMode = imageViewContentMode
            if let url = URL(string: items[index].image) {
                cell.imageView?.kf.setImage(with: url, placeholder: placeholder)
            }
            cell.textLabel?.text = items[index].title
            configureTitleLabelStyle(cell.textLabel)
        }
        return cell
    }
    
    private func configureTitleLabelStyle(_ textLabel: UILabel?) {
        textLabel?.textColor = textLabelTextColor
        textLabel?.font = textLabelFont
        textLabel?.backgroundColor = textLabelBackgroundColor
    }
}

extension FSCycleScrollView: FSPagerViewDelegate {
    
    public func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    public func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        selectItemAtIndex(index)
    }
}
