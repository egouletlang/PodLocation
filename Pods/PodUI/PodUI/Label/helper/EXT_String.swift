//
//  EXT_String.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

public extension String {
    
    public func addTag(_ tag: String) -> String {
        return String(format: "<%@>%@</%@>", arguments: [tag, self, tag])
    }
    
    public func addColor(_ color: String) -> String {
        return String(format: "<font color=\"%@\">%@</font>", arguments: [color, self])
    }
    
}
