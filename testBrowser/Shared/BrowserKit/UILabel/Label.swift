//
//  Label.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import UIKit

final class Label: UILabel {
  init(font: UIFont?, lines: Int, color: UIColor?,text:String = "") {
    super.init(frame: .zero)
    self.font = font
    self.numberOfLines = lines
    self.textColor = color
    self.text = text
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

extension Label {
  func addCharacterSpacing(kernValue: Double ) {
    if let labelText = text, !labelText.isEmpty {
      let attributedString = NSMutableAttributedString(string: labelText)
      attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
