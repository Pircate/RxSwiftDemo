//
//  HomeViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import LeanCloud
import MJRefresh

final class HomeViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain).chain
            .rowHeight(60)
            .register(TodoItemCell.self, forCellReuseIdentifier: "cellID").build
        tableView.mj_header = MJRefreshNormalHeader()
        disablesAdjustScrollViewInsets(tableView)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        buildSubviews()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNavigation() {
        navigation.item.title = "首页"
        navigation.bar.tintColor = UIColor.white
        navigation.item.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        navigation.item.leftBarButtonItem?.rx.tap.bind(to: rx.gotoQuery).disposed(by: disposeBag)
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "登录")
        navigation.item.rightBarButtonItem?.rx.tap.map(to: true).gotoLogin(from: self).disposed(by: disposeBag)
    }
    
    private func buildSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigation.bar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        tableView.mj_header.beginRefreshing()
    }
    
    private func bindViewModel() {
        let viewModel = HomeViewModel()
        let input = HomeViewModel.Input(refresh: tableView.mj_header.rx.refreshClosure)
        let output = viewModel.transform(input)
        
        output.items.drive(tableView.rx.items(dataSource: viewModel.dataSource)).disposed(by: disposeBag)
        output.items.map(to: ()).drive(tableView.mj_header.rx.endRefreshing).disposed(by: disposeBag)
        
        // cell 删除操作
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self else { return }
            var sections = viewModel.dataSource.sectionModels
            var items = sections[indexPath.section].items
            let item = items[indexPath.row]
            item.rx.delete().loading()
                .catchErrorJustToast()
                .showToast(onSuccess: "删除成功")
                .subscribe(onNext: { _ in
                    items.remove(at: indexPath.row)
                    if items.isEmpty {
                        sections.remove(at: indexPath.section)
                        viewModel.dataSource.setSections(sections)
                        self.tableView.deleteSections([indexPath.section], animationStyle: .automatic)
                    } else {
                        sections[indexPath.section].items = items
                        viewModel.dataSource.setSections(sections)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                    
                }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}
