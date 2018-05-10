//
//  AppDelegate+Root.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

extension AppDelegate {
    
    func setupRootViewController() {
        UIViewController.setupNavigationBar
        window = UIWindow(frame: UIScreen.main.bounds).chain.backgroundColor(UIColor.white).installed
        let nav = UINavigationController(rootViewController: LoginViewController())
        nav.navigation.configuration.isEnabled = true
        nav.navigation.configuration.isTranslucent = true
        nav.navigation.configuration.barTintColor = UIColor(hex: "#4381E8")
        nav.navigationBar.barStyle = .black
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
