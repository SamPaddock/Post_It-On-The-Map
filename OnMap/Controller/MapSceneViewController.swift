//
//  MapSceneViewController.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 03/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapSceneViewController: UIViewController, MKMapViewDelegate {

    //MARK: properties
    //map property
    @IBOutlet weak var mapScene: MKMapView!
    
    //student location array
    var studentLocation: StudentInformationData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapScene.delegate = self
        downloadStudentData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapScene.showsCompass = true
    }
    
    //MARK: MapView Delegate functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var mapPin = mapScene.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if mapPin == nil {
            mapPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            mapPin?.canShowCallout = true
            mapPin?.backgroundColor = .clear
            mapPin?.tintColor = .blue
            mapPin?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        
        return mapPin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //check if pin tapped
        if control == view.rightCalloutAccessoryView {
            if let openURL = view.annotation?.subtitle!, let url = URL(string: openURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                present(AlertMessage.inCorrectURL(), animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Get students locations
    
    func downloadStudentData(){
        udacityAPICalls.retrieveStudetLocations{ (data) in
            guard let data = data else {
                return
            }
            guard data.results.count > 0 else {
                self.present(AlertMessage.noLocationData(), animated: true, completion: nil)
                return
            }
            self.studentLocation = data
            self.pinStudentLocation()
        }
    }
    
    func pinStudentLocation(){
        guard let pinLocations = studentLocation?.results else {return}
        //creat a map annotations array
        var mapAnnotation = [MKPointAnnotation]()
        //loop over student data
        for pinlocation in pinLocations {
            //if there is no 2D coordinate, them skip this row and move to next row in array
            guard let latitude = pinlocation.latitude, let longitude = pinlocation.longitude else {continue}
            //convert to earth degrees
            let latCoordinate = CLLocationDegrees(latitude)
            let lonCoordinate = CLLocationDegrees(longitude)
            let coordination = CLLocationCoordinate2D(latitude: latCoordinate, longitude: lonCoordinate)
            //get student info
            let firstName = pinlocation.firstName ?? ""
            let lastName = pinlocation.lastName ?? ""
            let mediaURL = pinlocation.mediaURL
            //create a map annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordination
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            mapAnnotation.append(annotation)
        }
        //remove current annotation and add new annotations
        mapScene.removeAnnotations(mapScene.annotations)
        mapScene.addAnnotations(mapAnnotation)
        
    }
    
    //MARK: NavBar functions
    
    @IBAction func logout(_ sender: Any) {
        udacityAPICalls.deleteUserSession {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        downloadStudentData()
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        let addLocationVC = "AddLocationNavController"
        let addLocationNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: addLocationVC) as! UINavigationController
        present(addLocationNavController, animated: true, completion: nil)
    }
}
