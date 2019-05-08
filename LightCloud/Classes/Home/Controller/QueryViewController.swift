//
//  QueryViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import LeanCloud
import EasyRefresher
import RxSwift
import RxCocoa

final class QueryViewController: BaseViewController {
    
    private lazy var searchTextField: UITextField = {
        UITextField().chain
            .frame(x: 0, y: 0, width: UIScreen.width - 80, height: 30)
            .cornerRadius(15)
            .masksToBounds(true)
            .textAlignment(.center)
            .backgroundColor(UIColor.white)
            .clearButtonMode(.always)
            .systemFont(ofSize: 14)
            .placeholder("请输入关键字Query").build
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: .plain).chain
            .register(UITableViewCell.self, forCellReuseIdentifier: "cellID").build
        tableView.tableFooterView = UIView()
        tableView.refresh.header = RefreshHeader()
        tableView.refresh.footer = RefreshFooter()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigation()
        buildSubviews()
        bindViewModel()
    }
    
    private func buildNavigation() {
        navigation.item.titleView = searchTextField
        if #available(iOS 11.0, *) {
            navigation.bar.prefersLargeTitles = false
        }
    }
    
    private func buildSubviews() {
        disablesAdjustScrollViewInsets(tableView)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.topLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(snp.bottomLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        let viewModel = QueryViewModel()
        
        let header = tableView.refresh.header as! RefreshHeader
        let footer = tableView.refresh.footer as! RefreshFooter
        
        let input = QueryViewModel.Input(
            keyword: searchTextField.rx.text.orEmpty.shareOnce(),
            refresh: header.rx.refreshing,
            more: footer.rx.refreshing)
        let output = viewModel.transform(input)
        
        output.items
            .drive(tableView.rx.items(cellIdentifier: "cellID")) { index, item, cell in
                cell.textLabel?.text = (item.value(forKey: "name") as? LCString)?.value
            }.disposed(by: disposeBag)
        
        output.endRefresh
            .drive(header.rx.endRefreshing)
            .disposed(by: disposeBag)
        
        output.endMore
            .drive(footer.rx.endRefreshing)
            .disposed(by: disposeBag)
    }
}
