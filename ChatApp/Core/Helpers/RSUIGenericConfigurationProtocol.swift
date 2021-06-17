//
//  RSUIGenericConfigurationProtocol.swift
//  ListingApp
//
//  Created by Pedro Alonso on 6/9/20.
//

import UIKit

protocol RSUIGenericConfigurationProtocol {
    var mainThemeBackgroundColor: UIColor {get}
    var mainThemeForegroundColor: UIColor {get}
    var mainTextColor: UIColor {get}
    var mainSubtextColor: UIColor {get}
    var hairlineColor: UIColor {get}

    var statusBarStyle: UIStatusBarStyle {get}

    var regularSmallFont: UIFont {get}
    var regularMediumFont: UIFont {get}
    var regularLargeFont: UIFont {get}
    var mediumBoldFont: UIFont {get}

    var boldSmallFont: UIFont {get}
    var boldLargeFont: UIFont {get}
    var boldSuperLargeFont: UIFont {get}

    var italicMediumFont: UIFont {get}

    func regularFont(size: CGFloat) -> UIFont
}
