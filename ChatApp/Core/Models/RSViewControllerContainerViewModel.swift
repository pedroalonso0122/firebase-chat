//
//  RSViewControllerContainerModel.swift
//  ListingApp
//
//  Created by Pedro Alonso on 6/12/20.
//

import UIKit

class RSViewControllerContainerViewModel: RSGenericBaseModel {

    var description: String = "Carousel"

    let cellHeight: CGFloat?
    let subcellHeight: CGFloat?
    var viewController: UIViewController
    weak var parentViewController: UIViewController?

    init(viewController: UIViewController, cellHeight: CGFloat? = nil, subcellHeight: CGFloat? = nil) {
        self.cellHeight = cellHeight
        self.subcellHeight = subcellHeight
        self.viewController = viewController
        if let _ = cellHeight, let _ = subcellHeight {
            fatalError("Choose either static or dynamic size. You can have both.")
        }
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}
