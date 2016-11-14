//
//  FriendsListViewController.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import BTNavigationDropdownMenu

class FriendsListViewController: UIViewController {
  var friends = [Person]()
  var fullArr = [Person]()
  var shameList = [Person]()
  var selectedList = [Person]()

  var blurEffecNavBar : UIVisualEffectView?
  var statusBarView : UIView?
  var isProfileOpen = false
  let userId = UserDefaults.standard.value(forKey: "id") as? String ?? ""

    @IBOutlet weak var navigationBar: UINavigationItem!
  @IBOutlet weak var profileView: ProfileView!
  @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var searchBar: UISearchBar!
    let items = ["Друзья", "Взаимности", "Выбранные"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateListOfFilters(mainArr: friends)
        //let menuView = BTNavigationDropdownMenu(title: items[0], items: items as [AnyObject])
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Друзья", items: items as [AnyObject])
        menuView.menuTitleColor = UIColor.white
        menuView.navigationBarTitleFont = UIFont(name: "Drugs", size: 20)
        menuView.cellBackgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellSelectionColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Drugs", size: 20)
        menuView.cellTextLabelAlignment = .center
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.white
        menuView.cellSeparatorColor = UIColor.white
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            self.navigationBar.title = self.items[indexPath]
            self.selectedOtherList(i: indexPath)}
        self.navigationItem.titleView = menuView
        //menuView.show()
        setBarButton()
        self.view.backgroundColor = UIColor.clear
        navigationBarCustomization()
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
        let gradient = CAGradientLayer().makeLayer()
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
        
        // Do any additional setup after loading the view.
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }
    func selectedOtherList(i: Int){
        switch items[i] {
        case "Друзья":
            self.friends = self.fullArr
            tableView.reloadData()
        case "Взаимности":
            self.friends = self.shameList
            tableView.reloadData()
        case "Выбранные":
            self.friends = self.selectedList
            tableView.reloadData()
        default:
            break
        }
    }
    
    func updateListOfFilters(mainArr: [Person]){
        self.fullArr = self.friends
        self.selectedList = [Person]()
        self.shameList = [Person]()
        for i in self.friends{
            if(i.shame == "alone" || i.shame == "shame"){
                self.selectedList.append(i)
            }
        }
        for u in self.friends{
            if (u.shame == "shame") {
                self.shameList.append(u)
            }
        }
    }
    
    
    @IBAction func LogoutClicked(_ sender: UIButton) {
        UserDefaults.standard.set("", forKey: "id")
        profileView.fadeAway(hidenView: profileView)
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialVC")
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func likeClicked(button: UIButton) {
        let index = button.tag
        let state = self.friends[index].shame
        switch state {
        case "empty":
            let image = UIImage(named: "likefull")
            button.setImage(image, for: UIControlState())
            likeUserWithId(id: self.friends[index].id)
        case "alone":
            let image = UIImage(named: "like")
            button.setImage(image, for: UIControlState())
            cancelLikeUserWithId(id: self.friends[index].id)
        default:
            break;
        }
    }
    
    func likeUserWithId(id: Int){
        Alamofire.request("http://fastswapp.ru/shameButton?user_id=\(self.userId)&user_selected=\(id)", method: .get).responseJSON { response in
            self.reloadArrayFromDB()
            print("my id: \(self.userId) \n selected id: \(id)")
        }
    }
    
    func cancelLikeUserWithId(id:Int){
        Alamofire.request("http://fastswapp.ru/cancelButton?user_id=\(self.userId)&user_selected=\(id)", method: .get).responseJSON { response in
            self.reloadArrayFromDB()
            print("my id: \(self.userId) \n selected id: \(id)")
            }
        }
    
    func reloadArrayFromDB() {
        Alamofire.request("http://fastswapp.ru/friendsShow?user_id=\(self.userId)", method: .get).responseJSON { response in
            if let json = response.result.value {
                let resultArray = JSON(json).array
                self.friends = [Person]()
                for friend in resultArray!
                {
                    print("\(friend["id"].rawValue) \(friend["name"].string!) \(friend["photoURL"].string!) \(friend["shame"].string!)\n")
                    self.friends.append(Person(id: friend["id"].string!, name: friend["name"].string!, photo: friend["photoURL"].string!, shame: friend["shame"].string!))
                }
                self.updateListOfFilters(mainArr: self.friends)
                self.tableView.reloadData()
            }
        }
    }
    
    
  func myProfile(){
    
    if(isProfileOpen)
    {
        profileView.fadeAway(hidenView: profileView)
        self.isProfileOpen = false
    }
    else
    {
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    self.view.addGestureRecognizer(swipeRight)
    
        self.view.show(hidenView: profileView)
        self.profileView.vc = self
        self.isProfileOpen = true
    }
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
            cell?.buttonLike.tag = indexPath.row
            cell?.buttonLike.addTarget(self, action: #selector(likeClicked), for: .touchUpInside)
        //отображаем лайк из бд
        switch friends[indexPath.row].shame {
        case "shame":
            let image = UIImage(named: "likeDouble")
            cell?.buttonLike.setImage(image, for: UIControlState())
            break
        case "alone":
            let image = UIImage(named: "likefull")
            cell?.buttonLike.setImage(image, for: UIControlState())
            break
        default:
            let image = UIImage(named: "like")
            cell?.buttonLike.setImage(image, for: UIControlState())
            break
        }
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
    
    func gestureHandler(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                profileView.fadeAway(hidenView: profileView)
                self.isProfileOpen = false
                break;
            default:
                break;
            }
        }
    }

}
