//
//  Base.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import Foundation
import UIKit

protocol BaseAbility: AnyObject {
  func initBaseAbility()
  /// Init Common
  /// Intent to do everything common here
  func initCommon()
  /// UI
  /// To do all things about UI
  func initUI()
  /// Binding
  func initBinding()
  /// Action
  func initActions()
}


//
// MARK: - Default Extension
/*
 The reason we why can't override ViewController's ViewDidLoad in extenstion, 'cause Swift protocol don't allow we do that
 So we need create seperate method to call it manaully
 */
extension BaseAbility {
  func initBaseAbility() {
    self.initUI()
    self.initCommon()
    self.initBinding()
    self.initActions()
  }
}
extension UIViewController: BaseAbility {
  @objc func initCommon() {}
  @objc func initUI() {}
  @objc func initBinding() {}
  @objc func initActions() {}
}

protocol ViewSpecificController {
  associatedtype RootView: UIView
}

extension ViewSpecificController where Self: UIViewController {
  func view() -> RootView {
    return self.view as! RootView
  }
}

