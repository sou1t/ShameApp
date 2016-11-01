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

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var friends = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer().makeLayer()
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)

        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func vkLoginPressed(_ sender: UIButton) {
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
        
        let barViewControllers = segue.destination as! UITabBarController
        let nav = barViewControllers.viewControllers![0] as! FriendsListViewController
        let lk = barViewControllers.viewControllers![1] as! ProfileViewController
        //let destinationViewController = nav.topViewController as! FriendsListViewController
        
        nav.friends = self.friends
    }


}

extension ViewController:VKSdkDelegate, VKSdkUIDelegate{
    
    
    // MARK: - VKSdkDelegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        
        let request = VKApi.friends().get([VK_API_FIELDS : "first_name, last_name, uid, photo_50"])
        
        request?.waitUntilDone = true
        request?.execute(resultBlock: {
            (res) in
            let json = res?.json
            let parsed = JSON(json)
            let arr = parsed["items"].array
            for item in arr!{
                self.friends.append(Person(id: item["id"].stringValue, name: item["first_name"].stringValue, surname: item["last_name"].stringValue, photo: item["photo_50"].stringValue))
                
            }
            self.performSegue(withIdentifier: "MainToNext", sender: self)
            },
                         errorBlock:
            {
                (err) in
                print(err)
        })
        
        
        let request2 = VKApi.users().get([VK_API_FIELDS : "first_name, last_name, uid, photo_200"])
        
        request2?.waitUntilDone = true
        request2?.execute(resultBlock: {
            (res) in
            let json = res?.json
            let parsed = JSON(json)
            print(parsed)
            let name = parsed[0]["first_name"].string
            let surname = parsed[0]["last_name"].string
            let photo = parsed[0]["photo_200"].string
            UserDefaults.standard.set("\(name!) \(surname!)", forKey: "name")
            UserDefaults.standard.set(photo!, forKey: "photo")
            },
                                       errorBlock:
            {
                (err) in
                print(err)
                
        })

        
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


