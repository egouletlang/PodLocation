//
//  BaseUIViewDelegate.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol BaseUIViewDelegate: NSObjectProtocol {
    @objc optional func getVc()-> UIViewController?
    @objc optional func presentVC(_ vc: UIViewController, animated: Bool)
    @objc optional func dismissVC(_ animated: Bool)
}
