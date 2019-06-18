//
//  LoginViewController.swift
//  CBD Shops
//
//  Created by MacAir on 12/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    
    @IBOutlet weak var imageRoundView: UIView!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        let cornerRadius = self.imageRoundView.bounds.height/2
        self.imageRoundView.layer.cornerRadius = cornerRadius
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        let nav = UINavigationController(rootViewController: ChatViewController())
        self.present(nav, animated: true, completion: nil)
    }
    
    //    func changeToHome(){
    //        let homeVC = HomeViewController.instantiate(fromAppStoryboard: .Main)
    //        let homeNavVC:BaseNavigationController = BaseNavigationController(rootViewController: homeVC)
    //        let sideMenuController = SideMenuController.instantiate(fromAppStoryboard: .Main)
    //        sideMenuController.homeController = homeNavVC
    //
    //        let slideMenuController = SlideMenuController(mainViewController: homeNavVC, leftMenuViewController: sideMenuController, rightMenuViewController: UIViewController())
    ////        self.navigationController?.hero.replaceViewController(with: slideMenuController)
    //
    //        self.present(slideMenuController, animated: true, completion: nil)
    //    }
    
    
}
