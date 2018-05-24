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
    
    struct ItemInput {
        let followTap: ControlEvent<Void>
        let item: Observable<LCObject>
    }
    
    struct ItemOutput {
        let isSelected: Driver<Bool>
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
    
    func itemTransform(_ input: ItemInput) -> ItemOutput {
        let isSelected = input.followTap.withLatestFrom(input.item)
            .map { item -> LCObject in
                item.set("follow", value: !(item.value(forKey: "follow") as! LCBool).value)
                return item
            }
            .flatMap({
                $0.rx.save().loading().catchErrorJustToast().hideToastOnSuccess()
            })
            .withLatestFrom(input.item).map({ ($0.value(forKey: "follow") as! LCBool).value })
            .asDriver(onErrorJustReturn: false)
        return ItemOutput(isSelected: isSelected)
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
