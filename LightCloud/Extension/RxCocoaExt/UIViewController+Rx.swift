//
//  UIViewControllerExt.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/2.
//

import RxSwift
import RxCocoa
import ExtensionX

extension Reactive where Base: UIViewController {
    
    func push<T: UIViewController>(_ type: T.Type) -> Binder<Void> {
        return Binder(base) { vc, _ in
            vc.navigationController?.pushViewController(type.init(), animated: true)
        }
    }
    
    var pop: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.navigationController?.popViewController(animated: true)
        }
    }
    
    var dismiss: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    var goBack: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.goBack()
        }
    }
}
