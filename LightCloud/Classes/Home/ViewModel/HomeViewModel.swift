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
import RxSwiftX

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
        let state = PublishRelay<UIState>()
        
        let models = (0...99).lazy.map { index -> TodoItemModel in
            let object = LCObject(className: "TodoList")
            object.set("id", value: index)
            object.set("name", value: "Todo-\(index)")
            object.set("follow", value: false)
            return TodoItemModel(object)
        }
        
        // 获取 todo 列表
        let items = input.refresh.flatMap({ _ in
            LCQuery.rx.query("TodoList", keyword: "Todo")
                .map({ $0.map(TodoItemModel.init) })
                .map({ [TodoSectionModel(items: $0)] })
                .trackState(state)
                .catchErrorJustReturn(closure: [TodoSectionModel(items: Array(models))])
        }).asDriver(onErrorJustReturn: [])
        
        // 获取 banner 列表
        let banners = input.refresh.flatMap({
            BannerAPI.items.request()
                .map(BannerListModel.self)
                .map({ $0.topStories })
                .map({ $0.map({ (image: $0.image, title: $0.title) })})
                .asObservable()
                .catchErrorJustComplete()
        })
        
        // 删除 item 请求
        let itemDeleted = Observable.combineLatest(input.itemDeleted, input.dataSource) { $1[$0] }
            .flatMap({
                $0.object.rx.delete()
                    .trackState(state, success: "删除成功")
                    .catchErrorJustComplete()
            }).withLatestFrom(input.itemDeleted)
        
        return Output(items: items, banners: banners, itemDeleted: itemDeleted, state: state.asDriver(onErrorJustReturn: .idle))
    }
}
