//
//  BrowserViewController.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import UIKit

final class BrowserViewController: UIViewController {
  private var containerView: BrowserView?
  private let viewModel = BrowserViewModel()
  override func viewDidLoad() {
    super.viewDidLoad()
    initBaseAbility()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  override func initUI() {
    let containerView = BrowserView()
    containerView.delegate = self
    view.addSubview(containerView)
    self.containerView = containerView

    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: view.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  override func initCommon() {
   /// Get latest vaild url from db like any browser does
    guard let url = viewModel.getLatestURL() else {return}
    loadURL(url)
  }
  func loadURL(_ url: URL) {
    viewModel.url = url
    containerView?.configure(with: viewModel)
    containerView?.loadURL()
  }

  func stopLoading(_ sender: Any) {
    containerView?.stopLoading()
  }
  func reload(_ sender: Any) {
    containerView?.reload()
  }
  func goBack(_ sender: Any) {
    containerView?.goBack()
  }
  func goForward(_ sender: Any) {
    containerView?.goForward()
  }
}

extension BrowserViewController: BrowserIxResponder, HistoryIxResponder {
  func onHistoryClick() {
    let vc = HistoryViewController(webPages: viewModel.getWebPages())
    vc.delegate = self
    self.navigationController?.present(vc, animated: true)
  }

  func loadWeb(with url: URL) {
    loadURL(url)
  }

  func selected(url: URL) {
    loadURL(url)
  }
}
