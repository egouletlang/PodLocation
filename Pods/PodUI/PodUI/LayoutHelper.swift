//
//  LayoutHelper.swift
//  BaseUtilityClasses
//
//  Created by Etienne Goulet-Lang on 8/17/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import CoreGraphics

public class LayoutHelper {
    
    public static var onePixel: CGFloat = {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            let scale = UIScreen.main.scale
            if scale != 0 {
                return 1.0 / scale
            }
        }
        return 1.0
    }()
}
