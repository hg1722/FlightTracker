//
//  AirportInfoVC-Map.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/5/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import MapKit
import UIKit

extension AirportInfoVC: MKMapViewDelegate {
  
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? AirportAnnotation else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
          as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        return view
      }
}
