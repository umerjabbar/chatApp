//
//  ViewController.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {
    
    let viewModel = ConversationsViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    var messagegheads = [(String, String, String, String, String)]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel.delegate = self
        self.viewModel.getOnlineUsers()
        self.viewModel.offlineFunction()
        
        self.messagegheads = [
            ("0",  "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "Sample Image 1", "", ""),
            ("1",  "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "Sample User 2", "", ""),
            ("2", "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "Sample User 3", "", ""),
        ]
        
    }

    @IBAction func viewAllButtonAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnlineUsersViewController") as! OnlineUsersViewController
        vc.viewModel = self.viewModel
        self.present(vc, animated: true, completion: nil)
        
//        let rect = self.collectionView.frame
//        let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height + 400)
//
//        self.collectionView.frame = rect2
    }
    
}


extension ConversationsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.onlineUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineUserCollectionViewCell", for: indexPath) as! OnlineUserCollectionViewCell
        
        cell.setup(item: self.viewModel.onlineUsers[indexPath.item])
        
        return cell
    }
    
}

extension ConversationsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagegheads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageHeadTableViewCell", for: indexPath)
        
        
        return cell
        
    }

}


extension ConversationsViewController : UICollectionViewDelegate {
    
}

extension ConversationsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let nav = UINavigationController(rootViewController: ChatViewController())
//        self.present(nav, animated: true, completion: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

extension ConversationsViewController : ConversationsResponseDelegate {
    
    func onlineUsersReceived() {
        self.collectionView.reloadData()
    }
    
    func messageHeadsReceived() {
        
    }
    
}
