//
//  RSGenericCollectionViewController.swift
//  ShoppingApp
//
//  Created by Pedro Alonso on 10/15/17.

//

import UIKit

protocol RSGenericFirebaseParsable {
    init(key: String, jsonDict: [String: Any])
}

protocol RSGenericJSONParsable {
    init(jsonDict: [String: Any])
}

protocol RSGenericBaseModel: RSGenericJSONParsable, CustomStringConvertible {
}

protocol RSGenericCollectionViewControllerDataSourceDelegate: class {
    func genericCollectionViewControllerDataSource(_ dataSource: RSGenericCollectionViewControllerDataSource, didLoadFirst objects: [RSGenericBaseModel])
    func genericCollectionViewControllerDataSource(_ dataSource: RSGenericCollectionViewControllerDataSource, didLoadBottom objects: [RSGenericBaseModel])
    func genericCollectionViewControllerDataSource(_ dataSource: RSGenericCollectionViewControllerDataSource, didLoadTop objects: [RSGenericBaseModel])
}

protocol RSGenericCollectionViewScrollDelegate: class {
    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int)
}

protocol RSGenericCollectionViewControllerDataSource: class {
    var delegate: RSGenericCollectionViewControllerDataSourceDelegate? {get set}

    func object(at index: Int) -> RSGenericBaseModel?
    func numberOfObjects() -> Int

    func loadFirst()
    func loadBottom()
    func loadTop()
}

protocol RSGenericCollectionRowAdapter: class {
    func configure(cell: UICollectionViewCell, with object: RSGenericBaseModel)
    func cellClass() -> UICollectionViewCell.Type
    func size(containerBounds: CGRect, object: RSGenericBaseModel) -> CGSize
}

class RSAdapterStore {
    fileprivate var store = [String: RSGenericCollectionRowAdapter]()

    func add(adapter: RSGenericCollectionRowAdapter, for classString: String) {
        store[classString] = adapter
    }

    func adapter(for classString: String) -> RSGenericCollectionRowAdapter? {
        return store[classString]
    }
}

struct RSGenericCollectionViewControllerConfiguration {
    let pullToRefreshEnabled: Bool
    let pullToRefreshTintColor: UIColor
    let collectionViewBackgroundColor: UIColor
    let collectionViewLayout: RSCollectionViewFlowLayout
    let collectionPagingEnabled: Bool
    let hideScrollIndicators: Bool
    let hidesNavigationBar: Bool
    let headerNibName: String?
    let scrollEnabled: Bool
    let uiConfig: RSUIGenericConfigurationProtocol
}

typealias RSCollectionViewSelectionBlock = (UINavigationController?, RSGenericBaseModel) -> Void

/* A generic view controller, that encapsulates:
 * - fetching data from a data store (over the network, firebase, local cache, etc)
 * - adapting a model type to a cell type
 * - persisiting data on disk
 * - manages pagination
 */
class RSGenericCollectionViewController: UICollectionViewController {
    var genericDataSource: RSGenericCollectionViewControllerDataSource? {
        didSet {
            genericDataSource?.delegate = self
        }
    }

    weak var scrollDelegate: RSGenericCollectionViewScrollDelegate?

    fileprivate var adapterStore = RSAdapterStore()
    let configuration: RSGenericCollectionViewControllerConfiguration

    fileprivate lazy var refreshControl = UIRefreshControl()
    fileprivate lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    var selectionBlock: RSCollectionViewSelectionBlock?

    init(configuration: RSGenericCollectionViewControllerConfiguration, selectionBlock: RSCollectionViewSelectionBlock? = nil) {
        self.configuration = configuration
        self.selectionBlock = selectionBlock
        let layout = configuration.collectionViewLayout
        super.init(collectionViewLayout: layout)
        layout.delegate = self
        self.use(adapter: RSCarouselAdapter(uiConfig: configuration.uiConfig), for: "RSCarouselViewModel")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        print("home view controller did load")
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            fatalError()
        }

