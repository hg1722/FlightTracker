//
//  AirportAnnotationView.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/3/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import Foundation
import MapKit

class AirportAnnotationMarkerView: MKMarkerAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let aa = newValue as? AirportAnnotation else { return }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

//      markerTintColor = aa.markerTintColor
//        if let imageName = aa.imageName {
//          glyphImage = UIImage(named: imageName)
//        } else {
//          glyphImage = nil
//      }
    }
  }

}

class AirportAnnotationView: MKAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let aa = newValue as? AirportAnnotation else {return}

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
        size: CGSize(width: 30, height: 30)))
//        mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
      rightCalloutAccessoryView = mapsButton

//      if let imageName = aa.imageName {
//        image = UIImage(named: imageName)
//      } else {
//        image = nil
//      }

      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailLabel.text = aa.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }

}
