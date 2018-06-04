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
        
        // 下拉刷新
        let refresh = input.refresh.map({ page = 0 }).withLatestFrom(input.keyword).flatMap({
            LCQuery.rx.query("QueryList", keyword: $0, page: page).catchErrorJustReturn(closure: [])
        }).map({ items -> [LCObject] in
            objects = items
            return objects
        }).shareOnce()
        
        let endRefresh = refresh.map(to: ()).asDriver(onErrorJustReturn: ())
        
        // 上拉加载更多
        let more = input.more.map({ page += 1 }).withLatestFrom(input.keyword).flatMap({
            LCQuery.rx.query("QueryList", keyword: $0, page: page).catchErrorJustReturn(closure: [])
        }).map { items -> [LCObject] in
            objects.append(contentsOf: items)
            return objects
        }.shareOnce()
        
        let endMore = more.map(to: ()).asDriver(onErrorJustReturn: ())
        
        let items = Observable.merge(refresh, more).asDriver(onErrorJustReturn: [])
        
        return Output(items: items, endRefresh: endRefresh, endMore: endMore)
    }
}
