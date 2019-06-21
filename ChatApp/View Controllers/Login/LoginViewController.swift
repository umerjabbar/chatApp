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
import FirebaseAuth

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
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard self != nil else { return }
            self?.progressHUD.removeFromSuperview()
            guard error == nil else{return}
            guard let tempuser = user?.user else{return}
            AppStateManager.shared.id = tempuser.uid
            UserDefaults.standard.set(tempuser.uid, forKey: "loggedUserId")
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "ConversationsViewController")
            self?.present(vc, animated: true, completion: nil)
        }
        
    }
    
}
