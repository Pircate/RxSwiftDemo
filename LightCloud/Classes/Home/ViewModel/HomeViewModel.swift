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
import RxNetwork

struct TodoSectionModel {
    
    var items: [TodoItemModel]
}

extension TodoSectionModel: SectionModelType {
    
    init(original: TodoSectionModel, items: [TodoItemModel]) {
        self = original
        self.items = items
    }
}

final class HomeViewModel {
    
    struct Input {
        let refresh: Observable<Void>
        let itemDeleted: ControlEvent<IndexPath>
        let dataSource: Observable<RxTableViewSectionedReloadDataSource<TodoSectionModel>>
    }
    
    struct Output {
        let items: Driver<[TodoSectionModel]>
        let banners: Observable<[(image: String, title: String)]>
        let itemDeleted: Observable<IndexPath>
        let state: Driver<UIState>
    }
}

extension HomeViewModel: ViewModelType {
    
    func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        let state = State()
        
        let items = input.requestTodoList(state)
        let banners = input.requestBannerList()
        let itemDeleted = input.requestDeleteItem(state)
        
        return Output(items: items,
                      banners: banners,
                      itemDeleted: itemDeleted,
                      state: state.asDriver(onErrorJustReturn: .idle))
    }
}

fileprivate extension HomeViewModel.Input {
    
    // 获取 todo 列表
    func requestTodoList(_ state: State) -> Driver<[TodoSectionModel]> {
        let models = (0...99).lazy.map { index -> TodoItemModel in
            let object = LCObject(className: "TodoList")
            object.set("id", value: index)
            object.set("name", value: "Todo-\(index)")
            object.set("follow", value: false)
            return TodoItemModel(object)
        }
    
        return refresh.flatMap({ _ in
            LCQuery.rx.query("TodoList", keyword: "Todo")
                .map({ $0.map(TodoItemModel.init) })
                .map({ [TodoSectionModel(items: $0)] })
                .trackState(state)
                .catchErrorJustReturn(closure: [TodoSectionModel(items: Array(models))])
        }).asDriver(onErrorJustReturn: [])
    }
    
    func requestBannerList() -> Observable<[(image: String, title: String)]> {
        return refresh.flatMap({
            BannerAPI.items.cache.request()
                .map(BannerListModel.self)
                .map({ $0.topStories })
                .map({ $0.map({ (image: $0.image, title: $0.title) })})
                .asObservable()
                .catchErrorJustComplete()
        })
    }
    
    func requestDeleteItem(_ state: State) -> Observable<IndexPath> {
        return Observable.combineLatest(itemDeleted, dataSource) { (item: $1[$0], indexPath: $0) }
            .flatMap({
                $0.item.object.rx.delete()
                    .trackState(state, success: "删除成功")
                    .catchErrorJustComplete()
                    .map(to: $0.indexPath)
            })
    }
}
