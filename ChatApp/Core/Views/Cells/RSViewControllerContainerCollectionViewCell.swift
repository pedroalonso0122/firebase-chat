//
//  RSViewControllerContainerCollectionViewCell.swift
//  ListingApp
//
//  Created by Pedro Alonso on 6/12/20.
//

import UIKit

class RSViewControllerContainerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!

    func configure(viewModel: RSViewControllerContainerViewModel) {
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()

        let viewController = viewModel.viewController

        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        self.setNeedsLayout()
        viewModel.parentViewController?.addChild(viewModel.viewController)
    }
}
