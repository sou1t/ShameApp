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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer().makeLayer()
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //кол-во элементов для каждой из секций
        return friends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //надо вернуть объект для отображения n-ной ячейки таблицы
        
        if (self.friends.count == 0)
        {
            print("NUUUUUUUUUUUUUUL")
            tableView.reloadData()
            return tableView.dequeueReusableCell(withIdentifier: "cell")!
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FriendTableViewCell
            cell.name.text = "\(friends[indexPath.row].name)"
            let p1 = friends[(indexPath as NSIndexPath).row].photo
            let ph1 = URL(string: p1)
            cell.photo.sd_setImage(with: ph1)
            return cell
        }
        
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
