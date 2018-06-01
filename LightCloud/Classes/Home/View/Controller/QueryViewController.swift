//
//  QueryViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import LeanCloud
import MJRefresh
import RxSwift
import RxCocoa

final class QueryViewController: BaseViewController {
    
    private lazy var searchTextField: UITextField = {
        UITextField().chain
            .frame(x: 0, y: 0, width: UIScreen.width - 60, height: 30)
            .cornerRadius(15)
            .masksToBounds(true)
            .textAlignment(.center)
            .backgroundColor(UIColor.white)
            .systemFont(ofSize: 14).build
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain).chain
            .register(UITableViewCell.self, forCellReuseIdentifier: "cellID").build
        tableView.mj_header = MJRefreshNormalHeader()
        tableView.mj_footer = MJRefreshBackStateFooter()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigation()
        buildSubviews()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func buildNavigation() {
        navigation.item.titleView = searchTextField
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
        
        let keyword = searchTextField.rx.text.orEmpty.skip(1).shareOnce()
        keyword.throttle(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged().map(to: ())
            .asDriver(onErrorJustReturn: ())
            .drive(tableView.mj_header.rx.beginRefreshing)
            .disposed(by: disposeBag)
        
        let input = QueryViewModel.Input(keyword: keyword,
                                         refresh: tableView.mj_header.rx.refreshing,
                                         more: tableView.mj_footer.rx.refreshing)
        let output = viewModel.transform(input)
        
        output.items.drive(tableView.rx.items(cellIdentifier: "cellID")) { index, item, cell in
            cell.textLabel?.text = (item.value(forKey: "name") as? LCString)?.value
        }.disposed(by: disposeBag)
        
        output.endRefresh.drive(tableView.mj_header.rx.endRefreshing).disposed(by: disposeBag)
        output.endMore.drive(tableView.mj_footer.rx.endRefreshing).disposed(by: disposeBag)
    }
}
