//
//  Colors.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import Foundation
import UIKit

final class Colors {
  static var theme: Theme = .light {
    didSet {
      ThemeSetter.set()
    }
  }
  static var main:UIColor =  #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.9529411765, alpha: 1) // DADAF3
  static var black = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1) // 1E1E1E
  static var background = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //
}

final class ThemeSetter {
  static func set() {
    AppPreferences.shared.theme = Colors.theme.rawValue
    switch Colors.theme {
    case .light:
      Colors.black = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
      Colors.background = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    case .dark:
      Colors.black = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      Colors.background = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
    }
  }
}

public enum Theme: String {
  case light
  case dark

  static func currentTheme() -> Theme {
    return Theme(rawValue: AppPreferences.shared.theme) ?? .dark
  }
}
