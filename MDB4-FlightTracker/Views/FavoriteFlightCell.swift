//
//  FavoriteFlightCell.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/5/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit

class FavoriteFlightCell: UITableViewCell {
    @IBOutlet weak var airportTextView: UITextView!
    @IBOutlet weak var flightNumView: UILabel!
    @IBOutlet weak var flightSubtitleView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        airportTextView.layer.cornerRadius = 20
    }
}
