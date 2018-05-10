//
//  AppDelegate+Services.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import IQKeyboardManagerSwift

private let appID = "V2KQKo4Hp6Fz9LdspYqImLJB-gzGzoHsz"
private let clientKey = "RE7GFObDm0vWSWtWd8DU4qHI"

extension AppDelegate {
    
    func registerServices(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        AVOSCloud.setApplicationId(appID, clientKey: clientKey)
//        AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        AVOSCloud.setAllLogsEnabled(false)
        AVOSCloud.setLogLevel(AVLogLevel(0))
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
