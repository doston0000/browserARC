//
//  HistoryViewController.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/6/23.
//

import UIKit

struct WebPage {
  let id: Int64
  let url: String
  let date: Date
}
protocol HistoryIxResponder:AnyObject {
  func selected(url: URL)
}
final class HistoryViewController: UIViewController {
  private var webPages: [WebPage] = []
  private let tableView = UITableView()
  weak var delegate: HistoryIxResponder?
  init(webPages: [WebPage]) {
    self.webPages = webPages
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    initBaseAbility()
  }
  override func initUI() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  override func initBinding() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension HistoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return webPages.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let webPage = webPages[indexPath.row]
    cell.textLabel?.text = webPage.url
    return cell
  }
}

extension HistoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dismiss(animated: true) {
      if let url = URL(string: self.webPages[indexPath.row].url) {
        self.delegate?.selected(url: url)
      }
    }
  }
}
