//
//  BrowserViewModel.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import Foundation
import WebKit

protocol BrowserViewModelType {
  var url: URL? { get }
  var delegate: BrowserViewModelDelegate? { get set }
  func loadURL()
  func stopLoading()
  func reload()
  func goBack()
  func goForward()
}

protocol BrowserViewModelDelegate: AnyObject {
  func webViewDidStartLoading(with url: String?)
  func webViewDidLoad(with url: String?)
  func webViewDidFailLoading(error: Error)
}

final class BrowserViewModel: NSObject, BrowserViewModelType {
  var url: URL?
  weak var delegate: BrowserViewModelDelegate?
  private var webView: WKWebView?
  private var lastVisitedUrl: String?
  private let databaseService = DatabaseService()

  func setWebView(_ webView: WKWebView) {
    self.webView = webView
    webView.navigationDelegate = self
    if let url = webView.url?.absoluteString, url != lastVisitedUrl {
      lastVisitedUrl = url
    } else if lastVisitedUrl == nil {
      if let latestURL = databaseService.getLatestSavedURL() {
        lastVisitedUrl = latestURL
      }
    }
  }

  func loadURL() {
    guard let url = url else { return }
    let request = URLRequest(url: url)
    webView?.load(request)
  }
  func saveWebPage(date: Date) {
    guard let url = webView?.url?.absoluteString else {
      return
    }
    if url != lastVisitedUrl {
      databaseService.saveWebPage(url: url, date: date)
      lastVisitedUrl = url
    }
  }
  func getWebPages() -> [WebPage] {
    return databaseService.getWebPages()
  }
  func getLatestURL() -> URL? {
    return URL(string: databaseService.getLatestSavedURL() ?? "") 
  }
  func stopLoading() {
    webView?.stopLoading()
  }

  func reload() {
    webView?.reload()
  }

  func goBack() {
    webView?.goBack()
  }

  func goForward() {
    webView?.goForward()
  }
}

extension BrowserViewModel: WKNavigationDelegate {
  func webView(
    _ webView: WKWebView,
    didStartProvisionalNavigation navigation: WKNavigation!)
  {
    delegate?.webViewDidStartLoading(with: webView.url?.absoluteString)
  }

  func webView(
    _ webView: WKWebView,
    didFinish navigation: WKNavigation!) {
      delegate?.webViewDidLoad(with: webView.url?.absoluteString)
      saveWebPage(date: Date())
    }

  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error) {
      delegate?.webViewDidFailLoading(error: error)
    }
}

