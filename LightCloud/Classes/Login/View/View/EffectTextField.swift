//
//  EffectTextField.swift
//  ChengTayTong
//
//  Created by GorXion on 2018/2/11.
//  Copyright © 2018年 adinnet. All rights reserved.
//

import UIKit
import CocoaChainKit

extension Chain where Base: EffectTextField {
    
    @discardableResult
    func inactiveColor(_ inactiveColor: UIColor) -> Chain {
        base.inactiveColor = inactiveColor
        return self
    }
    
    @discardableResult
    func activeColor(_ activeColor: UIColor) -> Chain {
        base.activeColor = activeColor
        return self
    }
}

class EffectTextField: UITextField {
    
    public var inactiveColor: UIColor = UIColor.gray {
        didSet {
            borderLayer.backgroundColor = inactiveColor.cgColor
        }
    }
    
    public var activeColor: UIColor = UIColor.red {
        didSet {
            activeBorderLayer.backgroundColor = activeColor.cgColor
        }
    }

    private lazy var borderLayer: CALayer = {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.gray.cgColor
        return borderLayer
    }()
    
    private lazy var activeBorderLayer: CALayer = {
        let activeBorderLayer = CALayer()
        activeBorderLayer.backgroundColor = UIColor.red.cgColor
        return activeBorderLayer
    }()
    
    private var isActive = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(borderLayer)
        layer.addSublayer(activeBorderLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0.5)
        activeBorderLayer.frame = CGRect(x: 0, y: bounds.height, width: isActive ? bounds.width : 0, height: 1)
    }
    
    override func becomeFirstResponder() -> Bool {
        if !isActive {
            isActive = true
            layoutIfNeeded()
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        if isActive {
            isActive = false
            layoutIfNeeded()
        }
        return super.resignFirstResponder()
    }
}
