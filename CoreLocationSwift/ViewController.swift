//
//  ViewController.swift
//  CoreLocationSwift
//
//  Created by MACOS on 7/3/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {

    let locationmanger = CLLocationManager();
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        map.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
        else
        {
            print("Location services are not enabled")
        }
        locationmanger.delegate = self;
        locationmanger.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        locationmanger.requestWhenInUseAuthorization();
        locationmanger.requestAlwaysAuthorization();
        locationmanger.startUpdatingLocation();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        let cls =   locations[0];
        let lat =   cls.coordinate.latitude;
        let log  = cls.coordinate.longitude;
        print(lat);
        print(log);
        
        CLGeocoder().reverseGeocodeLocation(cls, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                print(pm?.locality!)
                print(pm?.country!)
                print(pm?.postalCode!)
                print(pm?.name!)
                print(pm?.subLocality!)
                // print(pm?.ocean!)
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        locationmanger.stopUpdatingLocation();
        
        let center = CLLocationCoordinate2D(latitude: cls.coordinate.latitude, longitude: cls.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        let newYorkLocation = CLLocationCoordinate2DMake(lat, log)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "New York City"
        map.addAnnotation(dropPin)
    }

}

