//
//  Toast.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Toast_Swift

final class Toast {
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    static func show() {
        hide()
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
    
    static func hide() {
        keyWindow?.hideToastActivity()
        keyWindow?.hideAllToasts()
    }
}
