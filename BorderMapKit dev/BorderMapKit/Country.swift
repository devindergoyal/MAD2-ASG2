//
//  Country.swift
//  BorderMapKit
//
//  Created by Marcos Bittencourt on 2017-03-29.
//  Copyright © 2017 https://ca.linkedin.com/in/marcosbittencourt. All rights reserved.
//

import Foundation

class Country {
    public private(set) var countryName    : String
    public private(set) var countrycapital : String
    public private(set) var latitude       : Double
    public private(set) var longitude      : Double
    
    init(name: String, capital: String, latitude: Double, longitude: Double){
        self.countryName = name
        self.countrycapital = capital
        self.latitude = latitude
        self.longitude = longitude
    }
    
  
}
