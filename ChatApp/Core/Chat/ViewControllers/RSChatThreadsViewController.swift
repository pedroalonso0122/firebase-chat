//
//  RSChatThreadsViewController.swift
//  ChatApp
//
//  Created by Pedro Alonso on 8/20/20.
//

import UIKit

class RSChatThreadsViewController: RSGenericCollectionViewController {
  
  init(configuration: RSGenericCollectionViewControllerConfiguration,
       selectionBlock: RSCollectionViewSelectionBlock?,
       viewer: RSUser) {
    super.init(configuration: configuration, selectionBlock: selectionBlock)
    self.use(adapter: RSChatThreadAdapter(uiConfig: configuration.uiConfig, viewer: viewer), for: "RSChatMessage")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func mockThreadsVC(uiConfig: RSUIGenericConfigurationProtocol,
                            dataSource: RSGenericCollectionViewControllerDataSource,
                            viewer: RSUser) -> RSChatThreadsViewController {
    let collectionVCConfiguration = RSGenericCollectionViewControllerConfiguration(
      pullToRefreshEnabled: false,
      pullToRefreshTintColor: .white,
      collectionViewBackgroundColor: .white,
      collectionViewLayout: RSLiquidCollectionViewLayout(),
      collectionPagingEnabled: false,
      hideScrollIndicators: false,
      hidesNavigationBar: false,
      headerNibName: nil,
      scrollEnabled: false,
      uiConfig: uiConfig
    )
    
    let vc = RSChatThreadsViewController(configuration: collectionVCConfiguration, selectionBlock: RSChatThreadsViewController.selectionBlock(viewer: viewer), viewer: RSChatMockStore.users[0])
    vc.genericDataSource = dataSource
    return vc
  }
  
  static func selectionBlock(viewer: RSUser) -> RSCollectionViewSelectionBlock? {
    return { (navController, object) in
      let uiConfig = RSChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                            secondaryColor: UIColor(hexString: "#f0f0f0"),
                                            inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                            inputTextViewTextColor: .black,
                                            inputPlaceholderTextColor: UIColor(hexString: "#979797"))
      if let lastMessage = object as? RSChatMessage {
        let otherUser = viewer.uid == lastMessage.atcSender.uid ? lastMessage.recipient : lastMessage.atcSender
        let vc = RSChatThreadViewController(user: viewer, channel: RSChatChannel(id: lastMessage.channelId, name: otherUser.fullName()), uiConfig: uiConfig)
        navController?.pushViewController(vc, animated: true)
      }
    }
  }
}
