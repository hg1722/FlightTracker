//
//  AirportInfoVC-Table.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/4/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit

extension AirportInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedFlights.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as! FlightCell
        let flight: Flight
        flight = displayedFlights[indexPath.row]
        
        //set to departures
        if segmentControl.selectedSegmentIndex == 0 {
            cell.directionLabel.text = "To"
            cell.airportTextView.text = flight.arriveAirport.airportCode
            cell.flightNumView.text = flight.flightNumber
            cell.flightSubtitleView.text = "arriving at " + flight.arriveScheduled.components(separatedBy: "T")[1]
            cell.timeView.text = flight.departScheduled.components(separatedBy: "T")[1]
        }
        //set to arrivals
        else {
           cell.directionLabel.text = "From"
            cell.airportTextView.text = flight.departAirport.airportCode
            cell.flightNumView.text = flight.flightNumber
            cell.flightSubtitleView.text = "departed at " + flight.departScheduled.components(separatedBy: "T")[1]
            cell.timeView.text = flight.arriveScheduled.components(separatedBy: "T")[1]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFlight = displayedFlights[indexPath.row]
        let alert = UIAlertController(title: nil, message: "Loading flight \(selectedFlight.flightNumber!)...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        LufthansaAPIHelper.getAuthToken {
            LufthansaAPIHelper.getAirport(airportCode: self.selectedFlight!.departAirport.airportCode!) { dAir in
                self.selectedFlight.departAirport = dAir
                LufthansaAPIHelper.getAirport(airportCode: self.selectedFlight!.arriveAirport.airportCode!) { aAir in
                    self.selectedFlight.arriveAirport = aAir
                    LufthansaAPIHelper.getPlane(type: self.selectedFlight!.plane!.number) { pln in
                        self.selectedFlight.plane = pln
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "airportInfoToFlightInfo", sender: self)
                    }
                }
            }
        }
    }
}
