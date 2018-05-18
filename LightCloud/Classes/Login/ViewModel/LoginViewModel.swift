//
//  LoginViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

final class LoginViewModel {
    
    struct Input {
        let username: ControlProperty<String>
        let password: ControlProperty<String>
        let login: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Driver<Bool>
        let login: Observable<AVUser?>
    }
}

extension LoginViewModel: ViewModelType {
    
    func transform(_ input: LoginViewModel.Input) -> LoginViewModel.Output {
        let validation = Observable.combineLatest(input.username, input.password) {
            !$0.isEmpty && !$1.isEmpty
        }.asDriver(onErrorJustReturn: false)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        let login = input.login.withLatestFrom(usernameAndPassword).flatMap {
            AVUser.rx.login(username: $0.username, password: $0.password).loading().catchError({
                Toast.show(info: $0.statusMessage)
                return Observable.empty()
            }).do(onNext: { _ in
                Toast.show(info: "Login success")
            })
        }
        return Output(validation: validation, login: login)
    }
}

extension Reactive where Base == LoginViewController {
    
    var gotoRegister: Binder<Void> {
        return Binder(base) { viewController, _ in
            viewController.navigationController?.pushViewController(RegisterViewController(), animated: true)
        }
    }
}
