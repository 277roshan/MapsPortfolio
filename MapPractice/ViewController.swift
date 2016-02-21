//
//  ViewController.swift
//  MapPractice
//
//  Created by Roshan Thapaliya on 2/18/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//

import UIKit
import MapKit


var searchKey = ""
let GOOGLE_API_KEY = "AIzaSyBSQ11p5somUrlvz7qEtHfS2ulA8Le6xPA"
var baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=38.90,-77.016&radius=500&type=restaurant&name=\(searchKey)&key=\(GOOGLE_API_KEY)"


class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var SearchText: UITextField! // User entered search text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SearchText.becomeFirstResponder() //make the keyboard appear
        annotate() //call annotate function to make json request and put pins on the map
        
    }
    
    
    func annotate()
    {
        //in this function we set the map location
        //we start a NSURLsession which allows us to make JSON request
        //we make the JSON request
        //we handle the JSON data
        //we get the longitude and latitude for the location
        //we find the coordinates
        //we put the pin on the map
        
        let delta = 0.03
        let center = CLLocationCoordinate2DMake(38.90, -77.016)
        let region = MKCoordinateRegion(center:center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
        let task = session.dataTaskWithRequest(request){
            (data, response, error)-> Void in
            if error != nil {
                
                print (error!.localizedDescription)
                return
            }
            
            //do convert to json
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let items = json["results"] as? [[String: AnyObject]]{
                    for items in items{
                        //process items here
                        print (items)
                        
                        if let name = items["name"] as? String, let vicinity = items["vicinity"] as? String{
                            
                            let coords: [Double] = self.getCoords(items["geometry"] as! Dictionary)
                            
                            
                            let annotation = MKPointAnnotation()
                            
                            annotation.coordinate = CLLocationCoordinate2D(
                                latitude: coords[0],
                                longitude: coords[1]
                            )
                            
                            
                            annotation.title = name + vicinity //adding vicinity 
                            
                            
                            self.mapView.addAnnotation(annotation)
                        }
                        
                    }
                    //when finished, update the UI on the main thread
                    dispatch_async(dispatch_get_main_queue()){
                        self.mapView.setRegion(region, animated: true)
                    }
                }
                
            }catch{
                //    print("error serializing json: \(error)")
                print("error serializing json")
            }
            
        }
        task.resume()
    }
    
    
    
    func getCoords(data: [String:AnyObject]) -> [Double]{
        //we get the coordinates using this function
        let c = data["location"] as![String: AnyObject]
        print (c)
        return [c["lat"] as! Double, c["lng"] as! Double]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // We remove all annotations
        // We get the search key and make the search
        // We put new pins 
        // api call sometimes takes long time, so have patience
        
        mapView.removeAnnotations(mapView.annotations)
        SearchText.resignFirstResponder()
        searchKey = SearchText.text!
        baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=38.90,-77.016&radius=500&type=restaurant&name=\(searchKey)&key=\(GOOGLE_API_KEY)"
        annotate()
        return true
    }
    
 
    
    
    
    
}

