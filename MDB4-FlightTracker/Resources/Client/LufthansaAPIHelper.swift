//
//  LufthansaAPIHelper.swift
//  LufthansaAPITest
//
//  Created by Will Oakley on 9/13/18.
//  Copyright © 2018 Will Oakley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LufthansaAPIHelper {
    
    //These are where we will store all of the authentication information. Get these from your account at developer.lufthansa.com.
    static let clientSecret = "8k9gc2zeyk6krxqqjjxyv9qu"
    static let clientID = "eZAVCpsMRN"
    
    //This variable will store the session's auth token that we will get from getAuthToken()
    static var authToken: String?
    
    //This function will request an auth token from the lufthansa servers
    static func getAuthToken(completion: @escaping () -> ()){
        
        let headers = [
          "User-Agent": "PostmanRuntime/7.19.0",
          "Accept": "*/*",
          "Cache-Control": "no-cache",
          "Postman-Token": "cc784c0b-09d7-4a84-9383-2784c7c380d0,16ccc849-0135-4bd5-a849-b85a058b2cff",
          "Host": "api.lufthansa.com",
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept-Encoding": "gzip, deflate",
          "Content-Length": "89",
          "Connection": "keep-alive",
          "cache-control": "no-cache"
        ]

        let postData = NSMutableData(data: "client_id=8k9gc2zeyk6krxqqjjxyv9qu".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=eZAVCpsMRN".data(using: String.Encoding.utf8)!)
        postData.append("&grant_type=client_credentials".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.lufthansa.com/v1/oauth/token")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    // Print out dictionary
                    self.authToken = json["access_token"] as? String
                    print("Auth token: " + self.authToken!)
                    completion()
               }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })

        dataTask.resume()
    }
    
    //This function will get the status for a flight. FlightNum format "LHXXX" Date format "YYYY-MM-DD"
    static func getFlightStatus(flightNum: String, date: String, completion: @escaping ((Flight) -> ())){
        //Request URL and authentication parameters
        let requestURL = "https://api.lufthansa.com/v1/operations/flightstatus\(flightNum)/\(date)"
        let parameters: HTTPHeaders = ["Authorization": "Bearer \(self.authToken!)", "Accept": "application/json"]
        
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            //Makes sure that response is valid
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            //Creates JSON object
            let json = JSON(response.result.value!) //FIXME
            if json["ProcessingErrors"] == JSON.null {
                let data = json["FlightStatusResource"]["Flights"]["Flight"][0]
                let flight = Flight(data: data)
                completion(flight)
            }
            else {
                let flight = Flight(valid: false)
                completion(flight)
            }
        }
    }
    
    static func getAirport(airportCode: String, completion: @escaping (Airport) -> ()) {
        let requestURL = "https://api.lufthansa.com/v1/mds-references/airports/\(airportCode)?lang=en"
        let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization" : "Bearer \(self.authToken!)"]

        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            let json = JSON(response.result.value)
            let name = json["AirportResource"]["Airports"]["Airport"]["Names"]["Name"]["$"].stringValue
            let lat = json["AirportResource"]["Airports"]["Airport"]["Position"]["Coordinate"]["Latitude"].floatValue
            let lon = json["AirportResource"]["Airports"]["Airport"]["Position"]["Coordinate"]["Longitude"].floatValue
            let airport = Airport(lat: lat, lon: lon, code: airportCode, name: name)
            completion(airport)
        }
    }
    
    static func getPlane(type: String, completion: @escaping (Airplane) -> ()) {
        let requestURL = "https://api.lufthansa.com/v1/mds-references/aircraft/\(type)"
        print(requestURL)
        let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization" : "Bearer \(self.authToken!)"]
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            let json = JSON(response.result.value)
            let airplane = Airplane(number: type)
            var name = type
            if json["AircraftResource"]["AircraftSummaries"]["AircraftSummary"]["Names"]["Name"]["$"] != JSON.null {
                name = json["AircraftResource"]["AircraftSummaries"]["AircraftSummary"]["Names"]["Name"]["$"].stringValue
            }
            airplane.planeName = name
            completion(airplane)
        }
        
    }
    
    static func getAllAirports(closure: @escaping ([Airport]) -> ()) {
        
        let requestURL = "https://api.lufthansa.com/v1/mds-references/airports/?limit=20&offset=300&LHoperated=1"
        let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization" : "Bearer \(self.authToken!)"]
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            let jsonObject = JSON(response.result.value)
            var airports: [Airport] = []
            for i in 0...20 {
                let code = jsonObject["AirportResource"]["Airports"]["Airport"][i]["AirportCode"].stringValue
                let nameContainer = jsonObject["AirportResource"]["Airports"]["Airport"][i]["Names"]["Name"]
                var name: String!
                if nameContainer["$"] == JSON.null {
                    name = nameContainer[0]["$"].stringValue
                }
                else {
                    name = nameContainer["$"].stringValue
                }
                let lat = jsonObject["AirportResource"]["Airports"]["Airport"][i]["Position"]["Coordinate"]["Latitude"].floatValue

                let lon = jsonObject["AirportResource"]["Airports"]["Airport"][i]["Position"]["Coordinate"]["Longitude"].floatValue
                airports.append(Airport(lat: lat, lon: lon, code: code, name: name))
            }
            closure(airports)
        }
    }
    
    static func getFlightsFrom(type: String, code: String, date: String, completion: @escaping ([Flight]) -> ()) {
        let requestURL = "https://api.lufthansa.com/v1/operations/flightstatus/\(type)/\(code)/\(date)?limit=100"
        let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization" : "Bearer \(self.authToken!)"]
        
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            var returnedFlights: [Flight]! = []
            let jsonObject = JSON(response.result.value)
            if jsonObject["ProcessingErrors"] == JSON.null {
                let jsonFlights = jsonObject["FlightStatusResource"]["Flights"]["Flight"]
                for (string, jsonFlight) in jsonFlights {
                    returnedFlights.append(Flight(data: jsonFlight))
                }
                completion(returnedFlights)
            }
            else {
                print("found no \(type) flights")
                completion(returnedFlights)
            }  
        }
    }

}
