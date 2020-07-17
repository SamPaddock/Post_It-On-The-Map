//
//  PostInfoViewController.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 03/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostInfoViewController: UIViewController, MKMapViewDelegate {

    //MARK: Properties
    //student information to be used and passed to api
    var studentInfo: StudentInformation!
    var studentPublicInformation: User!
    
    //map property
    @IBOutlet weak var mapScene: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapScene.delegate = self
        initilizeMap()
    }
    
    //MARK: Initialize Map
    
    func initilizeMap(){
        guard let studentLocation = studentInfo else {return}
        
        let latitude = CLLocationDegrees(studentLocation.latitude!)
            
        let longitude = CLLocationDegrees(studentLocation.longitude!)
        
        let coordinations = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinations
        annotation.title = studentLocation.mediaURL!
        
        mapScene.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinations, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapScene.setRegion(region, animated: true)
        
    }
    
    //MARK: Map Delegate Function
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var mapPin = mapScene.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if mapPin == nil {
            print("pin")
            mapPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            mapPin?.canShowCallout = true
            mapPin?.backgroundColor = .clear
            mapPin?.tintColor = .green
            mapPin?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return mapPin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //check if pin tapped
        if control == view.rightCalloutAccessoryView {
            if let openURL = studentInfo.mediaURL, let url = URL(string: openURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                present(AlertMessage.inCorrectURL(), animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Upload Info
    
    @IBAction func postStudentInfo(_ sender: Any) {
        udacityAPICalls.getUserInfo(){ data, error in
            guard let data = data else {
                return
            }
            self.studentPublicInformation = data
            self.uploadStudentData()
        }
    }
    
    func uploadStudentData(){
        guard let studentPublicInfo = studentPublicInformation, var studentLocation = studentInfo else {return}
        studentLocation.firstName = studentPublicInformation.firstName
        studentLocation.lastName = studentPublicInformation.lastName
        studentLocation.uniqueKey = studentPublicInformation.key
        udacityAPICalls.uploadStudentLocation(studentInfo: studentLocation) { success, error in
            
            if success {
                self.present(AlertMessage.uploadSccuess(), animated: true, completion: nil)
            } else {
                self.present(AlertMessage.uploadFail(), animated: true, completion: nil)
            }
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapTabBar")
            self.present(cv, animated: true, completion: nil)
        }
    }
    
}
