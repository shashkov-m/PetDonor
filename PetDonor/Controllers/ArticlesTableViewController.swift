//
//  ArticalsTableViewController.swift
//  PetDonor
//
//  Created by Shashkov Max on 30.11.2021.
//

import UIKit

class ArticlesTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Статьи"
    //navigationController?.navigationBar.prefersLargeTitles = true
    tableView.register(UINib (nibName: ArticlesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
    searchBarSetup()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier, for: indexPath) as! ArticlesTableViewCell
    cell.articleLabel.text = "Тут какая-то статья и не много текста заголовка"
    cell.articleImage.image = #imageLiteral(resourceName: "photo_2021-12-02 18.29.33")
    cell.articleImage.contentMode = .scaleAspectFill
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let vc = ArticleViewController (article: "Some Article")
    show(vc, sender: self)
  }
}


//search bar setup
extension ArticlesTableViewController {
  private func searchBarSetup () {
    let searchController = UISearchController (searchResultsController: nil)
    searchController.searchBar.placeholder = "Поиск"
    searchController.searchBar.barStyle = .default
    navigationItem.searchController = searchController
  }
}
