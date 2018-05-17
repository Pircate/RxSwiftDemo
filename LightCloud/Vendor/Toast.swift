//
//  Toast.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Toast_Swift

private let timeoutInterval: TimeInterval = 60

final class Toast {
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    static func loading() {
        hide()
        
        let maskView = UIView(frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        keyWindow?.showToast(maskView, duration: timeoutInterval, position: .center, completion: { _ in
            Toast.hideActivity()
        })
        keyWindow?.makeToastActivity(.center)
    }
    
    static func show(info: String?, duration: TimeInterval = ToastManager.shared.duration) {
        hide()
        keyWindow?.makeToast(info, duration: duration, position: .center)
    }
    
    static func show(image: UIImage?, duration: TimeInterval = ToastManager.shared.duration) {
        hide()
        let imageView = UIImageView(image: image)
        keyWindow?.showToast(imageView, duration: duration)
    }
    
    static func show(customView: UIView, duration: TimeInterval = ToastManager.shared.duration) {
        hide()
        keyWindow?.showToast(customView, duration: duration)
    }
    
    static func hideActivity() {
        keyWindow?.hideToastActivity()
    }
    
    static func hide() {
        keyWindow?.hideAllToasts(includeActivity: true)
    }
}
