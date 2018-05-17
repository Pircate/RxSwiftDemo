//
//  UIViewControllerExt.swift
//  ExtensionX
//
//  Created by GorXion on 2018/5/2.
//

import RxSwift
import RxCocoa
import ExtensionX

extension ObservableType {
    
    func goBack(_ viewController: UIViewController) -> Disposable {
        return map({ _ in () }).asDriver(onErrorJustReturn: ()).drive(viewController.rx.goBack)
    }
}

extension Reactive where Base: UIViewController {
    
    var goBack: Binder<Void> {
        return Binder(base) { viewController, _ in
            viewController.goBack()
        }
    }
}
