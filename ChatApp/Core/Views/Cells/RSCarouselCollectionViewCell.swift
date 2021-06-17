//
//  RSCarouselCollectionViewCell.swift
//  RestaurantApp
//
//  Created by Pedro Alonso on 4/25/20.
//

import UIKit

class RSGridViewModel: RSCarouselViewModel {
    let callToAction: String?
    let callToActionBlock: (() -> Void)?

    init(title: String?,
         viewController: RSGenericCollectionViewController,
         cellHeight: CGFloat,
         pageControlEnabled: Bool = false,
         callToAction: String? = nil,
         callToActionBlock: (() -> Void)? = nil) {
        self.callToAction = callToAction
        self.callToActionBlock = callToActionBlock
        super.init(title: title, viewController: viewController, cellHeight: cellHeight)
    }

    required init(jsonDict: [String : Any]) {
        fatalError("init(jsonDict:) has not been implemented")
    }
}

class RSCarouselViewModel: RSGenericBaseModel {
    var description: String = "Carousel"

    let cellHeight: CGFloat
    let title: String?
    let pageControlEnabled: Bool
    var viewController: RSGenericCollectionViewController
    weak var parentViewController: UIViewController?

    init(title: String?, viewController: RSGenericCollectionViewController, cellHeight: CGFloat, pageControlEnabled: Bool = false) {
        self.title = title
        self.cellHeight = cellHeight
        self.viewController = viewController
        self.pageControlEnabled = pageControlEnabled
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}

class RSCarouselCollectionViewCell: UICollectionViewCell, RSGenericCollectionViewScrollDelegate {
    @IBOutlet var carouselTitleLabel: UILabel!
    @IBOutlet var carouselContainerView: UIView!
    @IBOutlet var pageControl: UIPageControl!

    func configure(viewModel: RSCarouselViewModel, uiConfig: RSUIGenericConfigurationProtocol) {
        if (viewModel.title == nil) {
            carouselTitleLabel.removeFromSuperview()
        } else {
            if (nil == carouselTitleLabel.superview) {
                self.addSubview(carouselTitleLabel)
            }
        }
        carouselTitleLabel.text = viewModel.title
        carouselTitleLabel.font = uiConfig.boldLargeFont
        carouselTitleLabel.textColor = uiConfig.mainTextColor

        carouselContainerView.setNeedsLayout()
        carouselContainerView.layoutIfNeeded()

        let viewController = viewModel.viewController

        pageControl.isHidden = !viewModel.pageControlEnabled
        if let dS = viewController.genericDataSource {
            pageControl.numberOfPages = dS.numberOfObjects()
        }
        viewController.scrollDelegate = self

        viewController.view.frame = carouselContainerView.bounds
        carouselContainerView.addSubview(viewController.view)
        self.setNeedsLayout()
        viewModel.parentViewController?.addChild(viewModel.viewController)
    }

    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int) {
        pageControl.currentPage = page
    }
}
