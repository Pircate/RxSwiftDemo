//
//  HomeViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import LeanCloud
import CRRefresh

extension Reactive where Base: UITableView {
    
    var isEditing: Binder<Bool> {
        return Binder(base) { tableView, isEditing in
            tableView.setEditing(isEditing, animated: false)
        }
    }
}

final class HomeViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain).chain
            .rowHeight(60)
            .register(TodoItemCell.self, forCellReuseIdentifier: "cellID").build
        tableView.cr.addHeadRefresh {}
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
        navigation.item.leftBarButtonItem?.rx.tap.map(to: QueryViewController()).bind(to: rx.push).disposed(by: disposeBag)
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "登录")
        navigation.item.rightBarButtonItem?.rx.tap.bind(to: rx.gotoLogin).disposed(by: disposeBag)
        
        let editButton = UIButton(type: .custom).chain
            .title("编辑", for: .normal, .highlighted)
            .title("完成", for: .selected, [.selected, .highlighted])
            .systemFont(ofSize: 16).build
        navigation.item.titleView = editButton
        
        let isSelected = editButton.rx.tap.map({ !editButton.isSelected }).share(replay: 1)
        isSelected.bind(to: editButton.rx.isSelected).disposed(by: disposeBag)
        isSelected.bind(to: tableView.rx.isEditing).disposed(by: disposeBag)
        // 编辑状态禁用下拉刷新
        isSelected.map({ !$0 }).bind(to: tableView.cr.header!.rx.isUserInteractionEnabled).disposed(by: disposeBag)
    }
    
    private func buildSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigation.bar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        tableView.cr.header?.beginRefreshing()
    }
    
    private func bindViewModel() {
        let viewModel = HomeViewModel()
        let input = HomeViewModel.Input(refresh: tableView.cr.header!.rx.refreshHandler)
        let output = viewModel.transform(input)
        
        output.items.drive(tableView.rx.items(dataSource: viewModel.dataSource)).disposed(by: disposeBag)
        
        // 请求完成结束刷新
        output.items.map(to: ()).drive(tableView.cr.header!.rx.endRefreshing).disposed(by: disposeBag)
        
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
        
        // cell 移动操作
        tableView.rx.itemMoved.subscribe(onNext: { (from, to) in
            let sections = viewModel.dataSource.sectionModels
            let item = viewModel.dataSource[from]
            var fromItems = sections[from.section].items
            var toItems = sections[to.section].items
            fromItems.remove(at: from.item)
            toItems.insert(item, at: to.row)
            viewModel.dataSource.setSections(sections)
        }).disposed(by: disposeBag)
    }
}
