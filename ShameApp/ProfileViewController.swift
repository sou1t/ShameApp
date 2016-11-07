//
//  ProfileViewController.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var shameLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://fastswapp.ru/countShame?user_id=\(UserDefaults.standard.value(forKey: "id") as? String ?? "")", method: .get).responseJSON { response in
            
            if let json = response.result.value {
                let resultArray = JSON(json).array
                self.name.isHidden = false
                self.shameLabel.isHidden = false
                self.selectedLabel.isHidden = false
                self.name.text = resultArray?[0]["name"].string!
                self.photo.sd_setImage(with: URL(string: (resultArray?[0]["photoURL"].string!)!))
                self.shameLabel.text = "Взаимность: \((resultArray?[0]["shame"].string!)!)"
                self.selectedLabel.text = "Выбрано: \((resultArray?[0]["selection"].string!)!)"
                self.activity.stopAnimating()
            }
        }
        
        
        let gradient = CAGradientLayer().makeLayer()
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        UserDefaults.standard.set("", forKey: "id")
        DispatchQueue.main.async(execute: {
            self.navigationController?.popToRootViewController(animated: true)
        })

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
