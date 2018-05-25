//
//  HomeViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import LeanCloud

struct TodoSectionModel {
    
    var items: [LCObject]
}

extension TodoSectionModel: SectionModelType {
    
    init(original: TodoSectionModel, items: [LCObject]) {
        self = original
        self.items = items
    }
}

final class HomeViewModel {
    
    struct Input {
        let refresh: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[TodoSectionModel]>
    }
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<TodoSectionModel> = {
        return RxTableViewSectionedReloadDataSource<TodoSectionModel>.init(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! TodoItemCell
            cell.update(item)
            
            cell.followButton.rx.tap
                .map { _ -> LCObject in
                    item.set("follow", value: !(item.value(forKey: "follow") as! LCBool).value)
                    return item
                }
                .flatMap({
                    $0.rx.save().loading().catchErrorJustToast().hideToastOnSuccess()
                })
                .map({ _ in (item.value(forKey: "follow") as! LCBool).value })
                .asDriver(onErrorJustReturn: false)
                .drive(cell.followButton.rx.isSelected)
                .disposed(by: cell.disposeBag)
            
            return cell
        }, canEditRowAtIndexPath: { _, _ in
            return true
        }, canMoveRowAtIndexPath: { _, _ in
            return true
        })
    }()
}

extension HomeViewModel: ViewModelType {
    
    func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        let items = input.refresh.flatMap({
            LCQuery.rx.query("TodoList", keyword: "")
                .map({ [TodoSectionModel(items: $0)] })
                .loading()
                .hideToastOnSuccess()
                .catchErrorJustToast(return: [])
        }).asDriver(onErrorJustReturn: [])
        
        return Output(items: items)
    }
}
