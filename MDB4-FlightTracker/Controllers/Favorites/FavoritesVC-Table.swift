//
//  FavoritesVC-Table.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/5/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteFlightsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFlightCell", for: indexPath) as! FavoriteFlightCell
        var flight = favoriteFlightsData[indexPath.row]
        cell.airportTextView.text = flight[2] + " > " + flight[3]
        cell.flightNumView.text = flight[0]
        cell.flightSubtitleView.text = flight[1]
        cell.timeView.text = flight[4]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFlight = favoriteFlightsData[indexPath.row]
        let alert = UIAlertController(title: nil, message: "Loading flight \(selectedFlight[0])...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        LufthansaAPIHelper.getAuthToken {
            LufthansaAPIHelper.getFlightStatus(flightNum: self.selectedFlight[0], date: self.selectedFlight[1]) { flt in
                self.outputFlight = flt
                LufthansaAPIHelper.getAirport(airportCode: self.selectedFlight[2]) { dAir in
                    self.outputFlight.departAirport = dAir
                    LufthansaAPIHelper.getAirport(airportCode: self.selectedFlight[3]) { aAir in
                        self.outputFlight.arriveAirport = aAir
                        LufthansaAPIHelper.getPlane(type: self.outputFlight.plane.number) { pln in
                            self.outputFlight.plane = pln
                            self.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: "favoritesToFlightInfo", sender: self)
                        }
                    }
                }
            }
        }
    }
}

