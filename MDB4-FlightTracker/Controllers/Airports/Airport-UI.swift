//
//  AirportMacVC-UI.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/3/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit

extension UIView {
    func bottomStylize(radius: CGFloat, shadowRadius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = shadowRadius
    }
    
    func topStylize(radius: CGFloat, shadowRadius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = shadowRadius
    }
}
