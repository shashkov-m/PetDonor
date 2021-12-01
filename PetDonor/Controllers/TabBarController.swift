//
//  TabBarController.swift
//  PetDonor
//
//  Created by Shashkov Max on 30.11.2021.
//

import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let boardNC = UINavigationController (rootViewController: BoardTableViewController ())
    let articlesNC = UINavigationController (rootViewController: ArticlesTableViewController ())
    boardNC.tabBarItem = UITabBarItem (title: "Доска", image: UIImage(systemName: "face.smiling"), selectedImage: nil)
    articlesNC.tabBarItem = UITabBarItem (title: "Статьи", image: nil, selectedImage: nil)
    let items = [boardNC, articlesNC]
    items.forEach {
      $0.navigationBar.prefersLargeTitles = true
    }
    self.viewControllers = items
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    
  }
}
