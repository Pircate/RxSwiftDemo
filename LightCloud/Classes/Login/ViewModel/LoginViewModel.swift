//
//  LoginViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

typealias State = PublishRelay<UIState>

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

final class LoginViewModel {
    
    struct Input {
        let username: Observable<String>
        let password: Observable<String>
        let captchaTap: ControlEvent<Void>
        let loginTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEnabled: Driver<Bool>
        let captcha: Driver<(title: String, isEnabled: Bool)>
        let login: Driver<Bool>
        let state: Driver<UIState>
    }
}

extension LoginViewModel: ViewModelType {
    
    func transform(_ input: LoginViewModel.Input) -> LoginViewModel.Output {
        let isEnabled = input.verifyloginButton()
        
        let state = State()
        let captcha = input.requestLoginCaptcha(state)
        let login = input.requestLogin(state)
        
        return Output(
            isEnabled: isEnabled,
            captcha: captcha,
            login: login,
            state: state.asDriver(onErrorJustReturn: .idle))
    }
}

fileprivate extension LoginViewModel.Input {
    
    func verifyloginButton() -> Driver<Bool> {
        return Observable.combineLatest(username.isEmpty, password.isEmpty) { !$0 && !$1 }
            .asDriver(onErrorJustReturn: false)
    }
    
    func requestLoginCaptcha(_ state: State) -> Driver<(title: String, isEnabled: Bool)> {
        return captchaTap.withLatestFrom(username)
            .flatMap{
                LCUser.rx.requestLoginCaptcha(mobile: $0)
                    .trackState(state, success: "验证码已发送")
                    .catchErrorJustComplete()
            }
            .flatMap(to: 60.countdown())
            .asDriver(onErrorJustReturn: (title: "重新发送", isEnabled: true))
    }
    
    func requestLogin(_ state: State) -> Driver<Bool> {
        let usernameAndPassword = Observable.combineLatest(username, password) {
            (username: $0, password: $1)
        }
        return loginTap.withLatestFrom(usernameAndPassword)
            .flatMap {
                LCUser.rx.login(mobile: $0.username, captcha: $0.password)
                    .trackState(state, success: "登录成功")
                    .catchErrorJustComplete()
            }
            .map(to: true)
            .asDriver(onErrorJustReturn: false)
    }
}
