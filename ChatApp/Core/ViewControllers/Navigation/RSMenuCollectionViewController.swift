//
//  RSMenuCollectionViewController.swift
//  ShoppingApp
//
//  Created by Pedro Alonso on 3/19/20.
//

import UIKit

protocol RSMenuCollectionViewCellConfigurable {
    func configure(item: RSNavigationItem);
}

public struct RSMenuUIConfiguration {
    var itemFont: UIFont = UIFont(name: "FallingSkyCond", size: 16)!
    var tintColor: UIColor = UIColor(hexString: "#555555")
    var itemHeight: CGFloat = 45.0
    var backgroundColor: UIColor = .white
}

public struct RSMenuConfiguration {
    let user: RSUser?
    let cellClass: UICollectionViewCell.Type?
    let headerHeight: CGFloat
    let items: [RSNavigationItem]
    let uiConfig: RSMenuUIConfiguration
}

class RSMenuCollectionViewController: RSGenericCollectionViewController {

    fileprivate var lastSelectedIndexPath: IndexPath?

    var user: RSUser?

    let cellClass: UICollectionViewCell.Type?
    let headerHeight: CGFloat
    let menuConfiguration: RSMenuConfiguration

    init(menuConfiguration: RSMenuConfiguration, collectionVCConfiguration: RSGenericCollectionViewControllerConfiguration) {
        self.user = menuConfiguration.user
        self.cellClass = menuConfiguration.cellClass
        self.headerHeight = menuConfiguration.headerHeight
        self.menuConfiguration = menuConfiguration

        super.init(configuration: collectionVCConfiguration)
        if let cellClass = cellClass {
            self.use(adapter: RSMenuItemRowAdapter(cellClassType: cellClass, uiConfig: menuConfiguration.uiConfig), for: "RSNavigationItem")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = menuConfiguration.uiConfig.backgroundColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let collectionView = collectionView {
            collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 3.0, 0)
        }
    }
}

extension RSMenuCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = self.genericDataSource?.object(at: indexPath.row) as? RSNavigationItem else {
            return
        }
        let vc = menuItem.viewController
        self.drawerController()?.navigateTo(viewController: vc)
    }
}

extension RSMenuCollectionViewController {
    fileprivate func drawerController() -> RSDrawerController? {
        return (self.parent as? RSDrawerController)
    }
}
