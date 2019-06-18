//
//  OnlineUserCollectionViewCell.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Kingfisher

class OnlineUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var onlineStatusView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    func setup(item : OnlineUser){
        let url = URL(string: item.image)
        self.userImageView.kf.setImage(with: url)
        self.titleLabel.text = item.name
        self.onlineStatusView.isHidden = !item.isConnected
    }
    
    
}
