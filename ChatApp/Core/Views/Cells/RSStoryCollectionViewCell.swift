//
//  RSStoryCollectionViewCell.swift
//  RestaurantApp
//
//  Created by Pedro Alonso on 5/15/20.
//

import UIKit

class RSStoryViewModel: NSObject, RSGenericBaseModel {
    var imageURLString: String
    var title: String
    var atcDescription: String

    init(imageURLString: String, title: String, description: String) {
        self.imageURLString = imageURLString
        self.title = title
        self.atcDescription = description
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}

class RSStoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var storyImageView: UIImageView!
    @IBOutlet var storyLabel: UILabel!

    func configure(viewModel: RSStoryViewModel, uiConfig: RSUIGenericConfigurationProtocol) {
        storyImageView.contentMode = .scaleAspectFill
        storyImageView.layer.masksToBounds = true
        storyImageView.clipsToBounds = true
        storyImageView.layer.cornerRadius = 35
        storyLabel.font = uiConfig.regularSmallFont

        storyImageView.kf.setImage(with: URL(string: viewModel.imageURLString))
        storyLabel.text = viewModel.title
    }
}
