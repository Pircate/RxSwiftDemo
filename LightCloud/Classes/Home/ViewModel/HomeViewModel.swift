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
        let refresh: Observable<Void>
        let itemDeleted: ControlEvent<IndexPath>
        let dataSource: Observable<RxTableViewSectionedReloadDataSource<TodoSectionModel>>
    }
    
    struct Output {
        let items: Driver<[TodoSectionModel]>
        let banners: Observable<[String]>
        let itemDeleted: Observable<IndexPath>
        let state: Driver<UIState>
    }
}

extension HomeViewModel: ViewModelType {
    
    func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        let state = PublishRelay<UIState>()
        
        // 获取 todo 列表
        let items = input.refresh.flatMap({
            LCQuery.rx.query("TodoList", keyword: "")
                .map({ [TodoSectionModel(items: $0)] })
                .trackLCState(state).catchErrorJustReturn([])
        }).asDriver(onErrorJustReturn: [])
        
        // 获取 banner 列表
        let banners = input.refresh.flatMap({
            BannerAPI.items(count: 10).request().mapResult([BannerItemModel].self)
                .trackNWState(state).catchErrorJustComplete()
        }).map({ $0.map({ "http://106.15.201.144:82/upload/" + $0.img }) })
        
        // 删除 item 请求
        let itemDeleted = Observable.combineLatest(input.itemDeleted, input.dataSource) { $1[$0] }
            .flatMap({
                $0.rx.delete().trackLCState(state, success: "删除成功").catchErrorJustComplete()
            }).withLatestFrom(input.itemDeleted)
        
        return Output(items: items, banners: banners, itemDeleted: itemDeleted, state: state.asDriver(onErrorJustReturn: .idle))
    }
}
