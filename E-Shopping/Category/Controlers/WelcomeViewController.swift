//
//  WelcomeViewController.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 12.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var LoginOutlet: UIButton!
    @IBOutlet weak var registerOutlet: UIButton!
    
    //MARK: - Vars
    
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginOutlet.layer.cornerRadius = 20
        registerOutlet.layer.cornerRadius = 20
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.7900321484, blue: 0.2253903747, alpha: 1), padding: nil)
    }
    
    //MARK: - IBAction
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
        dismissView()

    }
    @IBAction func loginButton(_ sender: UIButton) {
        
        print("login")
        if textFieldsHaveText() {
            
            loginUser()
        } else {
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }

        
    }
    @IBAction func registerButton(_ sender: UIButton) {
                       
               if textFieldsHaveText() {
                   registerUser()
               } else {
                   hud.textLabel.text = "All fields are required"
                   hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   hud.show(in: self.view)
                   hud.dismiss(afterDelay: 2.0)
               }

    }
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        if emailTextField.text != "" {
                   resetThePassword()
               } else {
                   hud.textLabel.text = "Please insert email!"
                   hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   hud.show(in: self.view)
                   hud.dismiss(afterDelay: 2.0)
               }
    }
    
    @IBAction func resendEmail(_ sender: UIButton) {
        
        MUser.resendVerificationEmail(email: emailTextField.text!) { (error) in
                  
                  print("error resending email", error?.localizedDescription)
              }
    }

    //MARK: - Login User
    
    private func loginUser() {
        
        showLoadingIdicator()
        
        MUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                
                if  isEmailVerified {
                    self.dismissView()
                    print("Email is verified")
                } else {
                    self.hud.textLabel.text = "Please Verify your email!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                
            } else {
                print("error loging in the iser", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
            
            self.hideLoadingIdicator()
        }
        
    }

    
    //MARK: -  register user
    
    private func registerUser() {
           
           showLoadingIdicator()
           
           MUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
               
               if error == nil {
                   self.hud.textLabel.text = "Varification Email sent!"
                   self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
               } else {
                   print("error registering", error!.localizedDescription)
                   self.hud.textLabel.text = error!.localizedDescription
                   self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
               }
               
               
               self.hideLoadingIdicator()
           }
           
       }
    
    //MARK: - Helpers
    
    private func resetThePassword() {
           
           MUser.resetPasswordFor(email: emailTextField.text!) { (error) in
               
               if error == nil {
                   self.hud.textLabel.text = "Reset password email sent!"
                   self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
                self.resendButton.isHidden = false
               } else {
                   self.hud.textLabel.text = error!.localizedDescription
                   self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
               }
           }
       }
    
    private func textFieldsHaveText() -> Bool {
        
        return (emailTextField.text != "" && passwordTextField.text != "")
        
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Activity Indecator
    
    private func showLoadingIdicator() {
        
        if activityIdicator != nil {
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
    }
    
    private func hideLoadingIdicator() {
        
        if activityIdicator != nil {
            activityIdicator!.removeFromSuperview()
            activityIdicator!.stopAnimating()
        }
    }
    
}
