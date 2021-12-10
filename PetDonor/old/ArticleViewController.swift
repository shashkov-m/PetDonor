//
//  ArticleViewController.swift
//  PetDonor
//
//  Created by Shashkov Max on 01.12.2021.
//

import UIKit

class ArticleViewController: UIViewController {
  let article:String
  let label = UILabel ()
  let scrollView = UIScrollView ()
  
  init (article:String) {
    self.article = article
    super.init (nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    title = article
    navigationController?.navigationBar.prefersLargeTitles = true
    view.backgroundColor = .systemBackground
    configureArticle()
  }
  private func configureArticle () {
    let viewForScroll = UIView ()
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    label.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsVerticalScrollIndicator = true
    viewForScroll.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    
    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
    viewForScroll.addSubview(label)
    scrollView.addSubview(viewForScroll)
    
    viewForScroll.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    viewForScroll.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    viewForScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    viewForScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    label.topAnchor.constraint(equalTo: viewForScroll.topAnchor, constant: 8).isActive = true
    label.leftAnchor.constraint(equalTo: viewForScroll.leftAnchor, constant: 18).isActive = true
    label.rightAnchor.constraint(equalTo: viewForScroll.rightAnchor, constant: -18).isActive = true
    label.bottomAnchor.constraint(equalTo: viewForScroll.bottomAnchor, constant: -8).isActive = true
    label.numberOfLines = 0
    label.textAlignment = .left
    label.font = UIFont (name: "HelveticaNeue-Light", size: 20)
    label.text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
  }
}
