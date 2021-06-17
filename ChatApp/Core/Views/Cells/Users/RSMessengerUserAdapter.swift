//
//  RSMessengerUserAdapter.swift
//  ChatApp
//
//  Created by Richard Stewart on 8/22/20.
//

import UIKit

class RSMessengerUserAdapter: RSGenericCollectionRowAdapter {
    let uiConfig: RSUIGenericConfigurationProtocol

    init(uiConfig: RSUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: RSGenericBaseModel) {
        if let user = object as? RSUser, let cell = cell as? RSMessengerUserCollectionViewCell {
            if let url = user.profilePictureURL {
                cell.avatarImageView.kf.setImage(with: URL(string: url))
            } else {
                // placeholder
            }
            cell.avatarImageView.contentMode = .scaleAspectFill
            cell.avatarImageView.clipsToBounds = true
            cell.avatarImageView.layer.cornerRadius = 40.0/2.0

            cell.nameLabel.text = (user.firstName ?? "") + " " +  (user.lastName ?? "")
            cell.nameLabel.font = uiConfig.mediumBoldFont
            cell.nameLabel.textColor = uiConfig.mainTextColor

            cell.borderView.backgroundColor = UIColor(hexString: "#e6e6e6")
            cell.setNeedsLayout()
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return RSMessengerUserCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: RSGenericBaseModel) -> CGSize {
        guard let viewModel = object as? RSUser else { return .zero }
        return CGSize(width: containerBounds.width, height: 80)
    }
}
