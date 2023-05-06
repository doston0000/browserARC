//
//  RootViewController.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import Foundation
import UIKit

final class RootViewController: UIViewController {
  private var current: UIViewController

  init() {
    current = SplashViewController()
    super.init(nibName:  nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(current)
    current.view.frame = view.bounds
    view.addSubview(current.view)
    current.didMove(toParent: self)
  }
  func switchToMainScreen() {
    let mainViewController = BrowserViewController()
    let mainScreen = DefaultNavigationController(rootViewController: mainViewController)
    animateFadeTransition(to: mainScreen)
  }
  
  private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
    current.willMove(toParent: nil)
    addChild(new)
    transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {

    }) { completed in
      self.current.removeFromParent()
      new.didMove(toParent: self)
      self.current = new
      completion?()
    }
  }
}
