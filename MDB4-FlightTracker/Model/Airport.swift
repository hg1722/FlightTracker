//
//  Airport.swift
//  LufthansaMP4Skeleton
//
//  Created by shaina on 10/11/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Airport: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var airportName: String!
    var airportCode: String!
    
    init(code: String) {
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.airportCode = code
    }
    
    //for given location
    init(lat: Float, lon: Float, code: String, name: String) {
        //config location
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lon)!)
        //config airport information
        self.airportName = name
        self.airportCode = code
    }
}
