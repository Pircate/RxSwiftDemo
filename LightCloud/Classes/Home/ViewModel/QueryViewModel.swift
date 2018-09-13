//
//  QueryViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

final class QueryViewModel {
    
    struct Input {
        let keyword: Observable<String>
        let refresh: ControlEvent<Void>
        let more: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[LCObject]>
        let endRefresh: Driver<Void>
        let endMore: Driver<Void>
    }
}

extension QueryViewModel: ViewModelType {
    
    func transform(_ input: QueryViewModel.Input) -> QueryViewModel.Output {
        
        var page = 0
        var objects: [LCObject] = []
        
        let query = input.keyword.skip(1)
            .throttle(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged().then(page = 0)
            .flatMap({
                LCQuery.rx.query("QueryList", keyword: $0, page: page)
                    .catchErrorJustReturn(closure: [])
            }).map({ items -> [LCObject] in
                objects = items
                return objects
            }).asDriver(onErrorJustReturn: [])
        
        // 下拉刷新
        let refresh = input.refresh.then(page = 0)
            .withLatestFrom(input.keyword)
            .flatMap({
                LCQuery.rx.query("QueryList", keyword: $0, page: page)
                    .catchErrorJustReturn(closure: [])
            }).map({ items -> [LCObject] in
                objects = items
                return objects
            }).asDriver(onErrorJustReturn: [])
        
        let endRefresh = refresh.map(to: ())
        
        // 上拉加载更多
        let more = input.more.then(page += 1)
            .withLatestFrom(input.keyword)
            .flatMap({
                LCQuery.rx.query("QueryList", keyword: $0, page: page)
                    .catchErrorJustReturn(closure: [])
            }).map { items -> [LCObject] in
                objects += items
                return objects
            }.asDriver(onErrorJustReturn: [])
        
        let endMore = more.map(to: ())
        
        let items = Driver.of(query, refresh, more).merge()
        
        return Output(items: items, endRefresh: endRefresh, endMore: endMore)
    }
}
