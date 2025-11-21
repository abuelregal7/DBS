//
//  AddressMapViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 18/04/2025.
//

import UIKit
import MapKit
import CoreLocation

class AddressMapViewController: BaseViewController, CLLocationManagerDelegate, LocationManagerDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var mapKit: MKMapView!
    
    let annotationLabel = UILabel(frame: CGRect(x: -40, y: -55, width: 150, height: 50))
    
    let locationManager = LocationServices.shared
    
    var long = ""
    var lat = ""
    var pinTitle = ""
    private var coordinates: CLLocationCoordinate2D?
    var address: String?
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupMapView()
        
        mapKit.isUserInteractionEnabled = true
        
        let guesture = UITapGestureRecognizer(target: self,
                                              action: #selector(didTapMap(_:)))
        guesture.numberOfTouchesRequired  = 1
        guesture.numberOfTapsRequired     = 1
        mapKit.addGestureRecognizer(guesture)
        
        reverseGeocodeLocation(CLLocation(latitude: coordinates?.latitude ?? 0, longitude: coordinates?.longitude ?? 0)) { [weak self] address in
            guard let self else { return }
            self.pinTitle = address
        }
        
    }
    
    override func bind() {
        super.bind()
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        cancelButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        confirmButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.present(TabsVCBuilder.addNewAddress(Reload: { [weak self] in
                    guard let self else { return }
                    self.dismiss(animated: true)
                }, address: self.address, city: self.city, lat: self.lat, long: self.long).viewController, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Setup Location Manager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestLocationAuthorization()
        locationManager.requestCurrentLocation()
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Setup Map View
    func setupMapView() {
        //mapView.frame = view.bounds
        mapKit.delegate = self
        mapKit.showsUserLocation = true
        
        let region = MKCoordinateRegion(center: locationManager.currentUserLocationPublisher.value, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapKit.setRegion(region, animated: true)
    }
    
    //MARK:- DidTapMap
    @objc func didTapMap( _ gesture: UITapGestureRecognizer) {
        
        let locationInView = gesture.location(in: mapKit)
        let coordinates = mapKit.convert(locationInView, toCoordinateFrom: mapKit)
        self.coordinates = coordinates
        self.lat = "\(coordinates.latitude)"
        self.long = "\(coordinates.longitude)"
        
        for annotation in mapKit.annotations {
            mapKit.removeAnnotation(annotation)
            
        }
        
        // when user select location we need to drop pin on that location
        let pin  = MKPointAnnotation()
        
        pin.coordinate = coordinates
        
        mapKit.addAnnotation(pin)
        
        reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { [weak self] address in
            guard let self else { return }
            self.pinTitle = address
        }
        pin.title = self.pinTitle
        
    }
    
    // MARK: - Reverse Geocoding
    func reverseGeocodeLocation(_ location: CLLocation, completion: @escaping (String) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            guard error == nil, let placeMark = placemarks?.first else {
                completion("Unknown location")
                return
            }
            
            var outputs = ""
            
            if let State = placeMark.administrativeArea {
                outputs = outputs + "\(State)"
            }
            
            if let Street = placeMark.thoroughfare {
                print(Street)
                outputs = outputs + "\(Street)"
            }
            // City
            if let City = placeMark.subAdministrativeArea {
                print(City)
                outputs = outputs + ",\(City)"
            }
            if let SubCity = placeMark.subLocality{
                print(SubCity)
            }
            if let SubCity2 = placeMark.locality{
                print(SubCity2)
            }
            // Zip code
            if let Zip = placeMark.isoCountryCode {
                print(Zip)
                outputs = outputs + ",\(Zip)"
            }
            // Country
            if let Country = placeMark.country {
                print(Country)
                outputs = outputs + ",\(Country)"
            }
            
            var output = [String]()
            
            if let street = placeMark.thoroughfare {
                output.append(street)
            }
            if let city = placeMark.subAdministrativeArea {
                output.append(city)
                self.city = city
            }
            if let countryCode = placeMark.isoCountryCode {
                output.append(countryCode)
            }
            if let country = placeMark.country {
                output.append(country)
            }
            self.address = output.joined(separator: ", ")
            print(output.joined(separator: ", "))
            completion(output.joined(separator: ", "))
        }
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        print("📍 Updated Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        // Center the map on the updated location
        setupMapView()
        
        self.lat = "\(location.coordinate.latitude)"
        self.long = "\(location.coordinate.longitude)"
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { [weak self] address in
            guard let self else { return }
            self.pinTitle = address
        }
        
        mapKit.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
    }
    
    func didFailWithError(_ error: Error) {
        print("❌ Location Error: \(error.localizedDescription)")
    }
    
}

//MARK:- MapKitVC : MKMapViewDelegate
extension AddressMapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "marker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            //annotationView?.markerTintColor = .systemBlue // Customize tint if you want
            annotationView?.glyphImage = UIImage(named: "locationPin") // Optional image
        } else {
            annotationView?.annotation = annotation
        }
        
        // Add custom label
        annotationLabel.numberOfLines = 0
        annotationLabel.textAlignment = .center
        annotationLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        annotationLabel.backgroundColor = UIColor.white
        annotationLabel.layer.borderWidth = 0.5
        annotationLabel.layer.borderColor = UIColor.black.cgColor
        annotationLabel.layer.cornerRadius = 10
        annotationLabel.clipsToBounds = true
        annotationLabel.text = annotation.title ?? ""
        
        annotationView?.addSubview(annotationLabel)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        UIView.animate(withDuration: 0.1) {
            // the view that will hold the annotations data
            self.view.layoutIfNeeded()
        }
        
    }
    
}