        collectionView.backgroundColor = configuration.collectionViewBackgroundColor
        collectionView.isPagingEnabled = configuration.collectionPagingEnabled
        collectionView.isScrollEnabled = configuration.scrollEnabled
        registerReuseIdentifiers()
        if configuration.pullToRefreshEnabled {
            collectionView.addSubview(refreshControl)
            refreshControl.tintColor = configuration.pullToRefreshTintColor
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        }
        if configuration.hideScrollIndicators {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
        activityIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.minY + 50)
        collectionView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        genericDataSource?.loadFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (configuration.hidesNavigationBar) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (configuration.hidesNavigationBar) {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    func use(adapter: RSGenericCollectionRowAdapter, for classString: String) {
        adapterStore.add(adapter: adapter, for: classString)
    }

    // MARK: - Private

    private func registerReuseIdentifiers() {
        adapterStore.store.forEach { (key, adapter) in
            collectionView?.register(UINib(nibName: String(describing: adapter.cellClass()), bundle: nil), forCellWithReuseIdentifier: key)
        }
        if let headerNib = configuration.headerNibName {
            collectionView?.register(UINib(nibName: headerNib, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNib)
        }
    }

    private func size(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        if let adapter = self.adapter(at: indexPath), let object = genericDataSource?.object(at: indexPath.row) {
            return adapter.size(containerBounds: collectionView.bounds, object: object)
        }
        return .zero
    }

    private func adapter(at indexPath: IndexPath) -> RSGenericCollectionRowAdapter? {
        if let object = genericDataSource?.object(at: indexPath.row) {
            let stringClass = String(describing: type(of: object))
            if let adapter = adapterStore.adapter(for: stringClass) {
                return adapter
            }
        }
        return nil
    }

    @objc func didPullToRefresh() {
        genericDataSource?.loadTop()
    }
}

extension RSGenericCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let object = genericDataSource?.object(at: indexPath.row) {
            let stringClass = String(describing: type(of: object))
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stringClass, for: indexPath)
            if let adapter = adapterStore.adapter(for: stringClass) {
                adapter.configure(cell: cell, with: object)
            }
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectionBlock = selectionBlock,
            let object = genericDataSource?.object(at: indexPath.row) {
            var navController = self.navigationController
            if (navController == nil) {
                navController = self.parent?.navigationController
            }
            if (navController == nil) {
                navController = self.parent?.parent?.navigationController
            }
            selectionBlock(navController, object)
        }
    }

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(genericDataSource != nil)
        return genericDataSource?.numberOfObjects() ?? 0
    }

    override open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 >= (genericDataSource?.numberOfObjects() ?? 0) {
            genericDataSource?.loadBottom()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let id = configuration.headerNibName ?? "header"
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
        } else if (kind == UICollectionView.elementKindSectionFooter) {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        }
        fatalError()
    }
}

extension RSGenericCollectionViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        if w != 0 {
            let page = Int(ceil(x/w))
            scrollDelegate?.genericScrollView(scrollView, didScrollToPage: page)
        }
    }
}

extension RSGenericCollectionViewController: RSLiquidLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: indexPath).height
    }

    func collectionViewCellWidth(collectionView: UICollectionView) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: IndexPath(row: 0, section: 0)).width
    }
}

extension RSGenericCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.size(collectionView: collectionView, indexPath: indexPath)
    }
}

extension RSGenericCollectionViewController: RSGenericCollectionViewControllerDataSourceDelegate {
    func genericCollectionViewControllerDataSource(_ dataSource: RSGenericCollectionViewControllerDataSource, didLoadFirst objects: [RSGenericBaseModel]) {
        activityIndicator.stopAnimating()
        self.reloadCollectionView()
    }

    func genericCollectionViewControllerDataSource(_ dataSource: RSGenericCollectionViewControllerDataSource, didLoadBottom objects: [RSGenericBaseModel]) {
        let offset = dataSource.numberOfObjects() - objects.count
        self.collectionView?.performBatchUpdates({
            let indexPaths = (0 ..< objects.count).map({ IndexPath(row: offset + $0, section: 0)})
            self.collectionView?.insertItems(at: indexPaths)
        }, completion: nil)
    }

    func genericCollectionViewControllerDataSource(_ dataSource: RSGenericCollectionViewControllerDataSource, didLoadTop objects: [RSGenericBaseModel]) {
        if (configuration.pullToRefreshEnabled) {
            refreshControl.endRefreshing()
        }
        self.reloadCollectionView()
    }

    private func reloadCollectionView() {
        assert(Thread.isMainThread)
        self.collectionView?.reloadData()
        self.collectionView?.collectionViewLayout.invalidateLayout()
        if let parent = self.parent as? RSGenericCollectionViewController {
            parent.reloadCollectionView()
        }
    }
}
