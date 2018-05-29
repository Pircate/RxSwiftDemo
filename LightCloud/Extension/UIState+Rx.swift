//
//  UIState+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/28.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

enum UIState {
    case idle
    case loading
    case success(String?)
    case failure(String?)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    var isFailure: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
}

struct UIStateToken<E>: Disposable {
    
    private let _source: Observable<E>
    
    init(source: Observable<E>) {
        _source = source
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
    
    func dispose() {}
}

extension ObservableConvertibleType {
    
    /// Toast
    ///
    /// - Parameters:
    ///   - state: UIState publish relay
    ///   - loading: 是否显示loading框
    ///   - success: 成功提示信息
    ///   - failure: 失败提示信息，默认toast后台返回的错误信息，自定义错误信息返回nil则隐藏loading框
    /// - Returns: 绑定的序列
    func trackState(_ state: PublishRelay<UIState>,
                    loading: Bool = true,
                    success: String? = nil,
                    failure: ((Error) -> String?)? = nil) -> Observable<E> {
        return Observable.using({ () -> UIStateToken<E> in
            if loading { state.accept(.loading) }
            return UIStateToken(source: self.asObservable())
        }, observableFactory: {
            return $0.asObservable().map({
                state.accept(.success(success))
                return $0
            }).catchError({
                guard let failure = failure else {
                    state.accept(.failure($0.reason))
                    return Observable.error($0)
                }
                state.accept(.failure(failure($0)))
                return Observable.error($0)
            })
        })
    }
}
