//
//  RSCircledIconMenuCollectionViewCell.swift
//  DashboardApp
//
//  Created by Pedro Alonso on 8/4/20.
//

import UIKit

class RSCircledIconMenuCollectionViewCell: UICollectionViewCell, RSMenuItemCollectionViewCellProtocol {
    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var imageContainerView: UIView!
    
    func configure(item: RSNavigationItem) {
        menuImageView.image = item.image
        menuLabel.text = item.title

        imageContainerView.layer.cornerRadius = 30 / 2
        imageContainerView.layer.borderColor = UIColor.gray.cgColor
        imageContainerView.layer.borderWidth = 1.0
    }
}
