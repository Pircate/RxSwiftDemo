//
//  UIViewControllerExt.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/2.
//

import RxSwift
import RxCocoa
import ExtensionX

extension Reactive where Base: UIViewController {
    
    var goBack: Binder<Bool> {
        return Binder(base) {
            if $1 { $0.goBack() }
        }
    }
    
    var dismiss: Binder<Bool> {
        return Binder(base) {
            if $1 { $0.dismiss(animated: true, completion: nil) }
        }
    }
    
    var gotoLogin: Binder<Bool> {
        return Binder(base) {
            guard $1 else { return }
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.navigation.configuration.isEnabled = true
            nav.navigation.configuration.isTranslucent = true
            nav.navigation.configuration.barTintColor = UIColor(hex: "#4381E8")
            nav.navigation.configuration.titleTextAttributes = [.foregroundColor: UIColor.white]
            $0.present(nav, animated: true, completion: nil)
        }
    }
}
