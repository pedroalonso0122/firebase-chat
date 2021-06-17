//
//  RSStoryAdapter.swift
//  RestaurantApp
//
//  Created by Pedro Alonso on 5/15/20.
//

import UIKit

class RSStoryAdapter: RSGenericCollectionRowAdapter {
    let uiConfig: RSUIGenericConfigurationProtocol
    init(uiConfig: RSUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: RSGenericBaseModel) {
        guard let viewModel = object as? RSStoryViewModel, let cell = cell as? RSStoryCollectionViewCell else { return }
        cell.configure(viewModel: viewModel, uiConfig: uiConfig)
    }

    func cellClass() -> UICollectionViewCell.Type {
        return RSStoryCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: RSGenericBaseModel) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
