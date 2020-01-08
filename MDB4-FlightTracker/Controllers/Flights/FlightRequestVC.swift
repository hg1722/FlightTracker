//
//  FlightRequestVC.swift
//  MDB4-FlightTracker
//
//  Created by Henry Gu on 1/1/20.
//  Copyright © 2020 Henry Gu. All rights reserved.
//

import UIKit

class FlightRequestVC: UIViewController {

    @IBOutlet weak var flightField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var invalidMessage: UILabel!
    
    var requestedFlight: Flight!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.invalidMessage.text = ""
    }
    
    func setupFields() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        flightField.setBorder(width: 2, color: UIColor.white)
        dateField.setBorder(width: 2, color: UIColor.white)
        flightField.setCorner(radius: 25)
        dateField.setCorner(radius: 25)
        flightField.textAlignment = .center
        dateField.textAlignment = .center
        dateField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        invalidMessage.text = ""
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        if flightField.isEditing {
            view.endEditing(true)
            checkComplete()
        }
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "yyyy-MM-dd"
            self.dateField.text = dateformatter.string(from: datePicker.date)
            checkComplete()
        }
        self.dateField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FlightInfoVC
        destinationVC.flight = requestedFlight
    }
    
    func checkComplete() {
        if !flightField.text!.isEmpty && !dateField.text!.isEmpty{
            print("running api")
            self.invalidMessage.text = "loading flight..."
            LufthansaAPIHelper.getAuthToken {
                LufthansaAPIHelper.getFlightStatus(flightNum: self.flightField.text!, date: self.dateField.text!, completion: ({flt in
                    if !flt.valid {
                        self.invalidMessage.text = "Invalid flight. Please try again."
                    }
                    else {
                        self.requestedFlight = flt
                        LufthansaAPIHelper.getAirport(airportCode: self.requestedFlight!.departAirport.airportCode!) { dAir in
                            self.requestedFlight.departAirport = dAir
                            LufthansaAPIHelper.getAirport(airportCode: self.requestedFlight!.arriveAirport.airportCode!) { aAir in
                                self.requestedFlight.arriveAirport = aAir
                                LufthansaAPIHelper.getPlane(type: self.requestedFlight!.plane!.number) { pln in
                                    self.requestedFlight.plane = pln
                                    self.performSegue(withIdentifier: "flightRequestToInfo", sender: self)
                                }
                            }
                        }
                    }
                }))
            }
        }
    }
    
}
