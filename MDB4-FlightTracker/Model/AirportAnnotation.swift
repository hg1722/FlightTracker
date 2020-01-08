//
//  AirportAnnotation.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/3/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import Foundation
import MapKit

class AirportAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D

    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
      self.title = title
      self.locationName = locationName
      self.coordinate = coordinate
    }

    var subtitle: String? {
      return locationName
    }
}
