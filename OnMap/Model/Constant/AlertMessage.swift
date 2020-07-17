//
//  AlertMessage.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 15/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation
import UIKit

class AlertMessage{
    
    //Error title case
    
    enum alertTitle {
        case loginFailed
        case logoutSuccess
        case networkClientIssue
        case networkServerIssue
        case defaultTitle
        case noPin
        case invalidURL
        case geoLocationInvalid
        case success
        case fail
        
        var titleStringValue: String {
            switch self {
            case .loginFailed: return "Login Failed"
            case .logoutSuccess: return "Logout successful"
            case .networkClientIssue: return "Network Connection"
            case .networkServerIssue: return "Error 404"
            case .defaultTitle: return "An unknown issue occured"
            case .noPin: return "No pins found"
            case .invalidURL: return "Invalid URL link"
            case .geoLocationInvalid: return "Invalid or missing location and/or URL"
            case .success: return "Uploaded successfully"
            case .fail: return "Uploaded failed"
            }
        }
        
        var title: String {return titleStringValue}
    }
    
    //Error message case
    
    enum alertMessage {
        case incorrectCredentials
        case Success
        case networkDown
        case serverDown
        case defaultMessage
        case noPin
        case invalidURL
        case geoLocationInvalid
        case uploadSuccess
        case uploadFail
        
        
        var messageStringValue: String {
            switch self {
            case .incorrectCredentials: return "Please enter a correct Username and/or password"
            case .Success: return "Action completed successfully"
            case .networkDown: return "Intrnet connection down. Please check network signal and try again"
            case .serverDown: return "Server down. Please try again later"
            case .defaultMessage: return "Contact Admin to review issue and correct it"
            case .noPin: return "No student locations found. Please try again later"
            case .invalidURL: return "Could not open the link as the URL format is incorrect"
            case .geoLocationInvalid: return "Please enter a city and URL to select the location and post your URL"
            case .uploadSuccess: return "Uploaded Location and URL successfully. You can now view it on the map."
            case .uploadFail: return "Uploaded Location and URL failed. Try again later."
            }
        }
        
        var message: String {return messageStringValue}
    }
    
    //Create Error message
    
    class func showAlertMessage(title: String, message: String) -> UIAlertController{
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertVC
    }
    
    //Default Error Message
    
    class func defaultAlertMessage() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.defaultTitle.title, message: AlertMessage.alertMessage.defaultMessage.message)
        return alert
    }
    
    //Session Message
    
    class func loginCredentialsFailed() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.loginFailed.title, message: AlertMessage.alertMessage.incorrectCredentials.message)
        return alert
    }
    
    class func logoutCompletedSuccessfully() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.logoutSuccess.title, message: AlertMessage.alertMessage.Success.message)
        return alert
    }
    
    //Student Location Error Message
    
    class func noLocationData() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.noPin.title, message: AlertMessage.alertMessage.noPin.message)
        return alert
    }
    
    //Upload Message
    
    class func uploadSccuess() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.success.title, message: AlertMessage.alertMessage.uploadSuccess.message)
        return alert
    }
    
    class func uploadFail() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.fail.title, message: AlertMessage.alertMessage.uploadFail.message)
        return alert
    }
    
    //URL Error message
    
    class func inCorrectURL() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.invalidURL.title, message: AlertMessage.alertMessage.invalidURL.message)
        return alert
    }
    
    //Map String Error message
    
    class func incorrectMapString() -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: AlertMessage.alertTitle.geoLocationInvalid.title, message: AlertMessage.alertMessage.geoLocationInvalid.message)
        return alert
    }
    
    //HTTP Error Message
    
    class func showHTTPError(errorCode: Int) -> UIAlertController{
        //HTTP Error range
        let clientError = 400..<500
        let serverError = 500..<600
        //Error alert title and message
        var title: String = ""
        var message: String = ""
        //check error type
        if clientError.contains(errorCode){
            title = AlertMessage.alertTitle.networkClientIssue.title
            message = AlertMessage.alertMessage.networkDown.message
        } else if serverError.contains(errorCode) {
            title = AlertMessage.alertTitle.networkServerIssue.title
            message = AlertMessage.alertMessage.serverDown.message
        } else {
            title = AlertMessage.alertTitle.defaultTitle.title
            message = AlertMessage.alertMessage.defaultMessage.message
        }
        let alert = AlertMessage.showAlertMessage(title: title, message: message)
        return alert
    }
    
}
