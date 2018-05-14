//
//  AVUser+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: AVUser {
    
    func register(username: String?, password: String?) -> Observable<Bool> {
        return Observable.create { [weak base] observer -> Disposable in
            base?.username = username
            base?.password = password
            base?.signUpInBackground { (success, error) in
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
}
