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
import RxNetwork
import Moya

private let appID = "JwwkO6PWDcn5gz3f83swpkOy-gzGzoHsz"
private let clientKey = "tSmrT1lKWnPwcLTXBDeL0N8A"

extension AppDelegate {
    
    func registerServices(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        LeanCloud.initialize(applicationID: appID, applicationKey: clientKey)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        ToastManager.shared.style.activitySize = CGSize(width: 88, height: 88)
        
        Network.default.timeoutInterval = 20
    }
}
