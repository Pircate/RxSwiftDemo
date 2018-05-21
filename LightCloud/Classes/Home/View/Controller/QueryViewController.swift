//
//  QueryViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import MJRefresh
import LeanCloud

final class QueryViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.mj_header = MJRefreshNormalHeader()
        tableView.mj_footer = MJRefreshBackNormalFooter()
        return tableView
    }()
    
    private let start: Observable<Int> = Observable.of(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildSubviews()
        bindViewModel()
        
        tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func buildSubviews() {
        disablesAdjustScrollViewInsets(tableView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigation.bar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let viewModel = QueryViewModel()
        let input = QueryViewModel.Input(refresh: tableView.mj_header.rx.refreshClosure, more: tableView.mj_footer.rx.refreshClosure)
        let output = viewModel.transform(input)
        
        output.items.drive(tableView.rx.items(cellIdentifier: "cellID")) { index, item, cell in
            cell.textLabel?.text = (item.value(forKey: "name") as? LCString)?.value
        }.disposed(by: disposeBag)
        
        output.endRefresh.drive(tableView.rx.endRefreshing).disposed(by: disposeBag)
        output.endMore.drive(tableView.rx.endRefreshing).disposed(by: disposeBag)
    }
}
