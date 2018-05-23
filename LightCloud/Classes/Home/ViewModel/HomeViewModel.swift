//
//  HomeViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

final class HomeViewModel {
    
    struct Input {
        let refresh: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[LCObject]>
    }
}

extension HomeViewModel: ViewModelType {
    
    func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        
        let items = input.refresh.flatMap({
            LCQuery.rx.query("TodoList", keyword: "")
                .loading()
                .catchErrorJustToast()
                .hideToastOnSuccess()
        }).asDriver(onErrorJustReturn: [])
        
        return Output(items: items)
    }
    
    func selectFollowButton(_ button: UIButton, item: LCObject) -> Observable<Bool> {
        return button.rx.tap.map({
            item.set("follow", value: !button.isSelected)
        }).flatMap({
            item.rx.save().loading().catchErrorJustToast().hideToastOnSuccess()
        })
    }
}

extension Reactive where Base == HomeViewController {
    
    var gotoQuery: Binder<Void> {
        return Binder(base) { home, _ in
            home.navigationController?.pushViewController(QueryViewController(), animated: true)
        }
    }
    
    var reloadRows: Binder<IndexPath> {
        return Binder(base) { home, indexPath in
            home.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
