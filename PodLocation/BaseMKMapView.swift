//
//  BaseMKMapView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import MapKit
import BaseUtils

private let REGION_RADIUS: CLLocationDistance = 100
//private let testRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(0, 0), 1, 1)
private let M2DEG = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(0, 0), 1, 1).span.latitudeDelta

open class BaseMKMapView: MKMapView, MKMapViewDelegate {
    
    open weak var baseMKMapViewDelegate: BaseMKMapViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Config -
    open func initialize() {
        self.showsPointsOfInterest = self.getShowsPointsOfInterest()
        self.showsBuildings = self.getShowsBuildings()
        self.showsUserLocation = self.getShowsUserLocation()
        self.isZoomEnabled = self.getIsZoomEnabled()
        self.isScrollEnabled = self.getIsScrollEnabled()
        
        self.delegate = self
        
        LocationManager.registerForLocationUpdates(observer: self, selector: #selector(BaseMKMapView.currLocationUpdated))
        setupLocationManager()
    }
    
    open func getShowsPointsOfInterest() -> Bool { return true }
    open func getShowsBuildings() -> Bool { return true }
    open func getShowsUserLocation() -> Bool { return true }
    open func getIsZoomEnabled() -> Bool { return false }
    open func getIsScrollEnabled() -> Bool { return false }
    open func setupLocationManager() {
        LocationManager.setupForFitness(background: false)
    }
    
    open func start(callback: (UIAlertController)->Void) {
        LocationManager.instance.start(callback: callback)
    }
    
    open func centerMapOnLocation(location: CLLocation) {
        self.centerMapOnLocation(coordinate: location.coordinate)
    }
    open func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
                                                                  REGION_RADIUS * 2.0, REGION_RADIUS * 2.0)
        self.setRegion(coordinateRegion, animated: true)
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let a = annotation as? BaseMKAnnotation {
            let identifier = "pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if view == nil {
                view = MKPinAnnotationView(annotation: a, reuseIdentifier: identifier)
                view?.canShowCallout = true
                view?.calloutOffset = CGPoint(x: -5, y: 5)
                view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            view?.annotation = a
            return view
        }
        return nil
    }
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let a = view.annotation as? BaseMKAnnotation {
            self.baseMKMapViewDelegate?.tapped(baseMKAnnotation: a)
        }
    }
    
    open func currLocationUpdated() {
        ThreadHelper.executeOnMainThread {
            if let location = LocationManager.instance.getCurrentLocation() {
                self.centerMapOnLocation(location: location)
            }
        }
    }
    
}
