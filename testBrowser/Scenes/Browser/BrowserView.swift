//
//  BrowserView.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import UIKit
import WebKit

protocol BrowserIxResponder: AnyObject {
  func loadWeb(with url: URL)
  func onHistoryClick()
}

final class BrowserView: UIView {
  private var webView: WKWebView?
  private var viewModel: BrowserViewModelType?
  weak var delegate: BrowserIxResponder?
  private(set) lazy var searchBar: SearchBarTextField = {
    let item = SearchItem(icon: .init(systemName: "magnifyingglass"))
    let textField = SearchBarTextField(placeholderText: "Search", righItems: [item])
    textField.delegate = self
    return textField
  }()
  private(set) lazy var historyButton: UIButton = {
    let item = UIButton(type: .custom)
    item.setImage(.init(systemName: "book"), for: .normal)
    item.addTarget(self, action: #selector(onHistoryClick), for: .touchUpInside)
    item.tintColor = Colors.black
    return item
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.main
    setupSearchBar()
    setupWebView()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func configure(with viewModel: BrowserViewModelType) {
    self.viewModel = viewModel
    guard let webView = webView else { return }
    (viewModel as? BrowserViewModel)?.setWebView(webView)
    (viewModel as? BrowserViewModel)?.delegate = self
  }
  private func setupSearchBar() {
    addSubview(searchBar)
    addSubview(historyButton)
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    historyButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
      searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      searchBar.trailingAnchor.constraint(equalTo: historyButton.leadingAnchor, constant: -4),
      searchBar.heightAnchor.constraint(equalToConstant: 48)
    ])
    NSLayoutConstraint.activate([
      historyButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
      historyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      historyButton.heightAnchor.constraint(equalToConstant: 48),
      historyButton.widthAnchor.constraint(equalToConstant: 48)
    ])
  }
  private func setupWebView() {
    let webView = WKWebView(frame: bounds)
    self.webView = webView
    addSubview(webView)

    webView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  func loadURL() {
    viewModel?.loadURL()
    setTitle(url: viewModel?.url?.absoluteString ?? "")
  }

  func stopLoading() {
    viewModel?.stopLoading()
  }

  func reload() {
    viewModel?.reload()
  }

  func goBack() {
    viewModel?.goBack()
  }

  func goForward() {
    viewModel?.goForward()
  }

  @objc private func onHistoryClick() {
    delegate?.onHistoryClick()
  }
  func setTitle(url: String) {
    searchBar.text = url
  }
}

extension BrowserView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let urlString = textField.text,
            let url = URL(string: "https://\(urlString.replacingOccurrences(of: "https://", with: ""))") else {return false}
    delegate?.loadWeb(with: url)
    return true
  }
}

extension BrowserView: BrowserViewModelDelegate {
  func webViewDidStartLoading(with url: String?) {
    setTitle(url: url ?? "")
    // TODO: show loading indicator or perform other UI updates
  }

  func webViewDidLoad(with url: String?) {
    setTitle(url: url ?? "")
    // TODO: hide loading indicator or perform other UI updates
  }

  func webViewDidFailLoading(error: Error) {
    // TODO: handle error or perform other UI updates
    print(error.localizedDescription)
  }
}
