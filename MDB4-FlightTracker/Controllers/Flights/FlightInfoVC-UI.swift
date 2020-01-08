//
//  FlightInfoVC-UiView.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/2/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit

extension UIView {
    func stylize(radius: CGFloat, shadowRadius: CGFloat) {
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        layer.shadowRadius = shadowRadius
    }
}
