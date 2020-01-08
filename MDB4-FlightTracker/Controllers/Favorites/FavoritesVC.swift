//
//  FavoritesVC.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/1/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit
import SwiftyJSON

class FavoritesVC: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var selectedFlight: [String]!
    var outputFlight: Flight!
    var favoriteFlightsList: [String:[String]]!
    var favoriteFlightsData: [[String]] = []
    var currentIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorite Flights"
        self.favoritesTableView.rowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favoriteFlightsList = UserDefaults.standard.array(forKey: "FavoriteFlightList") as? [String:[String]]
        loadFavoriteFlights()
        favoritesTableView.reloadData()
    }
    
    func getCurrentDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    func loadFavoriteFlights() {
        favoriteFlightsData = []
        
        if var favoriteFlightList = UserDefaults.standard.array(forKey: "FavoriteFlightList") as? [String:[String]] {
            var keys = favoriteFlightsList.map { $0.key }
            for key in keys {
                favoriteFlightsData.append(favoriteFlightsList[key]!)
            }
            UserDefaults.standard.set(favoriteFlightList, forKey: "FavoriteFlightList")
        } else {
            let emptyArray = [String:[String]]()
            UserDefaults.standard.set(emptyArray, forKey: "FavoriteFlightList")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "favoritesToFlightInfo":
                let destinationVC = segue.destination as! FlightInfoVC
                destinationVC.flight = outputFlight
            default:
                break
        }
    }
}
