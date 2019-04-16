//
//  AVUser+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

extension Reactive where Base: LCUser {
    
    static func requestLoginCaptcha(mobile: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let request = LCUser.requestLoginVerificationCode(mobilePhoneNumber: mobile) { (result) in
                switch result {
                case .success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create { request.cancel() }
        })
    }
    
    static func register(username: String, password: String) -> Observable<Bool> {
        return Observable.create { observer -> Disposable in
            let user = LCUser()
            user.username = LCString(username)
            user.password = LCString(password)
            user.mobilePhoneNumber = LCString(username)
            let request = user.signUp({ (result) in
                switch result {
                case .success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create { request.cancel() }
        }
    }
    
    static func login(mobile: String, captcha: String) -> Observable<LCUser> {
        return Observable.create { (observer) -> Disposable in
            let request = LCUser.logIn(mobilePhoneNumber: mobile, verificationCode: captcha) { (result) in
                switch result {
                case .success(let object):
                    observer.onNext(object)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    static func login(username: String, password: String) -> Observable<LCUser> {
        return Observable.create { (observer) -> Disposable in
            let request = LCUser.logIn(username: username, password: password) { (result) in
                switch result {
                case .success(let object):
                    observer.onNext(object)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
}
