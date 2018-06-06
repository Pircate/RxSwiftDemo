//
//  TodoItemModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/6/6.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import LeanCloud

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
