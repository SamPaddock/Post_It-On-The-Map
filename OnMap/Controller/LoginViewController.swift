//
//  LoginViewController.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 30/06/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: properties
    //TextFields
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPpassword: UITextField!
    
    //Buttons and loading icon
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    //Height Contraints
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var mainStackViewTopHeight: NSLayoutConstraint!
    @IBOutlet weak var logoImage: UIImageView!
    
    //get if rotation is landscape is truw or false
    var isLandscape: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPpassword.delegate = self
        userEmail.delegate = self
        
    }

    //MARK: Login and Access Application
    
    @IBAction func userLoginAction(_ sender: Any) {
        setLoginSession(true)
        //performSegue(withIdentifier: "onTheMapView", sender: nil)
        guard userEmail.text?.isEmpty == false || userPpassword.text?.isEmpty == false else {
            present(AlertMessage.loginCredentialsFailed(), animated: true, completion: nil)
            setLoginSession(false)
            return
        }
        
        let emailAddress = userEmail.text!
        let password = userPpassword.text!
        
        udacityAPICalls.createUserSession(emailAddress, password, completion: self.handleLoginSession(success:error:))
    }
    
    @IBAction func signupToUdacity(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated") else {return}
        UIApplication.shared.open(url, completionHandler: nil)
        
    }
    
    //MARK: Login Handler
    
    func handleLoginSession(success: Bool, error: Error?){
        setLoginSession(false)
        if success {
            performSegue(withIdentifier: "onTheMapView", sender: nil)
        } else {
            let error = error as! NSError
            let alert = AlertMessage.showHTTPError(errorCode: error.code)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Manage layout during processing
    
    func setLoginSession(_ loggingIn: Bool){
        if loggingIn {
            progressIndicator.startAnimating()
        } else {
            progressIndicator.stopAnimating()
        }
        userEmail.isEnabled = !loggingIn
        userPpassword.isEnabled = !loggingIn
        loginBtn.isEnabled = !loggingIn
        signupBtn.isEnabled = !loggingIn
    }
    
    //MARK: TextField Delegate functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isLandscape {
            keyboardNotificationSubscription()
        } else {
            keyboardNotificationUnsubscription()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardNotificationUnsubscription()
    }
    
    //MARK: Keyboard Show/Hide function
    //Reference: Meme_V1
    
    //move view above keyboard when is is shown
    @objc func keyboardWillShow(_ notification: Notification){
        let height = self.view.bounds.size.height
        let keyBoardHeight = getKeyboardHeight(notification)
        if height < keyBoardHeight {
            //get space from safeArea to stack
            let topHeight = mainStackViewTopHeight.constant
            //get space bwtween email field and image
            let stackSpace = mainStackView.spacing
            //get image height
            let logoHeight = logoImage.image?.size.height ?? 0
            //Add all to get total height to move view up so email is at the top of the dipslay and visiable when typing
            let totalHeight = topHeight + stackSpace + logoHeight
            view.frame.origin.y = -totalHeight
        } else {
            view.frame.origin.y = 0
        }
    }
    
    //return view to original position when keyboard is hidden
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    //setting keyboard observers for showing and hiding keyboard
    func keyboardNotificationSubscription(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    //removing keyboard observation
    func keyboardNotificationUnsubscription(){
        NotificationCenter.default.removeObserver(self)
    }
    
    //Observe Orientation
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        if fromInterfaceOrientation.isLandscape{
            isLandscape = true
        } else {
            isLandscape = false
        }
    }
    
    //keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

