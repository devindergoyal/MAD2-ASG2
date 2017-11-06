//
//  Border.swift
//  BorderMapKit
//
//  Created by Marcos Bittencourt on 2017-03-28.
//  Copyright © 2017 https://ca.linkedin.com/in/marcosbittencourt. All rights reserved.
//

import Foundation

//
//  Country.swift
//  Border
//
//  Created by Marcos Bittencourt on 2017-02-08.
//  Copyright © 2017 Lambton. All rights reserved.
//

import Foundation

class Border {
    
    var country : Country
    var countryborder  : [Country]

    init(name: String, capital: String, latitude: Double, longitude: Double)
    {
        self.country = Country(name: name, capital: capital, latitude: latitude, longitude: longitude)
        countryborder  = []
    }
    
    init(country: Country){
        self.country = country
        countryborder  = []
    }
    
    func addBorder(country: Country){
        countryborder.append(country)
    }
    
    func addBorder(name: String, capital: String, latitude: Double, longitude: Double){
        countryborder.append(Country(name: name, capital: capital, latitude: latitude, longitude: longitude))
    }
    
    
}
