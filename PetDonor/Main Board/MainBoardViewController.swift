//
//  MainBoardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit
import Firebase

protocol MainBoardViewControllerDelegate:AnyObject {
  func updateFilter (filter: [String:Any])
}

class MainBoardViewController: UIViewController {
  private let db = Database ()
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var postTypeSegmentedControl: UISegmentedControl!
  private var lastSnapshot:QueryDocumentSnapshot?
  private var isQueryRunning = false
  private let toPetCardSegueIdentifier = "toPetCard"
  private let toFiltersListSegueIdentifier = "toFiltersList"
  private var pet:Pet?
  private var pets = [Pet] () {
    didSet {
      guard tableView.window != nil else { return }
      tableView.reloadSections(IndexSet (integer: 0), with: .fade)
    }
  }
  
  var filter:[String : Any] = [PetKeys.postType.rawValue : PostType.recipient.rawValue] {
    didSet {
      guard view.window != nil else { return }
      reloadPetList (filter: filter)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register (UINib (nibName: BoardTextOnlyTableViewCell.identifier, bundle: nil),
                        forCellReuseIdentifier: BoardTextOnlyTableViewCell.identifier)
    tableView.register (UINib (nibName: BoardImageTableViewCell.identifier, bundle: nil),
                        forCellReuseIdentifier: BoardImageTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
    postTypeSegmentedControlConfigure ()
    refreshControlConfigure ()
    let (right, left) = swipeGesturesConfigure (target: self, rightAction: #selector(rightSwipeAction(_:)), leftAction: #selector(leftSwipeAction(_:)))
    tableView.addGestureRecognizer(right)
    tableView.addGestureRecognizer(left)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print ("Will appear")
    reloadPetList(filter: filter)
  }
  
  private func refreshControlConfigure () {
    let refreshControl = UIRefreshControl ()
    refreshControl.addTarget(self, action: #selector(updatePetList), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  private func postTypeSegmentedControlConfigure () {
    let recipientAction = UIAction (title:"Реципиенты") { [weak self] _ in
      guard let self = self else { return }
      self.filter.updateValue(PostType.recipient.rawValue, forKey: PetKeys.postType.rawValue)
    }
    let donorAction = UIAction (title:"Доноры") { [weak self] _ in
      guard let self = self else { return }
      self.filter.updateValue(PostType.donor.rawValue, forKey: PetKeys.postType.rawValue)
    }
    postTypeSegmentedControl.setAction(recipientAction, forSegmentAt: 0)
    postTypeSegmentedControl.setAction(donorAction, forSegmentAt: 1)
  }
  
  private func reloadPetList (filter: [String : Any]) {
    isQueryRunning = true
    Task {
      do {
        let snapshot = try await db.getPetsWithFilter(filter: filter)
        pets = db.convertSnapshotToPet(snapshot: snapshot)
        isQueryRunning = false
        lastSnapshot = snapshot.documents.last
      }
    }
  }
  
  @objc private func updatePetList () {
    guard let refreshControl = tableView.refreshControl, !isQueryRunning else { return }
    reloadPetList(filter: filter)
    refreshControl.endRefreshing()
  }
  
  @IBAction func filterViewButtonAction(_ sender: Any) {
    performSegue(withIdentifier: toFiltersListSegueIdentifier, sender: self)
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toPetCardSegueIdentifier, let destinationVC = segue.destination as? PetCardViewController, let pet = pet {
      destinationVC.pet = pet
    } else if segue.identifier == toFiltersListSegueIdentifier, let destinationVC = segue.destination as? FiltersViewController {
      destinationVC.filter = filter
      destinationVC.delegate = self
    }
  }
  
  private func swipeGesturesConfigure (target:Any?, rightAction:Selector?,leftAction:Selector?) -> (rightGesture : UISwipeGestureRecognizer,leftGesture :  UISwipeGestureRecognizer) {
    let rightSwipe = UISwipeGestureRecognizer (target: target, action: rightAction)
    rightSwipe.numberOfTouchesRequired = 1
    rightSwipe.direction = .right
    let leftSwipe = UISwipeGestureRecognizer (target: target, action: leftAction)
    leftSwipe.numberOfTouchesRequired = 1
    leftSwipe.direction = .left
    return (rightSwipe, leftSwipe)
  }
  
  @objc private func rightSwipeAction (_ gesture:UISwipeGestureRecognizer) {
    guard postTypeSegmentedControl.selectedSegmentIndex != 0 else { return }
    postTypeSegmentedControl.selectedSegmentIndex = 0
    let action = postTypeSegmentedControl.actionForSegment(at: 0)
    if let action = action {
      postTypeSegmentedControl.sendAction(action)
    }
  }
  
  @objc private func leftSwipeAction (_ gesture:UISwipeGestureRecognizer) {
    guard postTypeSegmentedControl.selectedSegmentIndex != 1 else { return }
    postTypeSegmentedControl.selectedSegmentIndex = 1
    let action = postTypeSegmentedControl.actionForSegment(at: 1)
    if let action = action {
      postTypeSegmentedControl.sendAction(action)
    }
  }
}
//MARK: UITableViewDelegate
extension MainBoardViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let pet = pets [indexPath.row]
    if let ref = pet.imageUrl, ref.count > 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: BoardImageTableViewCell.identifier, for: indexPath) as! BoardImageTableViewCell
      let reference = db.getImageReference(from: ref)
      let placeholder = pet.petType == .cat ? UIImage (named: "catPlaceholder") : UIImage (named: "dogPlaceholder")
      cell.petImageView.sd_setImage(with: reference, placeholderImage: placeholder)
      cell.petTypeLabel.text = pet.petType?.rawValue
      cell.summaryLabel.text = pet.description
      cell.cityLabel.text = pet.city?.title
      if let dateCreate = pet.dateCreate {
        let date = petDateFormatter.string(from: dateCreate)
        cell.dateCreateLabel.text = date
      }
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: BoardTextOnlyTableViewCell.identifier, for: indexPath) as! BoardTextOnlyTableViewCell
      cell.petTypeLabel.text = pet.petType?.rawValue
      cell.summaryLabel.text = pet.description
      cell.cityLabel.text = pet.city?.title
      if let dateCreate = pet.dateCreate {
        let date = petDateFormatter.string(from: dateCreate)
        cell.dateCreateLabel.text = date
      }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pet = pets [indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: toPetCardSegueIdentifier, sender: self)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let snapshot = lastSnapshot, !isQueryRunning else { return }
    if pets.count >= 7, indexPath.row == pets.count - 2 {
      isQueryRunning = true
      Task {
        do {
          let snapshot = try await db.getNextPetsPart(from: snapshot, filterOrNil: filter)
          let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
          print (petsArray)
          for pet in petsArray {
            pets.append(pet)
          }
          lastSnapshot = snapshot.documents.last
        }
        isQueryRunning = false
      }
    }
  }
}

extension MainBoardViewController:MainBoardViewControllerDelegate {
  func updateFilter(filter: [String : Any]) {
    self.filter = filter
  }
}
