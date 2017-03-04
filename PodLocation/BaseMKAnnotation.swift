//
//  BaseMKAnnotation.swift
//  PodLocation
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import MapKit

open class BaseMKAnnotation: NSObject, MKAnnotation {
    
    public override init() {
        super.init()
    }
    
    public init(lat: Double, lon: Double, title: String?, subTitle: String?, clickResponse: AnyObject?) {
        super.init()
        self.setCoordinate(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        self.setTitle(title: title)
        self.setSubTitle(subTitle: subTitle)
        self.setClickResponse(clickResponse: clickResponse)
    }
    
    public var coordinate = CLLocationCoordinate2D()
    
    open func withCoordinate(lat: Double, lon: Double) -> BaseMKAnnotation {
        return self.withCoordinate(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
    }
    open func withCoordinate(coordinate: CLLocationCoordinate2D) -> BaseMKAnnotation {
        self.setCoordinate(coordinate: coordinate)
        return self
    }
    open func setCoordinate(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    public var title: String?
    open func withTitle(title: String?) -> BaseMKAnnotation {
        self.setTitle(title: title)
        return self
    }
    open func setTitle(title: String?) {
        self.title = title
    }
    
    public var subtitle: String?
    open func withSubTitle(subTitle: String?) -> BaseMKAnnotation {
        self.setSubTitle(subTitle: subTitle)
        return self
    }
    open func setSubTitle(subTitle: String?) {
        self.subtitle = subTitle
    }
    
    open var clickResponse: AnyObject?
    open var longPressResponse: AnyObject?
    open func withClickResponse(clickResponse: AnyObject?) -> BaseMKAnnotation {
        self.setClickResponse(clickResponse: clickResponse)
        return self
    }
    open func setClickResponse(clickResponse: AnyObject?) {
        self.clickResponse = clickResponse
    }
    
    
}
