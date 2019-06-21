//
//  CreateGroupViewController.swift
//  ChatApp
//
//  Created by MacAir on 21/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    var users = [MyUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let user = MyUser()
        user.id = "123123123213213"
        user.name = "Sample user"
        user.image = "https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg"
        self.users = [user]
        
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backGroundTapAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }
    
}

extension CreateGroupViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.users.count != indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineUserCollectionViewCell", for: indexPath) as! OnlineUserCollectionViewCell
            let item = self.users[indexPath.item]
            cell.userImageView.imageUrl = item.image
            cell.titleLabel.text = item.name
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineUserCollectionViewCell", for: indexPath) as! OnlineUserCollectionViewCell
            cell.userImageView.image = #imageLiteral(resourceName: "icons8-plus_2_math")
            cell.titleLabel.text = "Add User"
            return cell
        }
        
    }
    
    
}

extension CreateGroupViewController : UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Cell selected")
        
        if self.users.count != indexPath.item {
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
