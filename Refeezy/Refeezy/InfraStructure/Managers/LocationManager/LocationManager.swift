//
//  LocationManager.swift
//  LocationServicesTask
//
//  Created by Sami Ahmed on 05/02/2025.
//

import UIKit
import Combine
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
    func didFailWithError(_ error: Error)
}

final class LocationServices: NSObject {
    
    // MARK: - SINGLETON
    static let shared = LocationServices()
    
    weak var delegate: LocationManagerDelegate?
    
    // MARK: - PROPIRIES
    private let locationManager = CLLocationManager()
    var autoUpdateLocation: Bool = false
    private var cancellable = Set<AnyCancellable>()
    let currentUserLocation = PassthroughSubject<CLLocationCoordinate2D, Never>()
    let currentUserLocationPublisher = CurrentValueSubject<CLLocationCoordinate2D, Never>(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var lastUserLocation: CLLocationCoordinate2D?
    
    
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    
    // MARK: - INIZIALIZER
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - SETUP METHODS
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAuthorization()
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - PUBLIC METHODS
    func requestCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startMonitoringLocation(cLRegion: CLRegion) {
        locationManager.startMonitoring(for: cLRegion)
    }
    
    func checkUserForAccuracy() {
        let accuracyStatus = locationManager.accuracyAuthorization
        if accuracyStatus == .reducedAccuracy {
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "AccuracyFeature", completion: { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    self.locationManager.startUpdatingLocation()
                }
            })
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationServices: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentUserLocation.send(location.coordinate)
        currentUserLocationPublisher.send(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
        lastUserLocation = location.coordinate
        guard !autoUpdateLocation else { return }
        //locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        
        delegate?.didUpdateLocation(location) // Notify delegate
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error) // Notify delegate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager().authorizationStatus
        switch status {
        case .denied:
            showLocationAlert(title: "Location Access Denied", message: "To use location-based features, please enable location services in Settings.")
        case .restricted:
            showLocationAlert(title: "Location Restricted", message: "Location services are restricted on your device.")
        case .authorizedWhenInUse, .authorizedAlways:
            checkUserForAccuracy()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

//MARK: - LOCATION DENIED CASE ALERT
extension LocationServices {
    
    func showLocationAlert(title: String, message: String) {
        guard let rootVC = UIApplication.shared.rootViewController else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { [self] _ in
            openLocationSettings()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        rootVC.present(alert, animated: true)
    }
    
    private  func openLocationSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else { return }
        UIApplication.shared.open(settingsUrl)
    }
}

// MARK: - Get Placemark
extension LocationServices {
    
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                //print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                //print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}

extension UIApplication {
    var rootViewController: UIViewController? {
        (connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
    }
}
