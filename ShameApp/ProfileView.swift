//
//  ProfileView.swift
//  ShameApp
//
//  Created by AnarGuseynov on 11.11.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileView: UIView {
  @IBOutlet weak var activity: UIActivityIndicatorView!
  @IBOutlet weak var shameLabel: UILabel!
  @IBOutlet weak var selectedLabel: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var photo: UIImageView!
    var vc = FriendsListViewController()

    
  override func layoutSubviews() {
    super.layoutSubviews()
    self.isHidden = true
    self.alpha = 0
    let size = self.photo.bounds.height
    Alamofire.request("http://fastswapp.ru/countShame?user_id=\(UserDefaults.standard.value(forKey: "id") as? String ?? "")", method: .get).responseJSON { response in
      
      if let json = response.result.value {
        let resultArray = JSON(json).array
        self.name.isHidden = false
        self.shameLabel.isHidden = false
        self.selectedLabel.isHidden = false
        self.name.text = resultArray?[0]["name"].string!
        self.photo.layer.cornerRadius = size/2
        self.photo.sd_setImage(with: URL(string: (resultArray?[0]["photoURL"].string!)!))
        self.shameLabel.text = "Взаимность: \((resultArray?[0]["shame"].string!)!)"
        self.selectedLabel.text = "Выбрано: \((resultArray?[0]["selection"].string!)!)"
        self.activity.stopAnimating()
      }
    }
  }

    
}
