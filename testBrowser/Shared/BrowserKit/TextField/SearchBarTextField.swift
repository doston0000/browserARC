//
//  SearchBarTextField.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import UIKit

struct SearchItem {
  var icon:UIImage?
  var action:(()->Void)?
}

final class SearchBarTextField: UITextField {
  private var leftItems:[SearchItem]?
  private var righItems:[SearchItem]?
  private var searchAction:(()->Void)?
  var isSearching:Bool {
    return !(text?.isEmpty ?? false)
  }
  init(
    placeholderText: String? = nil,
    leftItems:[SearchItem]? = nil,
    righItems:[SearchItem]? = nil,
    searchAction:(()->Void)? = nil) {
      super.init(frame: .zero)
      self.leftItems = leftItems
      self.righItems = righItems
      self.searchAction = searchAction
      self.setLeftView(leftItems)
      self.setRightView(righItems)
      self.attributedPlaceholder = NSAttributedString(
        string: placeholderText ?? "",
        attributes: [NSAttributedString.Key.foregroundColor: Colors.black.withAlphaComponent(0.3)])
      initUI()
    }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  private func initUI() {
    self.textColor = Colors.black
    self.font = .systemFont(ofSize: 16)
    self.borderStyle = UITextField.BorderStyle.roundedRect
    self.keyboardType = .webSearch
    self.layer.cornerRadius = 8
    self.backgroundColor = Colors.background
    self.autocapitalizationType = .none
    self.autocorrectionType = .no
    self.tintColor = Colors.black
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.heightAnchor.constraint(equalToConstant: 48)
    ])
  }
  private func setLeftView(_ items:[SearchItem]?) {
    self.leftViewMode = .always
    guard let items = items else {
      self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 24))
      return
    }
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    for (index, item) in items.enumerated() {
      let tempButton = UIButton(type: .custom)
      tempButton.setImage(item.icon, for: .normal)
      tempButton.tag = index
      tempButton.addTarget(self, action: #selector(setLeftAction(sender:)), for: .touchUpInside)
      stackView.addArrangedSubview(tempButton)
    }
    self.leftView = stackView
  }

  private func setRightView(_ items:[SearchItem]?) {
    let spacerView = UIView(frame: CGRect(x: frame.width - 12, y: 0, width: 12, height: 24))
    guard let items = items else {
      self.rightView = spacerView
      return
    }
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    self.rightViewMode = .always

    for (index, item) in items.enumerated() {
      let tempButton = UIButton(type: .custom)
      tempButton.tintColor = Colors.main
      tempButton.setImage(item.icon, for: .normal)
      tempButton.tag = index
      tempButton.addTarget(self, action: #selector(setRightAction(sender:)), for: .touchUpInside)
      stackView.addArrangedSubview(tempButton)
    }
    stackView.addArrangedSubview(spacerView)
    self.rightView = stackView
  }

  @objc func setLeftAction(sender: UIButton) {
    guard let leftItems = leftItems, let action = leftItems[sender.tag].action else { return }
    action()
  }

  @objc func setRightAction(sender: UIButton) {
    guard let rightItems = righItems, let action = rightItems[sender.tag].action else { return }
    action()
  }

  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }

  @objc fileprivate func doneButtonAction() {
    self.resignFirstResponder()
    searchAction?()
  }
}
