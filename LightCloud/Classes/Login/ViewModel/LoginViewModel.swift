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

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

final class LoginViewModel {
    
    struct Input {
        let username: Observable<String>
        let password: Observable<String>
        let captcha: ControlEvent<Void>
        let login: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Driver<Bool>
        let captcha: Driver<String>
        let login: Observable<LCUser>
    }
}

extension LoginViewModel: ViewModelType {
    
    func transform(_ input: LoginViewModel.Input) -> LoginViewModel.Output {
        let validation = Observable.combineLatest(input.username, input.password) {
            !$0.isEmpty && !$1.isEmpty
        }.asDriver(onErrorJustReturn: false)
        
        let captcha = input.captcha.withLatestFrom(input.username).flatMap({
            LCUser.rx.requestLoginCaptcha(mobile: $0)
                .loading()
                .catchErrorJustToast()
                .do(onNext: { _ in
                    Toast.show(info: "验证码已发送")
                })
        }).flatThen(60.countdown()).asDriver(onErrorJustReturn: "")
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        let login = input.login.withLatestFrom(usernameAndPassword).flatMap {
            LCUser.rx.login(mobile: $0.username, captcha: $0.password)
                .loading()
                .catchErrorJustToast()
                .do(onNext: { _ in
                    Toast.show(info: "登录成功")
                })
        }
        return Output(validation: validation, captcha: captcha, login: login)
    }
}

extension Reactive where Base == LoginViewController {
    
    var gotoRegister: Binder<Void> {
        return Binder(base) { viewController, _ in
            viewController.navigationController?.pushViewController(RegisterViewController(), animated: true)
        }
    }
}
