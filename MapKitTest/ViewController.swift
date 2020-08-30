//
//  ViewController.swift
//  MapKitTest
//
//  Created by KenYurino on 2020/08/29.
//  Copyright © 2020 KenYurino. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
  var locationManager: CLLocationManager!

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var buttonLocation: UIButton!
  @IBOutlet weak var searchBar: UISearchBar!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    mapView.showsUserLocation = true
    searchBar.delegate = self
  }

  @IBAction func tapLocation(_ sender: Any) {
    locationManager.startUpdatingLocation()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    CLGeocoder().geocodeAddressString((searchBar.text)!) { placemarks, error in
      if error != nil {
        return
      }
      if let placemark = placemarks?[0] {
        self.setMapviewRegion(location: (placemark.location?.coordinate)!)
      }
      searchBar.endEditing(true)
    }
  }

  func setMapviewRegion(location: CLLocationCoordinate2D) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegion(
        center: location, latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    setMapviewRegion(location: (locations.last?.coordinate)!)
  }
}
