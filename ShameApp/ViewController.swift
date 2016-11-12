//
//  ViewController.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import VK_ios_sdk
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    var friends = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.stopAnimating()
        let gradient = CAGradientLayer().makeLayer()
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        if sessionIsActive() {
            Alamofire.request("http://fastswapp.ru/friendsShow?user_id=\(UserDefaults.standard.value(forKey: "id") as? String ?? "")", method: .get).responseJSON { response in
                
                if let json = response.result.value {
                    let resultArray = JSON(json).array
                    for friend in resultArray!
                    {
//                        print("\(friend["id"].rawValue) \(friend["name"].string!) \(friend["photoURL"].string!) \(friend["shame"].string!)\n")
                        if (friend["photoURL"].string != nil){
                            self.friends.append(Person(id: friend["id"].string!, name: friend["name"].string!, photo: friend["photoURL"].string!, shame: friend["shame"].string!))}
                    }
                    self.activity.stopAnimating()
                    self.performSegue(withIdentifier: "MainToNext", sender: self)
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func vkLoginPressed(_ sender: UIButton) {
        activity.startAnimating()
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self
        
        let scope = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_STATUS]
        
        VKSdk.wakeUpSession(scope) { (state, error) -> Void in
            
            if state == .authorized {
                VKSdk.forceLogout()
            }
            VKAuthorizeController.presentForAuthorize(withAppId: "4934283", andPermissions: scope, revokeAccess: true, displayType: "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToNext"{
          if let navController = segue.destination as? UINavigationController{
            if let nextVC = navController.viewControllers[0] as? FriendsListViewController{
               nextVC.friends = self.friends
          }
        }
      }
    }


    func sessionIsActive() -> (Bool) {
        let id = UserDefaults.standard.value(forKey: "id") as? String ?? ""
        if id != "" {
            return true
        }
        else
        {
            return false
        }
    }
}

extension ViewController:VKSdkDelegate, VKSdkUIDelegate{
    // MARK: - VKSdkDelegate
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        UserDefaults.standard.set("\(result.token.userId!)", forKey: "id")
        Alamofire.request("http://fastswapp.ru/friendsShow?user_id=\(result.token.userId!)", method: .get).responseJSON { response in
            
            if let json = response.result.value {
                let resultArray = JSON(json).array
                for friend in resultArray!
                {
                    print("\(friend["id"].rawValue) \(friend["name"].string!) \(friend["photoURL"].string!) \(friend["shame"].string!)\n")
                    self.friends.append(Person(id: friend["id"].string!, name: friend["name"].string!, photo: friend["photoURL"].string!, shame: friend["shame"].string!))
                }
                self.activity.stopAnimating()
                self.performSegue(withIdentifier: "MainToNext", sender: self)
            }
        }
    }
    func vkSdkUserAuthorizationFailed() {
        
    }
    // MARK: - VKSdkUIDelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self)
    }
}


