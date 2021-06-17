//
//  RSChatThreadAdapter.swift
//  ChatApp
//
//  Created by Pedro Alonso on 8/20/20.
//

import Kingfisher
import UIKit

class RSChatThreadAdapter: RSGenericCollectionRowAdapter {
    let uiConfig: RSUIGenericConfigurationProtocol
    let viewer: RSUser

    init(uiConfig: RSUIGenericConfigurationProtocol, viewer: RSUser) {
        self.uiConfig = uiConfig
        self.viewer = viewer
    }

    func configure(cell: UICollectionViewCell, with object: RSGenericBaseModel) {
        guard let viewModel = object as? RSChatMessage, let cell = cell as? RSThreadCollectionViewCell else { return }
        let theOtherUser = (viewer.email == viewModel.atcSender.email) ? viewModel.recipient : viewModel.atcSender
        if let url = theOtherUser.profilePictureURL {
            cell.singleImageView.kf.setImage(with: URL(string: url))
        } else {
            // placeholder
        }
        cell.singleImageView.contentMode = .scaleAspectFill
        cell.singleImageView.clipsToBounds = true
        cell.singleImageView.layer.cornerRadius = 60.0/2.0

        let unseenByMe = (!viewModel.seenByRecipient && viewer.email == viewModel.recipient.email)
        cell.titleLabel.text = (theOtherUser.firstName ?? "") + " " +  (theOtherUser.lastName ?? "")
        cell.titleLabel.font = unseenByMe ? uiConfig.mediumBoldFont : uiConfig.regularMediumFont
        cell.titleLabel.textColor = uiConfig.mainTextColor

        var subtitle = (viewer.email == viewModel.atcSender.email) ? "You: " : ""
        subtitle += viewModel.messageText + " \u{00B7} " + TimeFormatHelper.chatString(for: viewModel.sentDate)
        cell.subtitleLabel.text = subtitle
        cell.subtitleLabel.font = uiConfig.regularSmallFont
        cell.subtitleLabel.textColor = uiConfig.mainSubtextColor

        cell.onlineStatusView.isHidden = !theOtherUser.isOnline
        cell.onlineStatusView.layer.cornerRadius = 15.0/2.0
        cell.onlineStatusView.layer.borderColor = UIColor.white.cgColor
        cell.onlineStatusView.layer.borderWidth = 3
        cell.onlineStatusView.backgroundColor = UIColor(hexString: "#4acd1d")

        cell.setNeedsLayout()
    }

    func cellClass() -> UICollectionViewCell.Type {
        return RSThreadCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: RSGenericBaseModel) -> CGSize {
        guard let viewModel = object as? RSChatMessage else { return .zero }
        return CGSize(width: containerBounds.width, height: 85)
    }
}
