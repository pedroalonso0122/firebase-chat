//
//  RSGenericLocalHeteroDataSource.swift
//  RestaurantApp
//
//  Created by Pedro Alonso on 5/19/20.
//

import UIKit

class RSGenericLocalHeteroDataSource: RSGenericCollectionViewControllerDataSource {
    weak var delegate: RSGenericCollectionViewControllerDataSourceDelegate?

    let items: [RSGenericBaseModel]

    init(items: [RSGenericBaseModel]) {
        self.items = items
    }

    func object(at index: Int) -> RSGenericBaseModel? {
        if index < items.count {
            return items[index]
        }
        return nil
    }

    func numberOfObjects() -> Int {
        return items.count
    }

    func loadFirst() {
        self.delegate?.genericCollectionViewControllerDataSource(self, didLoadFirst: items)
    }

    func loadBottom() {
    }

    func loadTop() {
    }
}
