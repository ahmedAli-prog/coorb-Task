//
//  LocationManager.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    private func getCountry(from location: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let country = placemark.country {
                self?.delegate?.didGetLocation(country: country)
            }
        }
    }
}

//MARK: - LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {

    func requestLocation() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        getCountry(from: location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("Location authorization not determined.")
        case .restricted, .denied:
            delegate?.didGetLocation(country: Constants.CountryList.defaultCountry)
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Unknown location authorization status.")
        }
    }
}
