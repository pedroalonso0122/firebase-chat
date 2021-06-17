//
//  RSGenericLocalDataSource.swift
//  RestaurantApp
//
//  Created by Pedro Alonso on 4/7/20.
//

class RSGenericLocalDataSource<T: RSGenericBaseModel>: RSGenericCollectionViewControllerDataSource {
    weak var delegate: RSGenericCollectionViewControllerDataSourceDelegate?

    var items: [T]

    init(items: [T]) {
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

    func update(items: [T]) {
        self.items = items
        self.delegate?.genericCollectionViewControllerDataSource(self, didLoadFirst: items)
    }
}
