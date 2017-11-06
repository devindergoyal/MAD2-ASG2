//
//  ViewController.swift
//  BorderMapKit
//
//  Created by Marcos Bittencourt on 2017-03-28.
//  Copyright © 2017 https://ca.linkedin.com/in/marcosbittencourt. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate ,UITableViewDataSource
{
    @IBOutlet weak var countrytable: UITableView!
    
    // MARK: Properties
    
    @IBOutlet weak var mapObj: MKMapView!
    @IBOutlet weak var countryName: UITextField!
    
    @IBOutlet weak var country2: UITextField!
    
    
    
    var mapManager = CLLocationManager()
    
    var border : [Border] = []
    var annotations : [MKPointAnnotation] = []
    
    var countries : [String ] = []
    
    var lat : [Double] = []
    
    var str1 = "Kilometers"
    
    var result : [String] = []
    
    var long: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        countryName.delegate = self
        mapManager.delegate = self                            // ViewController is the "owner" of the map.
        mapManager.desiredAccuracy = kCLLocationAccuracyBest  // Define the best location possible to be used in app.
        mapManager.requestWhenInUseAuthorization()            // The feature will not run in background
        mapManager.startUpdatingLocation()                    // Continuously geo-position update
        mapObj.delegate = self
        
        
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func findBorder(_ sender: UIButton) {
        
        mapObj.removeAnnotations(annotations)
        countryName.resignFirstResponder()
        
        if  let b1 = retrieveData(countryName: countryName.text!) {
            let userAnnotation = MKPointAnnotation()
            userAnnotation.coordinate = CLLocationCoordinate2DMake(b1.country.latitude, b1.country.longitude)
            mapObj.addAnnotation(userAnnotation)
            annotations.append(userAnnotation)
            
            countries.append(b1.country.countryName)
            lat.append(b1.country.latitude)
            long.append(b1.country.longitude)

            // Here we define the map's zoom. The value 0.01 is a pattern
            let zoom:MKCoordinateSpan = MKCoordinateSpanMake(100, 100)
            
            // Store latitude and longitude received from smartphone
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(b1.country.latitude, b1.country.longitude)
            
            // Based on myLocation and zoom define the region to be shown on the screen
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, zoom)
            
            // Setting the map itself based previous set-up
            mapObj.setRegion(region, animated: true)
            
            
        // Set second location on map and add common Borders in array
            if let b2 = retrieveData(countryName: country2.text!)
            {
                countries.append(b2.country.countryName)
                lat.append(b2.country.latitude)
                long.append(b2.country.longitude)
                
                 for d in b2.countryborder
                     {
        
                     let countryBorderAnnotation = MKPointAnnotation()
                        countryBorderAnnotation.coordinate = CLLocationCoordinate2DMake(d.latitude, d.longitude)
                        mapObj.addAnnotation(countryBorderAnnotation)
                        annotations.append(countryBorderAnnotation)
        
                        countries.append(d.countryName)
                        lat.append(d.latitude)
                        long.append(d.longitude)
        
    }
            }
            
            for c in b1.countryborder {
                
                let countryBorderAnnotation = MKPointAnnotation()
                countryBorderAnnotation.coordinate = CLLocationCoordinate2DMake(c.latitude, c.longitude)
                mapObj.addAnnotation(countryBorderAnnotation)
                annotations.append(countryBorderAnnotation)
                
                countries.append(c.countryName)
                lat.append(c.latitude)
                long.append(c.longitude)
                
            }
            
        }
      
        // Print data for common borders
        
        for i in 0...lat.endIndex - 1
        {
            let location1 = CLLocation(latitude: getlatvalue(index: Int(i)),longitude: getlongvalue(index: Int(i)))
            let location2 = CLLocation(latitude: getlatvalue(index: lat.endIndex - 1), longitude: getlongvalue(index:  long.endIndex - 1))
            
            var distance = location1.distance(from: location2)/1000
            
            //distance = distance
            
            distance = Double (String(format: "%.2f", distance))!

            
            
            result.append(getcountryname(index: i) + " " + String(distance) + str1 + " " +  getcountryname(index: lat.endIndex - 1) )
            
            //print ( getcountryname(index: i) , " ", distance , " KM " ,getcountryname(index: lat.endIndex - 1) )
            
            print(getresult(index: i))
            self.countrytable.reloadData()

        }

        
        countries = []
        
        lat=[]
        
        long = []
        
        
    }
    
    @IBAction func reset(_ sender: Any)
    {
        countryName.text = " "
        
        country2.text = " "
        
        countries = []
        
        lat = []
        
        long = []
        
        result = []
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countrytable.dequeueReusableCell(withIdentifier:"cell")
        
        let (resultdata) = result[indexPath.row]
        
        cell?.textLabel?.text = resultdata
        cell?.textLabel?.textColor = UIColor .white
        
        // Empty Array after every search
        return cell!
        
    }
 
    
    
    // Drawing a red circle to pin on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    // dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadData()
    
    {
        let af  = Country(name: "Afghanistan", capital: "Kabul", latitude: 34.38, longitude: 69.11)
        let ind = Country(name: "India", capital: "Delhi", latitude: 20.5937, longitude: 78.9629)
        let pk = Country(name: "Pakistan", capital: "Islamabad", latitude: 30.3753, longitude: 69.3451)
        let hk = Country(name: "Hong Kong", capital: "Victoria City", latitude: 22.3964, longitude: 114.1095)
        let bng  = Country(name: "Bangladesh", capital: "Dhaka", latitude: 23.6850, longitude: 90.3563)
        let np  = Country(name: "Nepal", capital: "Kathmandu", latitude: 28.3949, longitude: 84.1240)
        let ch  = Country(name: "China", capital: "Beijing", latitude: 39.913818, longitude: 116.363625)
        let sri  = Country(name: "Sri Lanka", capital: "Colombo", latitude: 7.8731, longitude: 80.7718)
        
        let b1 = Border(country: ind)
        b1.addBorder(country: pk)
        b1.addBorder(country: af)
        b1.addBorder(country: ch)
        
        let b2 = Border(country: af)
        b2.addBorder(country: hk)
        b2.addBorder(country: bng)
        b2.addBorder(country: np)
        
        let b3 = Border(country: ch)
        b3.addBorder(country: hk)
        b3.addBorder(country: pk)
        b3.addBorder(country: sri)
        
        let b4 = Border(country: np)
        b4.addBorder(country: af)
        b4.addBorder(country: sri)
        b4.addBorder(country: bng)
        
        let b5 = Border(country: sri)
        b5.addBorder(country: ind)
        b5.addBorder(country: pk)
        b5.addBorder(country: bng)
        
        border.append(b1)
        border.append(b2)
        border.append(b3)
        border.append(b4)
        border.append(b5)
    }
    
    func retrieveData(countryName : String) -> Border? {
        for b in border {
            if b.country.countryName == countryName {
                return b
            }
        }
        return nil
    }
    
    // getter methods  for Array
    
    func getlatvalue(index : Int) -> Double {
        
        return lat [index]
    }
   
    func getlongvalue(index : Int) -> Double {
        
        return long [index]
    }
    func getcountryname(index : Int) -> String {
        
        return countries [index]
    }
    
    func getresult(index : Int) -> String {
        
        return result [index]
    }
    
}
