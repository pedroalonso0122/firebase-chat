//
//  RSNavigationController.swift
//  AppTemplatesFoundation
//
//  Created by Pedro Alonso on 2/11/17.

//

import UIKit

public protocol RSNavigationControllerDelegate: class {
    func navigationControllerDidTapMenuButton(_ navigationController: RSNavigationController)
}

public class RSNavigationController: UINavigationController, UINavigationControllerDelegate {
    fileprivate var menuButton: UIBarButtonItem?
    fileprivate var topNavigationRightView: UIView?
    fileprivate var topNavigationLeftView: UIView?
    fileprivate var topNavigationLeftImage: UIImage?
    weak var drawerDelegate: RSNavigationControllerDelegate?

    public init(rootViewController: UIViewController,
                topNavigationLeftView: UIView? = nil,
                topNavigationRightView: UIView?,
                topNavigationLeftImage: UIImage?,
                topNavigationTintColor: UIColor? = .white) {
        super.init(rootViewController: rootViewController)
        self.topNavigationLeftView = topNavigationLeftView
        self.topNavigationRightView = topNavigationRightView
        self.topNavigationLeftImage = topNavigationLeftImage
        if let topNavigationLeftImage = topNavigationLeftImage {
            let imageButton = UIButton()
            imageButton.setImage(topNavigationLeftImage, for: .normal)
            if let topNavigationTintColor = topNavigationTintColor {
                imageButton.tintColor = topNavigationTintColor
            }
            imageButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
            menuButton = UIBarButtonItem(customView: imageButton)
            imageButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(25)
                maker.height.equalTo(25)
            })
        }
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = .white
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        prepareNavigationBar()
    }
}

extension RSNavigationController {
    fileprivate func prepareNavigationBar() {
        topViewController?.navigationItem.title = topViewController?.title
        if self.viewControllers.count <= 1 {
            if let topNavigationRightView = topNavigationRightView {
                topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: topNavigationRightView)
            }
            if let topNavigationLeftView = topNavigationLeftView {
                topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: topNavigationLeftView)
            } else {
                if let menuButton = menuButton {
                    topViewController?.navigationItem.leftBarButtonItem = menuButton
                }
            }
        }
    }
}

extension RSNavigationController {
    @objc
    fileprivate func handleMenuButton() {
        drawerDelegate?.navigationControllerDidTapMenuButton(self)
    }
}
