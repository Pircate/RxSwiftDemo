//
//  HomeViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        (AVUser.current() == nil).asObservable().bind(to: rx.gotoLogin).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Reactive where Base == HomeViewController {
    
    var gotoLogin: Binder<Bool> {
        return Binder(base) {
            guard $1 else { return }
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.navigation.configuration.isEnabled = true
            nav.navigation.configuration.isTranslucent = true
            nav.navigation.configuration.barTintColor = UIColor(hex: "#4381E8")
            $0.present(nav, animated: true, completion: nil)
        }
    }
}
