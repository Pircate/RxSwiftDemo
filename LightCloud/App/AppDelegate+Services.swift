//
//  AppDelegate+Services.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import IQKeyboardManagerSwift
import Toast_Swift
import LeanCloud

private let appID = "V2KQKo4Hp6Fz9LdspYqImLJB-gzGzoHsz"
private let clientKey = "RE7GFObDm0vWSWtWd8DU4qHI"

extension AppDelegate {
    
    func registerServices(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        LeanCloud.initialize(applicationID: appID, applicationKey: clientKey)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        ToastManager.shared.style.activitySize = CGSize(width: 88, height: 88)
    }
}
