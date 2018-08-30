//
//  MainViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/6/7.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        UITableView(frame: CGRect.zero, style: .plain).chain
            .register(UITableViewCell.self, forCellReuseIdentifier: "cellID").build
    }()
    
    private lazy var dataSource: [(String, BaseViewController.Type)] = {
        [("登录注册", LoginViewController.self),
         ("列表编辑", HomeViewController.self),
         ("搜索及刷新", QueryViewController.self)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.item.title = "RxSwiftDemo"
        navigation.item.leftBarButtonItem = nil

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(snp.topLayoutGuide)
            make.left.bottom.right.equalToSuperview()
        }
        
        Driver.of(dataSource).drive(tableView.rx.items(cellIdentifier: "cellID")) { _, item, cell in
            cell.textLabel?.text = item.0
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(to: tableView.rx.deselectRow(animated: true)).disposed(by: disposeBag)
        tableView.rx.modelSelected((String, BaseViewController.Type).self).map({ $0.1 }).bind(to: rx.push).disposed(by: disposeBag)
    }
}

extension Reactive where Base == MainViewController {
    
    var push: Binder<BaseViewController.Type> {
        return Binder(base) { vc, type in
            vc.navigationController?.pushViewController(type.init(), animated: true)
        }
    }
}
