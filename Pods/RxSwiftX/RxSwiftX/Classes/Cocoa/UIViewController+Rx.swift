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
        
    func push(animated: Bool = true) -> Binder<UIViewController> {
        return Binder(base) { viewController, to in
            viewController.navigationController?.pushViewController(to, animated: animated)
        }
    }
    
    func pop(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { viewController, _ in
            viewController.navigationController?.popViewController(animated: animated)
        }
    }
    
    func popToRoot(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { viewController, _ in
            viewController.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func dismiss(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { viewController, _ in
            viewController.dismiss(animated: animated, completion: nil)
        }
    }
}
