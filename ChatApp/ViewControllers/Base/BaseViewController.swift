//
//  BaseViewController.swift
//  CBD Shops
//
//  Created by MacAir on 12/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Hero
//import IQKeyboardManagerSwift

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        if (self.navigationController?.navigationBar !== nil){
            self.changeNavBarColor(with: #colorLiteral(red: 0.4196078431, green: 0.7333333333, blue: 0.1294117647, alpha: 1))
        }
        
    }
    
    public func addLeftBarBackButtonImage(_ buttonImage: UIImage = #imageLiteral(resourceName: "back")) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
//        IQKeyboardManager.shared.resignFirstResponder()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func changeNavBarColor(with: UIColor) {
//        UIView.transition(with: self.navigationController!.navigationBar, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
//
////            self.navigationController!.navigationBar.barTintColor = with
//            self.navigationController!.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            self.navigationController!.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: with), for: .default)
////            self.navigationController!.navigationBar.shadowImage = UIImage.imageWithColor(color: with)
//        }, completion: nil)
//        self.navigationController?.navigationBar.barTintColor = with
    }
    
    func startLoading(){
        //        LoadingOverlay.shared.showOverlay()
    }
    
    func stopLoading(){
        //        LoadingOverlay.shared.hideOverlayView()
    }
    
    
//    func setNavigationBarItem() {
//        self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "menu"))
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//        self.slideMenuController()?.addLeftGestures()
//    }
//    
//    func removeNavigationBarItem() {
//        self.navigationItem.leftBarButtonItem = nil
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//    }
    
}
