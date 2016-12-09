//
//  LocationManager.swift
//  PodLocation
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreLocation

open class LocationManager: NSObject, CLLocationManagerDelegate {

    //MARK: - Builders -
    open class func setupWhileInUse(activityType: CLActivityType) -> LocationManager {
        LocationManager.instance = LocationManager(mode: .WhileInUse, activityType: activityType)
        return LocationManager.instance
    }
    
    open class func setupAlwaysOn(activityType: CLActivityType) -> LocationManager {
        LocationManager.instance = LocationManager(mode: .AlwaysOn, activityType: activityType)
        return LocationManager.instance
    }
    
    open class func setupDefault(background: Bool = false) -> LocationManager {
        return background ? setupAlwaysOn(activityType: .other) : setupWhileInUse(activityType: .other)
    }
    
    open class func setupForCarNavigation(background: Bool = false) -> LocationManager {
        return background ? setupAlwaysOn(activityType: .automotiveNavigation) : setupWhileInUse(activityType: .automotiveNavigation)
    }
    
    open class func setupForPedestrianNavigation(background: Bool = false) -> LocationManager {
        return background ? setupAlwaysOn(activityType: .fitness) : setupWhileInUse(activityType: .fitness)
    }
    
    open class func setupForFitness(background: Bool = false) -> LocationManager {
        return background ? setupAlwaysOn(activityType: .fitness) : setupWhileInUse(activityType: .fitness)
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
        print("\(locations)")
    }
}
