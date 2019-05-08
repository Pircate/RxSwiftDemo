// 
//  Refreshable.swift
//  Refresher
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/26
//  Copyright © 2019 Pircate. All rights reserved.
//

import Foundation

public enum RefreshState {
    case idle
    case pulling
    case willRefresh
    case refreshing
}

public protocol Refreshable: class {
    
    var state: RefreshState { get set }
    
    var isRefreshing: Bool { get }
    
    var refreshClosure: () -> Void { get set }
    
    init(refreshClosure: @escaping () -> Void)
    
    func addRefresher(_ refreshClosure: @escaping () -> Void)
    
    func beginRefreshing()
    
    func endRefreshing()
}

public extension Refreshable {
    
    var isRefreshing: Bool {
        return state == .refreshing
    }
    
    func addRefresher(_ refreshClosure: @escaping () -> Void) {
        self.refreshClosure = refreshClosure
    }
    
    func beginRefreshing() {
        state = .refreshing
    }
    
    func endRefreshing() {
        state = .idle
    }
}
