//
//  Updatable.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/14.
//  Copyright © 2018年 gaoX. All rights reserved.
//

protocol Updatable: class {
    
    associatedtype Item
    
    func update(_ item: Item)
}
