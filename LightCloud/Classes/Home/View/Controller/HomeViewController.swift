//
//  HomeViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import LeanCloud

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigation()
        
        (AVUser.current() == nil).asObservable().gotoLogin(from: self).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func buildNavigation() {
        navigation.item.title = "首页"
        navigation.bar.tintColor = UIColor.white
        navigation.item.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        navigation.item.leftBarButtonItem?.rx.tap.bind(to: rx.gotoQuery).disposed(by: disposeBag)
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "登录")
        navigation.item.rightBarButtonItem?.rx.tap.then(true).gotoLogin(from: self).disposed(by: disposeBag)
    }
}
