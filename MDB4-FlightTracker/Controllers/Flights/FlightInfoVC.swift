//
//  FlightInfoVC.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/1/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit
import MapKit


class FlightInfoVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dAirportView: UIButton!
    @IBOutlet weak var dTimeView: UILabel!
    @IBOutlet weak var dPrevTime: UILabel!
    @IBOutlet weak var dTerminalView: UILabel!
    @IBOutlet weak var dGateView: UILabel!
    @IBOutlet weak var aAirportView: UIButton!
    @IBOutlet weak var aTimeView: UILabel!
    @IBOutlet weak var aPrevTime: UILabel!
    @IBOutlet weak var flightNumView: UILabel!
    @IBOutlet weak var statusView: UILabel!
    @IBOutlet weak var aircraftView: UILabel!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    
    var flight: Flight?
    var annotations: [AirportAnnotation]!
    var selectedAnnotation: AirportAnnotation!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = flight!.flightNumber + "(\(flight!.date!))"
        cardView.stylize(radius: 25, shadowRadius: 10)
        dAirportView.layer.cornerRadius = 8
        aAirportView.layer.cornerRadius = 8
        loadFavoritesButton()
        populateFlightData()
        populateMap()
    }
    
    @IBAction func onDAirportPress(_ sender: Any) {
        selectedAnnotation = AirportAnnotation(title: flight!.departAirport.airportName, locationName: flight!.departAirport.airportCode, coordinate: flight!.departAirport.coordinate)
        performSegue(withIdentifier: "flightInfoToAirportInfo", sender: self)
    }
    @IBAction func onAAirportPress(_ sender: Any) {
        selectedAnnotation = AirportAnnotation(title: flight!.arriveAirport.airportName, locationName: flight!.arriveAirport.airportCode, coordinate: flight!.arriveAirport.coordinate)
        performSegue(withIdentifier: "flightInfoToAirportInfo", sender: self)
    }
    
    @IBAction func onFavoritePress(_ sender: Any) {
        if var favoriteFlightList = UserDefaults.standard.array(forKey: "FavoriteFlightList") as? [String:[String]] {
            if flight!.favorite {
                favoriteFlightList[flight!.flightNumber + "/" + flight!.date] = [flight!.flightNumber, flight!.date, flight!.departAirport.airportCode, flight!.arriveAirport.airportCode, flight!.departScheduled.components(separatedBy: "T")[1]]
                favoritesButton.image = UIImage(systemName: "heart.fill")
                print(favoriteFlightList)
            }
            else {
                favoriteFlightList.removeValue(forKey: flight!.flightNumber + "/" + flight!.date)
                favoritesButton.image = UIImage(systemName: "heart")
                print(favoriteFlightList)
            }
            flight!.favorite = !(flight!.favorite)
            print(flight!.favorite)
            UserDefaults.standard.set(favoriteFlightList, forKey: "FavoriteFlightList")
        } else {
            let emptyArray = [String:[String]]()
            UserDefaults.standard.set(emptyArray, forKey: "FavoriteFlightList")
        }
    }
    
    func loadFavoritesButton() {
        if var favoriteFlightList = UserDefaults.standard.array(forKey: "FavoriteFlightList") as? [String:[String]] {
            if favoriteFlightList[flight!.flightNumber + "/" + flight!.date] != nil {
                flight!.favorite = true
                favoritesButton.image = UIImage(systemName: "heart-fill")
            }
            else {
                flight!.favorite = false
                favoritesButton.image = UIImage(systemName: "heart")
            }
        } else {
            let emptyArray = [String:[String]]()
            print(emptyArray)
            UserDefaults.standard.set(emptyArray, forKey: "FavoriteFlightList")
        }
        favoritesButton.isEnabled = true
    }
    
    func populateFlightData() {
        dAirportView.setTitle(flight!.departAirport.airportCode, for: .normal)
        aAirportView.setTitle(flight!.arriveAirport.airportCode, for: .normal)
        dTimeView.text = flight!.departScheduled.components(separatedBy: "T")[1]
        dPrevTime.text = " "
        aTimeView.text = flight!.arriveScheduled.components(separatedBy: "T")[1]
        aPrevTime.text = " "
        if flight!.departActual != "n/a" {
            dTimeView.text = flight!.departActual.components(separatedBy: "T")[1]
            dPrevTime.text = "(was " + flight!.departScheduled.components(separatedBy: "T")[1] + ")"
        }
        if flight!.arriveActual != "n/a" {
            aTimeView.text = flight!.arriveActual.components(separatedBy: "T")[1]
            aPrevTime.text = "(was " + flight!.arriveScheduled.components(separatedBy: "T")[1] + ")"
        }
        dTerminalView.text = flight!.departTerminal
        dGateView.text = flight!.departGate
        flightNumView.text = flight!.flightNumber
        if flight!.status == "No status" {
            statusView.text = "None"
        }
        else {
            statusView.text = flight!.status.components(separatedBy: " ")[1]
        }
        //might not work for all airplane names, be sure to check this
        aircraftView.text = flight!.plane.planeName.components(separatedBy: " ")[0] + " " + flight!.plane.planeName.components(separatedBy: " ")[1]
    }
    
    func populateMap() {
        //add markers
        self.mapView.register(AirportAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        annotations = [AirportAnnotation]()
        let dAnnotation = AirportAnnotation(title: flight!.departAirport.airportName, locationName: flight!.departAirport.airportCode, coordinate: flight!.departAirport.coordinate)
        mapView.addAnnotation(dAnnotation)
        annotations.append(dAnnotation)
        
        let aAnnotation = AirportAnnotation(title: flight!.arriveAirport.airportName, locationName: flight!.arriveAirport.airportCode, coordinate: flight!.arriveAirport.coordinate)
        mapView.addAnnotation(aAnnotation)
        annotations.append(aAnnotation)
        
        var zoomRect = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect = zoomRect.union(pointRect);
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
        
        //add line connecting markers
        var coords = annotations.map { $0.coordinate }
        let routeLine = MKPolyline(coordinates: coords, count:2)
        mapView.addOverlay(routeLine)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "flightInfoToAirportInfo":
                let destinationVC = segue.destination as! AirportInfoVC
                destinationVC.airportAnnotation = selectedAnnotation
            default:
                break
        }
    }
}
