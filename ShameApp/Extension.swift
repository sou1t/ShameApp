//
//  Extension.swift
//  ShameApp
//
//  Created by AnarGuseynov on 11.11.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
  open func show(hidenView: UIView){
    hidenView.center.x += hidenView.bounds.width
    hidenView.alpha = 1
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
      hidenView.isHidden = false
      hidenView.center.x -= hidenView.bounds.width
      self.addSubview(hidenView)
    }, completion: nil)
  }
  open func fadeAway(hidenView: UIView){
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
      hidenView.center.x += hidenView.bounds.width
    }, completion: nil)  }
}
extension FriendsListViewController{
  func navigationBarCustomization(){
    if self.blurEffecNavBar == nil{
      let blurEffect = UIBlurEffect(style: .light)
      blurEffecNavBar = UIVisualEffectView(effect: blurEffect)
      blurEffecNavBar?.isUserInteractionEnabled = false
      blurEffecNavBar?.frame = (self.navigationController?.navigationBar.bounds)!
      blurEffecNavBar?.bounds.offsetBy(dx: 0.0, dy: 0.0)
      blurEffecNavBar?.bounds.size.height = (blurEffecNavBar?.bounds.height)! + 40.0
      self.view.addSubview(blurEffecNavBar!)
    }
    self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController!.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    statusBarView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
    statusBarView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    self.view.addSubview(statusBarView!)
    let attrs = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont(name: "drugs", size: 24)!
    ]
    self.navigationController?.navigationBar.titleTextAttributes = attrs
    title = "Друзья"
  }
  func setBarButton(){
    let rightButton = UIButton()
    rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    rightButton.setImage(UIImage(named: "profileButton"), for: UIControlState())
    rightButton.addTarget(self, action: #selector(myProfile), for: .touchUpInside)
    let rightBarButton = UIBarButtonItem()
    rightBarButton.customView = rightButton

    self.navigationItem.setRightBarButton(rightBarButton, animated: true)
  }
}

