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
        let register: Driver<Bool>
        let state: Driver<UIState>
    }
}

extension RegisterViewModel: ViewModelType {
    
    func transform(_ input: RegisterViewModel.Input) -> RegisterViewModel.Output {
        let isEnabled = input.verifyloginButton()
        
        let state = State()
        let register = input.requestRegister(state)
        
        return Output(isEnabled: isEnabled,
                      register: register,
                      state: state.asDriver(onErrorJustReturn: .idle))
    }
}

fileprivate extension RegisterViewModel.Input {
    
    func verifyloginButton() -> Driver<Bool> {
        return Observable.combineLatest(username.isEmpty, password.isEmpty) { !$0 && !$1 }
            .asDriver(onErrorJustReturn: false)
    }
    
    func requestRegister(_ state: State) -> Driver<Bool> {
        let usernameAndPassword = Observable.combineLatest(username, password) { (username: $0, password: $1) }
        return registerTap.withLatestFrom(usernameAndPassword).flatMapLatest({
            LCUser.rx.register(username: $0.username, password: $0.password)
                .trackState(state, success: "注册成功").catchErrorJustComplete()
        }).asDriver(onErrorJustReturn: false)
    }
}
