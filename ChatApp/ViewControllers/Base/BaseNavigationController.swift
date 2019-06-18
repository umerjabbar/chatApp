//
//  BaseNavigationController.swift
//  CBD Shops
//
//  Created by MacAir on 12/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barTintColor = #colorLiteral(red: 0.4196078431, green: 0.7333333333, blue: 0.1294117647, alpha: 1)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [kCTForegroundColorAttributeName : UIColor.white] as [NSAttributedString.Key : Any]
        self.hero.isEnabled = true
        self.navigationBar.barStyle = .blackOpaque
        self.navigationBar.isTranslucent = false
    }
    


}
