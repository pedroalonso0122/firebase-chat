//
//  UIImage+Additions.swift
//  ShoppingApp
//
//  Created by Pedro Alonso on 8/29/17.
//

import UIKit

extension UIImage {
    static func localImage(_ name: String, template: Bool = false) -> UIImage {
        var image = UIImage(named: name)!
        if template {
            image = image.withRenderingMode(.alwaysTemplate)
        }
        return image
    }
}
