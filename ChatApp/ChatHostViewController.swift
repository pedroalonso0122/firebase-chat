//
//  ChatHostViewController.swift
//  ChatApp
//
//  Created by Pedro Alonso on 8/20/20.
//

import UIKit

class ChatHostViewController: UIViewController, UITabBarControllerDelegate {

    let homeVC: UIViewController
    let uiConfig: RSUIGenericConfigurationProtocol

    init(uiConfig: RSUIGenericConfigurationProtocol,
         threadsDataSource: RSGenericCollectionViewControllerDataSource,
         viewer: RSUser) {
        self.uiConfig = uiConfig
        self.homeVC = RSChatHomeViewController.homeVC(uiConfig: uiConfig, threadsDataSource: threadsDataSource, viewer: viewer)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var hostController: RSHostViewController = { [unowned self] in
        let menuItems: [RSNavigationItem] = [
            RSNavigationItem(title: "Home",
                              viewController: homeVC,
                              image: UIImage.localImage("bubbles-icon", template: true),
                              type: .viewController,
                              leftTopView: nil,
                              rightTopView: nil),
        ]
        let menuConfiguration = RSMenuConfiguration(user: nil,
                                                     cellClass: RSCircledIconMenuCollectionViewCell.self,
                                                     headerHeight: 0,
                                                     items: menuItems,
                                                     uiConfig: RSMenuUIConfiguration(itemFont: uiConfig.regularMediumFont,
                                                                                      tintColor: uiConfig.mainTextColor,
                                                                                      itemHeight: 45.0,
                                                                                      backgroundColor: uiConfig.mainThemeBackgroundColor))

        let config = RSHostConfiguration(menuConfiguration: menuConfiguration,
                                          style: .tabBar,
                                          topNavigationRightView: nil,
                                          topNavigationLeftImage: UIImage.localImage("three-equal-lines-icon", template: true),
                                          topNavigationTintColor: uiConfig.mainThemeForegroundColor,
                                          statusBarStyle: uiConfig.statusBarStyle,
                                          uiConfig: uiConfig)
        return RSHostViewController(configuration: config)
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewControllerWithView(hostController)
        hostController.view.backgroundColor = uiConfig.mainThemeBackgroundColor
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return uiConfig.statusBarStyle
    }
}
