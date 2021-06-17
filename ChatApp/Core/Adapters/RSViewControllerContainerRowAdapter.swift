//
//  RSViewControllerContainerRowAdapter.swift
//  ListingApp
//
//  Created by Pedro Alonso on 6/12/20.
//

import UIKit

class RSViewControllerContainerRowAdapter: RSGenericCollectionRowAdapter {
    func configure(cell: UICollectionViewCell, with object: RSGenericBaseModel) {
        guard let viewModel = object as? RSViewControllerContainerViewModel, let cell = cell as? RSViewControllerContainerCollectionViewCell else { return }
        cell.configure(viewModel: viewModel)
    }

    func cellClass() -> UICollectionViewCell.Type {
        return RSViewControllerContainerCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: RSGenericBaseModel) -> CGSize {
        guard let viewModel = object as? RSViewControllerContainerViewModel else { return .zero }
        var height: CGFloat
        if let cellHeight = viewModel.cellHeight {
            height = cellHeight
        } else if let collectionVC = viewModel.viewController as? RSGenericCollectionViewController,
            let dataSource = collectionVC.genericDataSource,
            let subcellHeight = viewModel.subcellHeight {
            height = CGFloat(dataSource.numberOfObjects()) * subcellHeight
        } else {
            fatalError("Please provide a mechanism to compute the cell height")
        }
        return CGSize(width: containerBounds.width, height: height)
    }
}
