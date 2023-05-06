//
//  SplashViewController.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//
import Foundation
import UIKit


final class SplashViewController: UIViewController {
  lazy var image:UIImageView  = {
    let image = UIImageView()
    image.image = UIImage(named: "ic_logo")
    image.contentMode = .scaleAspectFit
    return image
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(image)
    image.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      image.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    view.backgroundColor = Colors.main
    makeServiceCall()
  }
  private func makeServiceCall() {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + .seconds(2),
      execute: {
        AppDelegate.shared.rootViewController.switchToMainScreen()
      })
  }
}

