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
  private var donorInfoKeys = [String] ()
  private var donorInfoValues = [String] ()
  private var recipientInfoKeys = [String] ()
  private var recipientInfoValues = [String] ()
  private var displayedInfoKeys = [String] ()
  private var displayedInfoValues = [String] ()
  private var isDonorSelected = false {
    willSet {
      if newValue == true {
        displayedInfoKeys = donorInfoKeys
        displayedInfoValues = donorInfoValues
      } else {
        displayedInfoKeys = recipientInfoKeys
        displayedInfoValues = recipientInfoValues
      }
      tableView.reloadSections(IndexSet (integer: 0), with: .fade)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib (nibName: FAQTableViewCell.identifier, bundle: nil), forCellReuseIdentifier:FAQTableViewCell.identifier)
    getFAQArrays()
    buttonMenuConfigure()
  }
  
  private func buttonMenuConfigure () {
    let donor = UIAction (title: "Донору") { [weak self] _ in
      guard let self = self else { return }
      self.isDonorSelected = true
    }
    let recipient = UIAction (title: "Реципиенту") { [weak self] _ in
      guard let self = self else { return }
      self.isDonorSelected = false
    }
    let menu = UIMenu (title: "", options: [.singleSelection, .displayInline], children: [recipient, donor])
    postTypeButton.menu = menu
    postTypeButton.changesSelectionAsPrimaryAction = true
    postTypeButton.showsMenuAsPrimaryAction = true
  }
  
  private func getFAQArrays () {
    guard let path = Bundle.main.url(forResource: "FAQ", withExtension: ".plist") else { return }
    do {
      let data = try Data (contentsOf: path)
      if let dictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String : Any] {
        if let donorInfoValues = dictionary ["DonorInfoValues"] as? [String] {
          self.donorInfoValues = donorInfoValues
        }
        if let donorInfoKeys = dictionary ["DonorInfoKeys"] as? [String] {
          self.donorInfoKeys = donorInfoKeys
        }
        if let recipientInfoValues = dictionary ["RecipientInfoValues"] as? [String] {
          self.recipientInfoValues = recipientInfoValues
        }
        if let recipientInfoKeys = dictionary ["RecipientInfoKeys"] as? [String] {
          self.recipientInfoKeys = recipientInfoKeys
        }
        isDonorSelected = false
      }
    }
    catch {
      return
    }
  }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    displayedInfoKeys.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.identifier, for: indexPath) as! FAQTableViewCell
    let question = displayedInfoKeys [indexPath.row]
    let answer = displayedInfoValues [indexPath.row]
    cell.questionLabel.text = question
    cell.answerLabel.text = answer
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}
