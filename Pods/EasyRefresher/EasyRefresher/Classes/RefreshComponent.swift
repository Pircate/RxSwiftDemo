// 
//  RefreshComponent.swift
//  EasyRefresher
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/5/8
//  Copyright © 2019 Pircate. All rights reserved.
//

open class RefreshComponent: UIView, Refresher {
    
    public var activityIndicatorStyle: UIActivityIndicatorView.Style = .gray {
        didSet { activityIndicator.style = activityIndicatorStyle }
    }
    
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
            
            rotate(for: state)
            
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
            scrollView?.alwaysBounceVertical = true
        }
    }
    
    var idleInset: UIEdgeInsets = .zero
    
    var arrowDirection: ArrowDirection { return .down }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [activityIndicator, arrowImageView, stateLabel])
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let image = UIImage(named: "refresh_arrow_down", in: Bundle.current, compatibleWith: nil)
        return UIImageView(image: image)
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: activityIndicatorStyle)
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
    
    public func beginRefreshing() {
        willChangeInset()
        state = .refreshing
        didChangeInset()
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
    
    private func startRefreshing() {
        activityIndicator.startAnimating()
    }
    
    private func stopRefreshing() {
        activityIndicator.stopAnimating()
        
        resetInset()
    }
    
    private func willChangeInset() {
        guard let scrollView = scrollView else { return }
        
        var contentInset = scrollView.contentInset
        contentInset.top -= scrollView._refreshInset.top
        contentInset.bottom -= scrollView._refreshInset.bottom
        
        idleInset = contentInset
    }
    
    private func resetInset() {
        UIView.animate(withDuration: 0.25) {
            self.scrollView?.contentInset = self.idleInset
            self.scrollView?._refreshInset = self.idleInset
        }
    }
    
    private func rotate(for state: RefreshState) {
        arrowImageView.isHidden = state == .idle || state == .refreshing
        
        let transform: CGAffineTransform
        switch arrowDirection {
        case .up:
            transform = state == .willRefresh ? .identity : CGAffineTransform(rotationAngle: .pi)
        case .down:
            transform = state == .willRefresh ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        
        UIView.animate(withDuration: 0.25) { self.arrowImageView.transform = transform }
    }
}

extension RefreshComponent {
    
    enum ArrowDirection {
        case up
        case down
    }
}

private extension Bundle {
    
    static var current: Bundle? {
        guard let resourcePath = Bundle(for: RefreshComponent.self).resourcePath,
            let bundle = Bundle(path: "\(resourcePath)/EasyRefresher.bundle") else {
                return nil
        }
        return bundle
    }
}
