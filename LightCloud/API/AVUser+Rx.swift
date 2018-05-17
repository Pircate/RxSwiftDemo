//
//  AVUser+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

extension Error {
    
    var statusMessage: String {
        let error = self as NSError
        if let dic = error.userInfo["com.leancloud.restapi.response.error"] as? [String: Any],
            let message = dic["error"] as? String {
            return message
        }
        return "未知错误"
    }
}

extension Reactive where Base: AVUser {
    
    static func register(username: String?, password: String?) -> Observable<Bool> {
        return Observable.create { observer -> Disposable in
            let user = AVUser()
            user.username = username
            user.password = password
            user.signUpInBackground { (success, error) in
                guard let error = error else {
                    observer.onNext(success)
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    static func login(username: String, password: String) -> Observable<AVUser?> {
        return Observable.create { (observer) -> Disposable in
            Base.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                guard let error = error else {
                    observer.onNext(user)
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    static func login(mobile: String, captcha: String) -> Observable<AVUser?> {
        return Observable.create { (observer) -> Disposable in
            Base.logInWithMobilePhoneNumber(inBackground: mobile, smsCode: captcha, block: { (user, error) in
                guard let error = error else {
                    observer.onNext(user)
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
}
