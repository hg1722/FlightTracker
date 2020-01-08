//
//  Flight.swift
//  LufthansaMP4Skeleton
//
//  Created by Max Miranda on 3/2/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//

import Foundation
import SwiftyJSON

class Flight {
    var flightNumber: String!
    var valid: Bool!
    var status: String!
    var date: String!
    
    var departAirport: Airport!
    var arriveAirport: Airport!
    
    var departGate: String!
    var arriveGate: String!

    var departTerminal: String!
    var arriveTerminal: String!
    
    var departScheduled: String!
    var arriveScheduled: String!

    var departActual: String!
    var arriveActual: String!
    
    var plane: Airplane!
    var favorite: Bool!
    
    var rawJSON: String!
    
    init(data: JSON) {
        rawJSON = data.rawString()
        date = data["Departure"]["ScheduledTimeLocal"]["DateTime"].stringValue.components(separatedBy: "T")[0]
        flightNumber = data["MarketingCarrier"]["AirlineID"].stringValue + data["MarketingCarrier"]["FlightNumber"].stringValue
        valid = true
        plane = Airplane(number: data["Equipment"]["AircraftCode"].stringValue)
        status = data["FlightStatus"]["Definition"].stringValue
        departAirport = Airport(code: data["Departure"]["AirportCode"].stringValue)
        arriveAirport = Airport(code: data["Arrival"]["AirportCode"].stringValue)
        
        departGate = data["Departure"]["Terminal"]["Gate"].stringValue
        if departGate == "" {
            departGate = "n/a"
        }
        
        arriveGate = data["Arrival"]["Terminal"]["Gate"].stringValue
        if arriveGate == "" {
            arriveGate = "n/a"
        }
        
        departTerminal = data["Departure"]["Terminal"]["Name"].stringValue
        if departTerminal == "" {
            departTerminal = "n/a"
        }
        
        arriveTerminal = data["Arrival"]["Terminal"]["Name"].stringValue
        if arriveTerminal == "" {
            arriveTerminal = "n/a"
        }
        
        departScheduled = data["Departure"]["ScheduledTimeLocal"]["DateTime"].stringValue
        arriveScheduled = data["Arrival"]["ScheduledTimeLocal"]["DateTime"].stringValue

        departActual = data["Departure"]["ActualTimeLocal"]["DateTime"].stringValue
        if departActual == "" {
            departActual = "n/a"
        }
        
        arriveActual = data["Arrival"]["ActualTimeLocal"]["DateTime"].stringValue
        if arriveActual == "" {
            arriveActual = "n/a"
        }
        favorite = false
    }
    
    init(valid: Bool) {
        self.valid = valid
    }
}
