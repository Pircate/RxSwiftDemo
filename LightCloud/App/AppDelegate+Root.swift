//
//  AppDelegate+Root.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

extension AppDelegate {
    
    func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds).chain.backgroundColor(UIColor.white).build
        
        let nav = UINavigationController(rootViewController: MainViewController())
        nav.navigation.configuration.isEnabled = true
        nav.navigation.configuration.isTranslucent = false
        nav.navigation.configuration.barTintColor = UIColor(hex: "#4381E8")
        nav.navigation.configuration.titleTextAttributes = [.foregroundColor: UIColor.white]
        nav.navigation.configuration.tintColor = UIColor.white
        if #available(iOS 11.0, *) {
            nav.navigation.configuration.prefersLargeTitles = true
            nav.navigation.configuration.largeTitle.textAttributes = [.foregroundColor: UIColor.white]
        }
        nav.navigationBar.barStyle = .black
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
