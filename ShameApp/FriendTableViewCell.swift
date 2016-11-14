//
//  FriendTableViewCell.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  @IBAction func buttonPressed(sender: UIButton){
    guard let image = UIImage(named: "likefull") else {return}
    sender.setImage(image, for: UIControlState())
  }
}
