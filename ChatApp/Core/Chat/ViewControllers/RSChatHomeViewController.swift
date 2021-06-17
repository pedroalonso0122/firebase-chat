//
//  RSChatHomeViewController.swift
//  ChatApp
//
//  Created by Pedro Alonso on 8/21/20.
//

import UIKit

class RSChatHomeViewController: RSGenericCollectionViewController {
  
  init(configuration: RSGenericCollectionViewControllerConfiguration,
       selectionBlock: RSCollectionViewSelectionBlock?,
       viewer: RSUser) {
    
    super.init(configuration: configuration, selectionBlock: selectionBlock)
    
    self.title = "TeamChat"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func homeVC(uiConfig: RSUIGenericConfigurationProtocol,
                     threadsDataSource: RSGenericCollectionViewControllerDataSource,
                     viewer: RSUser) -> RSChatHomeViewController {
    let collectionVCConfiguration = RSGenericCollectionViewControllerConfiguration(
      pullToRefreshEnabled: false,
      pullToRefreshTintColor: .gray,
      collectionViewBackgroundColor: .white,
      collectionViewLayout: RSLiquidCollectionViewLayout(),
      collectionPagingEnabled: false,
      hideScrollIndicators: false,
      hidesNavigationBar: false,
      headerNibName: nil,
      scrollEnabled: true,
      uiConfig: uiConfig
    )
    
    let homeVC = RSChatHomeViewController(configuration: collectionVCConfiguration, selectionBlock: { (navController, object) in
      
    }, viewer: RSChatMockStore.users[0])
    
    
    // Configure Stories carousel
    let storiesVC = self.storiesViewController(uiConfig: uiConfig,
                                               dataSource: RSGenericLocalDataSource<RSUser>(items: RSChatMockStore.users),
                                               viewer: viewer)
    let storiesCarousel = RSCarouselViewModel(title: nil,
                                               viewController: storiesVC,
                                               cellHeight: 105)
    storiesCarousel.parentViewController = homeVC
    
    // Configure list of message threads
    let threadsVC = RSChatThreadsViewController.mockThreadsVC(uiConfig: uiConfig, dataSource: threadsDataSource, viewer: viewer)
    let threadsViewModel = RSViewControllerContainerViewModel(viewController: threadsVC, cellHeight: nil, subcellHeight: 85)
    threadsViewModel.parentViewController = homeVC
    homeVC.use(adapter: RSViewControllerContainerRowAdapter(), for: "RSViewControllerContainerViewModel")
    
    // Finish home VC configuration
    homeVC.genericDataSource = RSGenericLocalHeteroDataSource(items: [storiesCarousel, threadsViewModel])
    return homeVC
  }
  
  
  static func storiesViewController(uiConfig: RSUIGenericConfigurationProtocol,
                                    dataSource: RSGenericCollectionViewControllerDataSource,
                                    viewer: RSUser) -> RSGenericCollectionViewController {
    let layout = RSCollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 10
    layout.minimumLineSpacing = 10
    let configuration = RSGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                        pullToRefreshTintColor: .white,
                                                                        collectionViewBackgroundColor: .white,
                                                                        collectionViewLayout: layout,
                                                                        collectionPagingEnabled: false,
                                                                        hideScrollIndicators: true,
                                                                        hidesNavigationBar: false,
                                                                        headerNibName: nil,
                                                                        scrollEnabled: true,
                                                                        uiConfig: uiConfig)
    let vc = RSGenericCollectionViewController(configuration: configuration, selectionBlock: RSChatHomeViewController.storySelectionBlock(viewer: viewer))
    vc.genericDataSource = dataSource
    vc.use(adapter: RSChatUserStoryAdapter(uiConfig: uiConfig), for: "RSUser")
    return vc
  }
  
  static func storySelectionBlock(viewer: RSUser) -> RSCollectionViewSelectionBlock? {
    return { (navController, object) in
      let uiConfig = RSChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                            secondaryColor: UIColor(hexString: "#f0f0f0"),
                                            inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                            inputTextViewTextColor: .black,
                                            inputPlaceholderTextColor: UIColor(hexString: "#979797"))
      if let user = object as? RSUser {
        let id1 = (user.uid ?? "")
        let id2 = (viewer.uid ?? "")
        let channelId = "\(id1):\(id2)"
        print("loading thread for channelID: \(channelId)")
        let vc = RSChatThreadViewController(user: viewer, channel: RSChatChannel(id: channelId, name: user.fullName()), uiConfig: uiConfig)
        navController?.pushViewController(vc, animated: true)
      }
    }
  }
}
