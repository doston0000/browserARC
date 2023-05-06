//
//  DefaultNavigationController.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import Foundation
import UIKit

class DefaultNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    let font = UIFont.systemFont(ofSize: 16, weight: .medium)
    let largeTitleColor = Colors.black
    let largeTitleFont = UIFont.systemFont(ofSize: 24, weight: .medium)
    let backgroundColor = Colors.background
    navigationBar.isTranslucent = false
    navigationBar.tintColor = Colors.black
    navigationBar.prefersLargeTitles = true
    navigationBar.layoutMargins.left = 24
    navigationBar.layoutMargins.right = 24
    //interactivePopGestureRecognizer?.isEnabled = false
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:largeTitleColor,
                                            NSAttributedString.Key.font: font]
    navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:largeTitleColor,
                                                 NSAttributedString.Key.font: largeTitleFont]
    navBarAppearance.shadowImage = UIImage()
    let backImage = UIImage(named: "ic_back")
    navBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
    navBarAppearance.backgroundColor = backgroundColor
    navBarAppearance.shadowColor = .clear
    navigationBar.standardAppearance = navBarAppearance
    navigationBar.compactAppearance = navBarAppearance
    navigationBar.scrollEdgeAppearance = navBarAppearance
  }
}
extension DefaultNavigationController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "", style: .plain, target: nil, action: nil)
  }
}
