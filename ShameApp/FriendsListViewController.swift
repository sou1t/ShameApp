//
//  FriendsListViewController.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import SDWebImage

class FriendsListViewController: UIViewController {
  var friends = [Person]()
  var blurEffecNavBar : UIVisualEffectView?
  var statusBarView : UIView?

  @IBOutlet weak var profileView: ProfileView!
  @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
        let gradient = CAGradientLayer().makeLayer()
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        navigationBarCustomization()
        setBarButton()
        // Do any additional setup after loading the view.
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }
  func myProfile(){
    self.view.show(hidenView: profileView)
  }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //кол-во элементов для каждой из секций
        return friends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //надо вернуть объект для отображения n-ной ячейки таблицы
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FriendTableViewCell
            cell?.selectionStyle = .none
            cell?.name.text = "\(friends[indexPath.row].name)"
            let p1 = friends[indexPath.row].photo
            let ph1 = URL(string: p1)
            cell?.photo.sd_setImage(with: ph1)
            return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //а это вызывается если юзер кликнул по какой-то ячейке
        UIApplication.shared.openURL(URL(string: "http://www.vk.com/id\(friends[indexPath.row].id)")!)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //а здесь нао вернуть кол-во секций(для простой таблицы это 1)
        return 1
    }
}
