//
//  QueryViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

final class QueryViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

extension QueryViewModel: ViewModelType {
    
    func transform(_ input: QueryViewModel.Input) -> QueryViewModel.Output {
        
        return Output()
    }
}
