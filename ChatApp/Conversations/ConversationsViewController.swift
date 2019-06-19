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
    @IBOutlet weak var onlineUserWarningLabel: UILabel!
    @IBOutlet weak var messageHeadWarningLabel: UILabel!
    
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
        self.viewModel.getMessageHeads()
        self.viewModel.offlineFunction()
        
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnlineUsersViewController") as! OnlineUsersViewController
        vc.viewModel = self.viewModel
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "loggedUserId")
        UserDefaults.standard.removeObject(forKey: "loggedUserName")
        UserDefaults.standard.removeObject(forKey: "loggedUserImage")
    }
    
    
}


extension ConversationsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.onlineUserWarningLabel.isHidden = !self.viewModel.onlineUsers.isEmpty
        
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
        
        self.messageHeadWarningLabel.isHidden = !self.viewModel.messageHeads.isEmpty
        
        return self.viewModel.messageHeads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageHeadTableViewCell", for: indexPath) as! MessageHeadTableViewCell
        
        let item = self.viewModel.messageHeads[indexPath.row]
        cell.setup(item: item)
        
        return cell
        
    }
    
}


extension ConversationsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        let user = self.viewModel.onlineUsers[indexPath.item]
        let ind = self.viewModel.messageHeads.firstIndex { (head) -> Bool in
            return head.otherUser == user.id
        }
        if let index = ind {
            let item = self.viewModel.messageHeads[index]
            vc.viewModel.item = item
            vc.viewModel.chatType = "individual"
        }else{
            let item = MessageHead()
            item.id = user.id
            item.name = user.name
            item.image = user.image
            item.message = ""
            item.otherUser = ""
            item.time = ""
            vc.viewModel.item = item
            vc.viewModel.chatType = "new"
        }

        self.present(vc, animated: true, completion: nil)
    }
    
}

extension ConversationsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let nav = UINavigationController(rootViewController: ChatViewController())
        //        self.present(nav, animated: true, completion: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.viewModel.chatType = "individual"
        vc.viewModel.item = self.viewModel.messageHeads[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

extension ConversationsViewController : ConversationsResponseDelegate {
    
    func onlineUsersReceived() {
        self.collectionView.reloadData()
    }
    
    func messageHeadsReceived() {
        let offset = self.tableView.contentOffset
        self.tableView.reloadData()
        self.tableView.contentOffset = offset
        
    }
    
}
