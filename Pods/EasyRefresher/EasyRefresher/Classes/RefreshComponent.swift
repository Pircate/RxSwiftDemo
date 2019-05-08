// 
//  RefreshComponent.swift
//  EasyRefresher
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/5/8
//  Copyright © 2019 Pircate. All rights reserved.
//

open class RefreshComponent: UIView, Refreshable, HasStateTitle {
    
    public var stateTitles: [RefreshState : String] = [:]
    
    public var stateAttributedTitles: [RefreshState : NSAttributedString] = [:]
    
    public var state: RefreshState = .idle {
        didSet {
            guard state != oldValue else { return }
            
            switch state {
            case .idle:
                stopRefreshing()
            case .refreshing:
                refreshClosure()
                
                startRefreshing()
            default:
                break
            }
            
            if let attributedTitle = attributedTitle(for: state) {
                stateLabel.attributedText = attributedTitle
            } else {
                stateLabel.text = title(for: state)
            }
            
            stateLabel.sizeToFit()
        }
    }
    
    public var refreshClosure: () -> Void = {}
    
    weak var scrollView: UIScrollView? {
        didSet {
            guard let scrollView = scrollView else { return }
            
            scrollView.alwaysBounceVertical = true
            idleInset = scrollView.contentInset
        }
    }
    
    var idleInset: UIEdgeInsets = .zero
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [indicatorView, stateLabel])
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .gray)
    }()
    
    private lazy var stateLabel: UILabel = {
        let stateLabel = UILabel()
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        stateLabel.textAlignment = .center
        return stateLabel
    }()
    
    public required init(refreshClosure: @escaping () -> Void) {
        self.refreshClosure = refreshClosure
        
        super.init(frame: CGRect.zero)
        
        build()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        build()
    }
    
    func startRefreshing() {
        indicatorView.startAnimating()
        
        didChangeInset()
    }
    
    func stopRefreshing() {
        indicatorView.stopAnimating()
        
        resetInset()
    }
    
    func willChangeInset() {
        guard let scrollView = scrollView else { return }
        
        var contentInset = scrollView.contentInset
        contentInset.top -= scrollView.offsetInset.top
        contentInset.bottom -= scrollView.offsetInset.bottom
        
        idleInset = contentInset
    }
    
    func didChangeInset() {}
}

extension RefreshComponent {
    
    private func build() {
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func resetInset() {
        UIView.animate(withDuration: 0.25) {
            self.scrollView?.contentInset = self.idleInset
            self.scrollView?.offsetInset = self.idleInset
        }
    }
}
