//
//  UIViewControllerExt.swift
//  RxSwiftX
//
//  Created by Pircate on 2018/5/2.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    
    func push<T: UIViewController>(_ type: T.Type, animated: Bool = true) -> Binder<Void> {
        return Binder(base) { vc, _ in
            vc.navigationController?.pushViewController(type.init(), animated: animated)
        }
    }
    
    func pop(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { vc, _ in
            vc.navigationController?.popViewController(animated: animated)
        }
    }
    
    func popToRoot(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { vc, _ in
            vc.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func dismiss(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { vc, _ in
            vc.dismiss(animated: animated, completion: nil)
        }
    }
}
