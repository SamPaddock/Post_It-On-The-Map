//
//  AddInfoViewController.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 03/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import CoreLocation

class AddInfoViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var mapString: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    
    @IBOutlet weak var loadingProcess: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func findAddedLocation(_ sender: Any) {
        guard let coorLocation = mapString.text, let mediaLink = mediaURL.text, coorLocation != "", mediaLink != "" else {
            self.present(AlertMessage.incorrectMapString(), animated: true, completion: nil)
            return
        }
        loadingProcess.startAnimating()
        geocodeConvertion(mapString: coorLocation, urlLink: mediaLink)
    }
    
    func geocodeConvertion(mapString: String, urlLink: String){
        CLGeocoder().geocodeAddressString(mapString) { (placeMarker, error) in
            guard let selectedLocation = placeMarker?.first?.location else {return}
            let latitude = selectedLocation.coordinate.latitude
            let longitude = selectedLocation.coordinate.longitude
            var studentInfo = StudentInformation(latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: urlLink)
            self.loadingProcess.stopAnimating()
            self.performSegue(withIdentifier: "addLocation", sender: studentInfo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let cv = segue.destination as? PostInfoViewController
            cv?.studentInfo = sender as! StudentInformation
        }
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
