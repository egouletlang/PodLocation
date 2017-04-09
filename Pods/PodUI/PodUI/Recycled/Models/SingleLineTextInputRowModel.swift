//
//  SingleLineTextInputRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/22/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

private let ID = "SingleLineTextInputRowModel"
open class SingleLineTextInputRowModel: BaseTextInputRowModel {
    open class func isSingleLineTextInputRowModel(id: String) -> Bool {
        return id == ID
    }
    
    open override func getId() -> String {
        return ID
    }
    
    // Corresponds to UITextInput.autocorrectionType. Set to nil for UITextAutocorrectionTypeDefault
    open var password: Bool? = nil
    open var capitalize: Bool? = nil
    open func with(password b: Bool?) -> SingleLineTextInputRowModel {
        self.password = b
        return self
    }
    open func with(capitalize b: Bool?) -> SingleLineTextInputRowModel {
        self.capitalize = b
        return self
    }
}
