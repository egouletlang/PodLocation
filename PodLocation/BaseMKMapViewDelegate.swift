//
//  BaseMKMapViewDelegate.swift
//  PodLocation
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

public protocol BaseMKMapViewDelegate: NSObjectProtocol {
    func tapped(baseMKAnnotation: BaseMKAnnotation)
}
