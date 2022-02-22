//
//  FAQViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 22.02.2022.
//

import UIKit

class FAQViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var postTypeButton: UIButton!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      buttonMenuConfigure()
    }
  
  private func buttonMenuConfigure () {
    let donor = UIAction (title: "Донору") { _ in }
    let recipient = UIAction (title: "Реципиенту") { _ in }
    let menu = UIMenu (title: "", options: [.singleSelection, .displayInline], children: [recipient, donor])
    postTypeButton.menu = menu
    postTypeButton.changesSelectionAsPrimaryAction = true
    postTypeButton.showsMenuAsPrimaryAction = true
  }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell ()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}
