//
//  AppDelegate.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = RootViewController()
    self.window?.makeKeyAndVisible()
    initConfig()
    return true
  }
  private func initConfig() {
    Colors.theme = Theme(rawValue: AppPreferences.shared.theme) ?? .light
  }
}

extension AppDelegate {
  static var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  var rootViewController: RootViewController {
    return window!.rootViewController as! RootViewController
  }
}
