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
    }
    
    struct Output {
        let items: Driver<[LCObject]>
    }
}

extension QueryViewModel: ViewModelType {
    
    func transform(_ input: QueryViewModel.Input) -> QueryViewModel.Output {
        let items = input.keyword.filter({ !$0.isBlank })
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap({
                LCQuery.rx.query("ObjC", keyword: $0).catchErrorJustReturn([])
            }).asDriver(onErrorJustReturn: [])
        return Output(items: items)
    }
}
