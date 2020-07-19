//
//  MapListViewController.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 03/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import Foundation

class MapListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: properties
    //table property
    @IBOutlet weak var mapTableView: UITableView!
    
    //student location array
    var studentLocation: StudentInformationData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadStudentData()
        mapTableView.dataSource = self
        mapTableView.delegate = self
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
            print("Reloading data")
            print(data)
            self.mapTableView.reloadData()
        }
    }
    
    //MARK: TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if studentLocation != nil {
            rowCount = studentLocation.results.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mapTableView.dequeueReusableCell(withIdentifier: "mapCell") as! MapListTableViewCell
        
        let pinLocation = studentLocation.results[indexPath.row]
        let firstName = pinLocation.firstName ?? ""
        let lastName = pinLocation.lastName ?? ""
        let postedURL = pinLocation.mediaURL
        
        cell.usersName.text = firstName + " " + lastName
        cell.postedLink.text = postedURL
        
        return cell
    }
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pinLocation = studentLocation.results[indexPath.row]
        let mediaURL = pinLocation.mediaURL
        
        if let openURL = mediaURL, let url = URL(string: openURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            present(AlertMessage.inCorrectURL(), animated: true, completion: nil)
        }
        
    }
    
    //MARK: NavBar fuctions
    
    @IBAction func logout(_ sender: Any) {
        udacityAPICalls.deleteUserSession {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshList(_ sender: Any) {
        downloadStudentData()
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        let addLocationVC = "AddLocationNavController"
        let addLocationNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: addLocationVC) as! UINavigationController
        present(addLocationNavController, animated: true, completion: nil)
    }

}

