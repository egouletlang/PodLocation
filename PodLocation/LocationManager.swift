//
//  LocationManager.swift
//  PodLocation
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreLocation
import BaseUtils

open class LocationManager: NSObject, CLLocationManagerDelegate {

    //MARK: - Notifications -
    open static let NEW_LOCATION_NOTIFICATION = "notification://new_location"
    open class func registerForLocationUpdates(observer: Any, selector: Selector) {
        let notificationName = NSNotification.Name(rawValue: LocationManager.NEW_LOCATION_NOTIFICATION)
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: notificationName,
                                               object: nil)
    }
    
    
    //MARK: - Builders -
    open class func setupWhileInUse(activityType: CLActivityType) {
        LocationManager.instance = LocationManager(mode: .WhileInUse, activityType: activityType)
    }
    
    open class func setupAlwaysOn(activityType: CLActivityType) {
        LocationManager.instance = LocationManager(mode: .AlwaysOn, activityType: activityType)
    }
    
    open class func setupDefault(background: Bool = false) {
        background ? setupAlwaysOn(activityType: .other) : setupWhileInUse(activityType: .other)
    }
    
    open class func setupForCarNavigation(background: Bool = false) {
        background ? setupAlwaysOn(activityType: .automotiveNavigation) : setupWhileInUse(activityType: .automotiveNavigation)
    }
    
    open class func setupForPedestrianNavigation(background: Bool = false) {
        background ? setupAlwaysOn(activityType: .fitness) : setupWhileInUse(activityType: .fitness)
    }
    
    open class func setupForFitness(background: Bool = false) {
        background ? setupAlwaysOn(activityType: .fitness) : setupWhileInUse(activityType: .fitness)
    }
    
    //MARK: - Shared Instance -
    open static var instance: LocationManager!
    
    //MARK: - Location Services Mode -
    public enum Mode {
        case AlwaysOn
        case WhileInUse
    }
    
    public enum State {
        case Success
        case WrongMode
        case Error
    }
    
    //MARK: - Private Constructor -
    override private init() { super.init() }
    private init(mode: Mode, activityType: CLActivityType) {
        super.init()
        self.mode = mode
        self.activityType = activityType
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 200
        manager.delegate = self
    }
    
    private var mode = Mode.WhileInUse
    private var activityType = CLActivityType.other
    
    private var manager: CLLocationManager!
    
    //MARK: - Control Functions -
    open func start(callback: (UIAlertController)->Void) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            (self.mode == .AlwaysOn) ?  manager.requestAlwaysAuthorization() :
                                        manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            callback(LocationManager.buildOpenSettingsViewController(currentMode: "Disabled",
                                                                     desiredMode: (self.mode == .AlwaysOn) ? "Always" : "While In Use"))
        case .authorizedAlways:
            if (self.mode != .AlwaysOn) {
                callback(LocationManager.buildOpenSettingsViewController(currentMode: "Always",
                                                                         desiredMode: "While In Use"))
            } else {
                manager.startUpdatingLocation()
            }
        case .authorizedWhenInUse:
            if (self.mode == .AlwaysOn) {
                callback(LocationManager.buildOpenSettingsViewController(currentMode: "While In Use",
                                                                         desiredMode: "Always"))
            } else {
                manager.startUpdatingLocation()
            }
        }
    }
    
    open class func buildOpenSettingsViewController(currentMode: String, desiredMode: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Background Location \(currentMode)",
            message: "Please open this app's settings and set location access to '\(desiredMode)'.",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        return alertController
    }
    
    //MARK: - CLLocationManagerDelegate Methods -
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let accurateLocations = locations.flatMap() { $0.horizontalAccuracy > 0 ? $0 : nil }
        
        let numberOfLocation = Double(accurateLocations.count)
        
        let avgLatitude = (accurateLocations.reduce(0) { $0 + $1.coordinate.latitude }) / numberOfLocation
        let avgLongitude = accurateLocations.reduce(0) { $0 + $1.coordinate.longitude } / numberOfLocation
        let avgAltitude = accurateLocations.reduce(0) { $0 + $1.altitude } / numberOfLocation
        let avgHorzAccuracy = accurateLocations.reduce(0) { $0 + $1.horizontalAccuracy } / numberOfLocation
        let avgVertAccuracy = accurateLocations.reduce(0) { $0 + $1.verticalAccuracy } / numberOfLocation
        let avgCourse = accurateLocations.reduce(0) { $0 + $1.course } / numberOfLocation
        let avgSpeed = accurateLocations.reduce(0) { $0 + $1.speed } / numberOfLocation
        
        let date = Date(timeIntervalSinceNow: 0)
        
        currentLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude),
                  altitude: avgAltitude,
                  horizontalAccuracy: avgHorzAccuracy,
                  verticalAccuracy: avgVertAccuracy,
                  course: avgCourse,
                  speed: avgSpeed,
                  timestamp: date)
        
        print("got new location callback")
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: LocationManager.NEW_LOCATION_NOTIFICATION),
            object: nil)
        
    }
    
    private var currentLocation: CLLocation?
    
    open func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    open func getCurrentAddress() -> CLPlacemark? {
        return AsyncToSync(timeout: 10).start() { (async2sync) in
            if let curr = self.currentLocation {
                CLGeocoder().reverseGeocodeLocation(curr) { (places, error) -> Void in
                    async2sync.result = places?.first
                }
            } else {
                async2sync.result = nil
            }
        }
    }
    
    open func getCurrentAddress(callback: @escaping (CLPlacemark?) -> Void) {
        if let curr = self.currentLocation {
            CLGeocoder().reverseGeocodeLocation(curr) { (places, error) -> Void in
                callback(places?.first)
            }
        }
    }
}
