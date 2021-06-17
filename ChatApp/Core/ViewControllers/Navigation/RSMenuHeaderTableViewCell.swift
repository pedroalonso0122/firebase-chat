//
//  RSMenuHeaderTableViewCell.swift
//  AppTemplatesFoundation
//
//  Created by Pedro Alonso on 2/11/17.

//

import Kingfisher
import UIKit

open class RSMenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    open func configureCell(user: RSUser?) {
        if let urlString = user?.profilePictureURL {
            let imageURL = URL(string: urlString)
            avatarView.kf.setImage(with: imageURL)
        }
        avatarView.layer.cornerRadius = 35
        avatarView.clipsToBounds = true

        nameLabel.text = user?.fullName()
    }
}
