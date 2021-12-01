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
    tableView.register(UINib (nibName: ArticlesTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier, for: indexPath) as! ArticlesTableViewCell
    cell.label.text = "Some article here"
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let vc = ArticleViewController (article: "Some Article")
    show(vc, sender: self)
  }
}
