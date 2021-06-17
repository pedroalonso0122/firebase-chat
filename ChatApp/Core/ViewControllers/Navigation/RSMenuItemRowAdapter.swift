//
//  RSMenuItemRowAdapter.swift
//  ShoppingApp
//
//  Created by Pedro Alonso on 3/19/20.
//

import UIKit

class RSMenuItemRowAdapter: RSGenericCollectionRowAdapter {

    let cellClassType: UICollectionViewCell.Type
    let uiConfig: RSMenuUIConfiguration

    init(cellClassType: UICollectionViewCell.Type, uiConfig: RSMenuUIConfiguration) {
        self.cellClassType = cellClassType
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: RSGenericBaseModel) {
        guard let item = object as? RSNavigationItem, let cell = cell as? RSMenuItemCollectionViewCellProtocol else {
            fatalError()
        }
        cell.configure(item: item)
        cell.menuLabel.font = uiConfig.itemFont
        cell.menuLabel.textColor = uiConfig.tintColor
        cell.menuImageView.tintColor = uiConfig.tintColor
    }

    func cellClass() -> UICollectionViewCell.Type {
        return cellClassType
    }

    func size(containerBounds: CGRect, object: RSGenericBaseModel) -> CGSize {
        return CGSize(width: containerBounds.width, height: uiConfig.itemHeight)
    }
}
