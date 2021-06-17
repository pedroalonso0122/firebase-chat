//
//  RSCarouselAdapter.swift
//  RestaurantApp
//
//  Created by Pedro Alonso on 4/25/20.
//

import UIKit

class RSCarouselAdapter : RSGenericCollectionRowAdapter {
    let uiConfig: RSUIGenericConfigurationProtocol

    init(uiConfig: RSUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: RSGenericBaseModel) {
        guard let viewModel = object as? RSCarouselViewModel, let cell = cell as? RSCarouselCollectionViewCell else { return }
        cell.configure(viewModel: viewModel, uiConfig: self.uiConfig)
    }

    func cellClass() -> UICollectionViewCell.Type {
        return RSCarouselCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: RSGenericBaseModel) -> CGSize {
        guard let viewModel = object as? RSCarouselViewModel else { return .zero }
        return CGSize(width: containerBounds.width, height: viewModel.cellHeight)
    }
}
