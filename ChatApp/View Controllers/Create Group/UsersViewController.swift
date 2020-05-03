//
//  UsersViewController.swift
//  ChatApp
//
//  Created by MacAir on 21/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    var users = [MyUser]()
    var selectedUsers = [MyUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    @IBAction func backbuttonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUsers(){
        guard let rows = self.tableView.indexPathsForSelectedRows?.map({ (indexPath) -> Int in
            return indexPath.row
        })else{return}
    }
    
}

extension UsersViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        return cell
        
    }
    
}

extension UsersViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UsersTableViewCell else {return}
        cell.selectView(select: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UsersTableViewCell else {return}
        cell.selectView(select: false)
    }
    
    
    
}
