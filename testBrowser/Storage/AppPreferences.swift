//
//  AppPreferences.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/5/23.
//

import Foundation
import UIKit

final public class AppPreferences {
    /// The only instance of class
    public static var shared: AppPreferences = AppPreferences()
    private let standard = UserDefaults(suiteName: "group.browser")!

    /// The style of the device’s status bar.
    public var preferredStatusBarStyle: UIStatusBarStyle = .default

    public var isNetworkReachable: (() -> Bool)?

    /// Detects first launch
    public var isAppLaunchedBefore: Bool {
        get { standard.bool(forKey: Key.firstAccess.rawValue )}
        set { standard.set(newValue, forKey: Key.firstAccess.rawValue)}
    }

    public var theme: String {
        get { standard.string(forKey: Key.theme.rawValue ) ?? Theme.light.rawValue}
        set { standard.set(newValue,forKey: Key.theme.rawValue )}
    }

    public func store(value: Any?, forKey key: String) {
        standard.setValue(value, forKey: key)
    }

    public func takeValue(forKey key: String) -> Any? {
        standard.value(forKey: key)
    }

    public func clear(completion: @escaping (Error?)->()) {
      UserPreferences.shared.clear()
      completion(nil)
    }
}

fileprivate extension AppPreferences {
    enum Key: String {
        case firstAccess = "APP-PREFERENCES-FIRST-ACCESS"
        case theme = "APP-PREFERENCES-THEME"
    }
}

/// Current user's data
final public class UserPreferences {
    /// The only instance of class
    public static var shared: UserPreferences {
        UserPreferences()
    }

    internal let standard = UserDefaults(suiteName: "group.browser")!

    private init() { }

    public func clear() {
      /// Clear user data here
    }
}
