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
        let username: Observable<String>
        let password: Observable<String>
        let registerTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEnabled: Driver<Bool>
        let register: Observable<Bool>
    }
}

extension RegisterViewModel: ViewModelType {
    
    func transform(_ input: RegisterViewModel.Input) -> RegisterViewModel.Output {
        
        let isEnabled = Observable.combineLatest(input.username, input.password) {
            !$0.isEmpty && !$1.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        let register = input.registerTap.withLatestFrom(usernameAndPassword).flatMapLatest({
            LCUser.rx.register(username: $0.username, password: $0.password)
                .loading()
                .catchErrorJustToast()
                .showToast(onSuccess: "注册成功")
        })
        
        return Output(isEnabled: isEnabled, register: register)
    }
}
