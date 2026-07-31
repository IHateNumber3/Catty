/**
 *  Copyright (C) 2010-2024 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

@objc enum AppTheme: Int {
    case system = 0
    case light = 1
    case dark = 2

    var localizedTitle: String {
        switch self {
        case .system: return kLocalizedThemeSystem
        case .light: return kLocalizedThemeLight
        case .dark: return kLocalizedThemeDark
        }
    }

    @available(iOS 13.0, *)
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}

@objc
class ThemesHelper: NSObject {

    @objc static var currentTheme: AppTheme {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: kAppTheme)
            return AppTheme(rawValue: rawValue) ?? .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: kAppTheme)
            applyCurrentTheme()
        }
    }

    @objc static func applyCurrentTheme() {
        guard #available(iOS 13.0, *) else { return }

        let style = currentTheme.interfaceStyle
        UIApplication.shared.windows.forEach { $0.overrideUserInterfaceStyle = style }
    }

    @objc static func changeAppearance() {
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.default

        if #available(iOS 13.0, *) {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.globalTint
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.background], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.globalTint], for: .normal)
        }

        UINavigationBar.appearance(whenContainedInInstancesOf: [UIDocumentBrowserViewController.self]).tintColor = UIColor.navBar

        applyCurrentTheme()
    }
}
