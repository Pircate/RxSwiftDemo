//
//  RegisterViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

final class RegisterViewModel {
    
    struct Input {
        let username: ControlProperty<String>
        let password: ControlProperty<String>
        let register: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Driver<Bool>
        let register: Observable<Bool>
    }
}

extension RegisterViewModel: ViewModelType {
    
    func transform(_ input: RegisterViewModel.Input) -> RegisterViewModel.Output {
        
        let validation = Observable.combineLatest(input.username, input.password) {
            !$0.isEmpty && !$1.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        let register = input.register.withLatestFrom(usernameAndPassword).flatMapLatest({
            LCUser.rx.register(username: $0.username, password: $0.password)
                .loading()
                .catchErrorJustShow()
                .do(onNext: { success in
                    Toast.show(info: "注册\(success ? "成功" : "失败")")
                })
        })
        
        return Output(validation: validation, register: register)
    }
}
