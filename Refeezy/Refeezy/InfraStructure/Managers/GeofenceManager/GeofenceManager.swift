//
//  GeofenceManager.swift
//  LocationServicesTask
//
//  Created by Sami Ahmed on 06/02/2025.
//

import CoreLocation
import MapKit

protocol GeofenceManagerDelegate: AnyObject {
    func didEnterGeofence(region: CLRegion)
    func didExitGeofence(region: CLRegion)
    func didUpdateGeofenceOverlay(circle: MKCircle)
}

final class GeofenceManager: NSObject {
    
    // MARK: - Singleton
    static let shared = GeofenceManager()
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    weak var delegate: GeofenceManagerDelegate?
    
    private var currentGeofence: CLCircularRegion?
    
    // MARK: - Initializer
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization() // Ensure Always permission for geofencing
    }
    
    // MARK: - Create Geofence
    func createGeofence(latitude: Double, longitude: Double, radius: Double = 500.0) {
        removeGeofence() // Remove existing geofence before adding a new one
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geofenceRegion = CLCircularRegion(center: center, radius: radius, identifier: "Geofence")
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: geofenceRegion)
        currentGeofence = geofenceRegion
        
        // Notify the delegate to update the map with the geofence overlay
        let circle = MKCircle(center: center, radius: radius)
        delegate?.didUpdateGeofenceOverlay(circle: circle)
    }
    
    // MARK: - Remove Geofence
    func removeGeofence() {
        if let geofence = currentGeofence {
            locationManager.stopMonitoring(for: geofence)
            currentGeofence = nil
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension GeofenceManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            delegate?.didEnterGeofence(region: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            delegate?.didExitGeofence(region: region)
        }
    }
}

