//
//  TodoItemModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/6/6.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import LeanCloud
import RxSwift
import RxCocoa

class TodoItemModel {
    let id: Int
    
    var name: String {
        didSet {
            object.set("name", value: name)
        }
    }
    
    var follow: Bool {
        didSet {
            object.set("follow", value: follow)
        }
    }
    
    let object: LCObject
    
    init(_ object: LCObject) {
        self.object = object
        
        id = (object.value(forKey: "id") as! LCNumber).intValue!
        name = (object.value(forKey: "name") as! LCString).value
        follow = (object.value(forKey: "follow") as! LCBool).value
    }
}

extension TodoItemModel: ViewModelType {
    
    struct Input {
        let followTap: ControlEvent<Void>
    }
    
    struct Output {
        let isSelected: Driver<Bool>
        let state: Driver<UIState>
    }
    
    func transform(_ input: TodoItemModel.Input) -> TodoItemModel.Output {
        let state = State()
        let isSelected = input.followTap.withLatestFrom(Observable.of(self))
            .map({ item -> TodoItemModel in
                item.follow = !item.follow
                return item
            }).flatMap({ item -> Observable<Bool> in
                item.object.rx.save()
                    .trackState(state)
                    .catchError({ _ in
                        item.follow = !item.follow
                        return Observable.empty()
                    })
                    .map(to: item.follow)
            }).asDriver(onErrorJustReturn: false)
        return Output(isSelected: isSelected, state: state.asDriver(onErrorJustReturn: .idle))
    }
}
