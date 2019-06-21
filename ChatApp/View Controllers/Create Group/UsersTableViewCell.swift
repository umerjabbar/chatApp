//
//  UsersTableViewCell.swift
//  ChatApp
//
//  Created by MacAir on 21/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func selectView(select : Bool){
        self.selectionView.backgroundColor = select ? #colorLiteral(red: 0.4762203097, green: 0.7849087715, blue: 0.9215016961, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
