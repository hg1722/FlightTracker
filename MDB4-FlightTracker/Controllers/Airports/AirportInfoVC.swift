//
//  AirportInfoVC.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/1/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit
import MapKit

class AirportInfoVC: UIViewController {

    @IBOutlet weak var airportNameView: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flightTableView: UITableView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var airportAnnotation: AirportAnnotation!
    var arrivingFlights: [Flight] = []
    var departingFlights: [Flight] = []
    var displayedFlights: [Flight] = []
    var selectedFlight: Flight!
    var regionRadius: CLLocationDistance = 2000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = airportAnnotation.locationName
        airportNameView.text = airportAnnotation.title! + " Airport"
        cardView.topStylize(radius: 25, shadowRadius: 10)
        flightTableView.rowHeight = 80
        
        let alert = UIAlertController(title: nil, message: "Loading flights...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        populateMap()
        getFlights()
        
    }
    
    func getCurrentDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    @IBAction func onFlightTypeToggle(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
            case 0:
                displayedFlights = departingFlights
                flightTableView.reloadData()
            case 1:
                displayedFlights = arrivingFlights
                flightTableView.reloadData()
            default:
                break
        }
    }
    
    func getFlights() {
        var date = getCurrentDateFormatted() + "T12:00"
        LufthansaAPIHelper.getAuthToken() {
            LufthansaAPIHelper.getFlightsFrom(type: "departures", code: "\(self.airportAnnotation.locationName)", date: "\(date)") { departures in
                self.departingFlights += departures
                self.displayedFlights += departures
                
                LufthansaAPIHelper.getFlightsFrom(type: "arrivals", code: "\(self.airportAnnotation.locationName)", date: "\(date)") { arrivals in
                    self.arrivingFlights += arrivals
                    self.flightTableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func populateMap() {
        self.mapView.register(AirportAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotation(airportAnnotation)
        let coordinateRegion = MKCoordinateRegion(center: airportAnnotation.coordinate,
        latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "airportInfoToFlightInfo":
                let destinationVC = segue.destination as! FlightInfoVC
                destinationVC.flight = selectedFlight
            default:
                break
        }
    }
}
