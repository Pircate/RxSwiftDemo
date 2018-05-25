//
//  BaseViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinit")
    }
}

extension Reactive where Base: BaseViewController {
    
    var gotoLogin: Binder<Void> {
        return Binder(base) { vc, _ in
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.navigation.configuration.isEnabled = true
            nav.navigation.configuration.isTranslucent = true
            nav.navigation.configuration.barTintColor = UIColor(hex: "#4381E8")
            nav.navigation.configuration.titleTextAttributes = [.foregroundColor: UIColor.white]
            nav.navigationBar.barStyle = .black
            vc.present(nav, animated: true, completion: nil)
        }
    }
}
