//
//  MultiLineTextInputRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/22/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

private let ID = "MultiLineTextInputRowModel"
open class MultiLineTextInputRowModel: BaseTextInputRowModel {
    
    open class func isMultiLineTextInputRowModel(id: String) -> Bool {
        return id == ID
    }
    open override func getId() -> String {
        return ID
    }
}
