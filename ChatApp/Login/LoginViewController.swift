//
//  LoginViewController.swift
//  ChatApp
//
//  Created by MacAir on 19/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    let progressHUD = ProgressHUD(text: "Signing in")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let email = self.emailTextField.text else{return}
        guard let password = self.passwordTextField.text else{return}
        
        self.login(email: email, password: password)
        
    }
    @IBAction func backTapAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    func login(email: String, password: String){
        
        self.view.addSubview(self.progressHUD)
        
        let urlParams = [
            "username":email,
            "passwrod":password,
        ]
        
        // Fetch Request
        Alamofire.request("https://bikeboerse.com/BikeApi/ios/user/userlogin.php", method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                self.progressHUD.removeFromSuperview()
                if (response.result.error == nil) {
                    guard let array = response.result.value as? [Any] else {return}
                    guard let value = array.first as? [String : Any] else {return}
                    guard let json = JSON(rawValue: value) else{return}
                    let loggedInUser = LoginUser(fromJson: json)
                    AppStateManager.shared.id = loggedInUser.id
                    AppStateManager.shared.name = loggedInUser.name
                    AppStateManager.shared.image = loggedInUser.picture
                    
                    UserDefaults.standard.set(loggedInUser.id, forKey: "loggedUserId")
                    UserDefaults.standard.set(loggedInUser.name, forKey: "loggedUserName")
                    UserDefaults.standard.set(loggedInUser.picture, forKey: "loggedUserImage")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConversationsViewController") as! ConversationsViewController
                    self.present(vc, animated: true, completion: nil)
                    
                }
                else {
                    
                }
                
        }
        
    }
    
}
