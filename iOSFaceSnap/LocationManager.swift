//
//  LocationManager.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 20/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject
{
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var onLocationFix: ((CLPlacemark?, NSError?) -> Void)?
    
    override init()
    {
        super.init()
        manager.delegate = self
        
        getPermission()
        
    }
    
    private func getPermission()
    {
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Unresolved Error \(error), \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.first else { return }
        
        geocoder.reverseGeocodeLocation(location){ placemarks , error  in
            if let onLocationFix = self.onLocationFix
            {
                onLocationFix(placemarks?.first, error as NSError?)
            }
        }
    }
}
