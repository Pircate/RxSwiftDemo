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
        let refresh: ControlEvent<Void>
        let more: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[LCObject]>
        let endRefresh: Driver<RefreshState>
        let endMore: Driver<RefreshState>
    }
    
    var start = 0
}

extension QueryViewModel: ViewModelType {
    
    func transform(_ input: QueryViewModel.Input) -> QueryViewModel.Output {
        
        let source0 = input.refresh.map({
            self.start = 0
            return self.start
        }).flatMap({
            LCQuery.rx.queryForID("ObjC", start: $0, offset: 10)
                .loading()
                .catchErrorJustShowForLCQuery()
                .hideToast()
        }).share(replay: 1)
        
        let source1 = input.more.map({
            self.start += 10
            return self.start
        }).flatMap({
            LCQuery.rx.queryForID("ObjC", start: $0, offset: 10)
                .loading()
                .catchErrorJustShowForLCQuery()
                .hideToast()
        }).share(replay: 1)
        
        let endRefresh = source0.map({ _ in RefreshState.endHeaderRefresh }).asDriver(onErrorJustReturn: .none)
        let endMore = source1.map({ _ in RefreshState.endFooterRefresh }).asDriver(onErrorJustReturn: .none)
        let items = Observable.merge(source0, source1).asDriver(onErrorJustReturn: [])
        
        return Output(items: items, endRefresh: endRefresh, endMore: endMore)
    }
}
