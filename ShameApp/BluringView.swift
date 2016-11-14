//
//  BluringView.swift
//  ShameApp
//
//  Created by AnarGuseynov on 11.11.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class BluringView: UIView {
  var bluringView : UIVisualEffectView?
  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
    let blurEffect = UIBlurEffect(style: .dark)
    bluringView = UIVisualEffectView(effect: blurEffect)
    bluringView?.isUserInteractionEnabled = false
    bluringView?.frame = self.bounds
    bluringView?.bounds.offsetBy(dx: 0.0, dy: 0.0)
    self.addSubview(bluringView!)
  }
}
