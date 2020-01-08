//
//  AirportMapVC.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/1/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit
import MapKit

class AirportMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topCard: UIView!
    @IBOutlet weak var dataSourceView: UIButton!
    
    var airports: [Airport]!
    let regionRadius: CLLocationDistance = 10000000
    var airportAnnotations: [AirportAnnotation] = []
    var selectedAnnotation: AirportAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(title: nil, message: "Loading airports...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        topCard.bottomStylize(radius: 30, shadowRadius: 10)
        dataSourceView.layer.cornerRadius = 18
        
        //load airports
        dataSourceView.setTitle("Loading..", for: .normal)
        LufthansaAPIHelper.getAuthToken {
            LufthansaAPIHelper.getAllAirports { allAirports in
                self.airports = allAirports
                self.dataSourceView.setTitle("Lufthansa", for: .normal)
                self.populateMap()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func populateMap() {
        //add markers
        self.mapView.register(AirportAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        for airport in airports {
            let aa = AirportAnnotation(title: airport.airportName, locationName: airport.airportCode, coordinate: airport.coordinate)
            mapView.addAnnotation(aa)
            airportAnnotations.append(aa)
        }
        //let initialLocation = CLLocation(latitude: 37.0902, longitude: -95.7129)
        let initialLocation = CLLocation(latitude: 57.0928, longitude: 9.8492)
        self.centerMapOnLocation(location: initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "airportMapToInfo":
            let destinationVC = segue.destination as! AirportInfoVC
            destinationVC.airportAnnotation = selectedAnnotation
        default:
            break
        }
    }
}
