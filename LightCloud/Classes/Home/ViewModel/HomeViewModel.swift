//
//  HomeViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/21.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

extension HomeViewModel: ViewModelType {
    
    func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        return Output()
    }
}

extension Reactive where Base == HomeViewController {
    
    var gotoQuery: Binder<Void> {
        return Binder(base) { home, _ in
            home.navigationController?.pushViewController(QueryViewController(), animated: true)
        }
    }
}
