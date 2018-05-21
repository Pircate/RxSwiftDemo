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
        let keyword: ControlProperty<String>
        let refresh: ControlEvent<Void>
        let more: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[LCObject]>
        let endRefresh: Driver<RefreshState>
        let endMore: Driver<RefreshState>
    }
    
    private var start = 0
    private var items: [LCObject] = []
}

extension QueryViewModel: ViewModelType {
    
    func transform(_ input: QueryViewModel.Input) -> QueryViewModel.Output {
        
        let source2 = input.keyword.filter({ !$0.isBlank })
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged().flatMap({
                LCQuery.rx.query("ObjC", keyword: $0)
                    .catchErrorJustReturn([]).flatMap({ items -> Observable<[LCObject]> in
                        self.items = items
                        return Observable.of(items)
                    })
            })
        
        let source0 = input.refresh.map({
            self.start = 0
        }).withLatestFrom(input.keyword)
            .flatMap({
                LCQuery.rx.query("ObjC", keyword: $0, start: 0)
                    .catchErrorJustReturn([])
                    .flatMap({ items -> Observable<[LCObject]> in
                        self.items = items
                        return Observable.of(items)
                    })
            }).share(replay: 1)
        
        let source1 = input.more.map({
            self.start += 10
        }).withLatestFrom(input.keyword).flatMap({
            LCQuery.rx.query("ObjC", keyword: $0, start: self.start)
                .catchErrorJustReturn([])
                .flatMap({ items -> Observable<[LCObject]> in
                    self.items.append(contentsOf: items)
                    return Observable.of(self.items)
                })
        }).share(replay: 1)
        
        let endRefresh = source0.map({ _ in RefreshState.endHeaderRefresh }).asDriver(onErrorJustReturn: .none)
        let endMore = source1.map({ _ in RefreshState.endFooterRefresh }).asDriver(onErrorJustReturn: .none)
        let items = Observable.merge(source0, source1, source2).asDriver(onErrorJustReturn: [])
        
        return Output(items: items, endRefresh: endRefresh, endMore: endMore)
    }
}
