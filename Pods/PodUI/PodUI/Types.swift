//
//  Types.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class Rect<T: Equatable>: Sequence {
    
    public init(_ l: T, _ t: T,_ r: T,_ b: T) {
        self.left = l
        self.top = t
        self.right = r
        self.bottom = b
    }
    
    open var left: T
    open var top: T
    open var right: T
    open var bottom: T
    
    func equals(_ rhs: Rect<T>) -> Bool {
        return (self.left == rhs.left) ||
            (self.top == rhs.top) ||
            (self.right == rhs.right) ||
            (self.bottom == rhs.bottom)
    }
    
    open func makeIterator() -> IndexingIterator<[T]> {
        var arr = [T]()
        arr.append(left)
        arr.append(top)
        arr.append(right)
        arr.append(bottom)
        return arr.makeIterator()
    }
}

open class MethodHandle {
    
    public init(method: String) {
        name = method
    }
    public init(method: String, args: Any) {
        name = method
        self.args = args
    }
    
    open var name: String
    open var args: Any?
}
