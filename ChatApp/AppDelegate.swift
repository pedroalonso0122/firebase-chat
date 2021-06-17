//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Pedro Alonso on 8/20/20.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Configure the UI
        let config = ChatUIConfiguration()
        config.configureUI()

        FirebaseApp.configure()

        let threadsDataSource = RSGenericLocalHeteroDataSource(items: RSChatMockStore.threads)
        
        // HEY THERE, user. read the next few lines below
        // Helper file to access remote data for a user
        let remoteData = RSRemoteData()
        // Checks if user's firestore actually has channels setup
        remoteData.getChannels()
        
        // For testing, set this to a usr from 0-4 and run it to your simulator
        // Then, set it to any other user and run it to your phone. THEN-> see my comment in RSChatMockStore.swift
        let user = 2
        // If both devices have a different user active, AND the chat thread is available, you can msg live
        
        
        // Window setup
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ChatHostViewController(uiConfig: config,
                                                            threadsDataSource: threadsDataSource,
                                                            viewer: RSChatMockStore.users[user])
        
        print("currentUser: \(RSChatMockStore.users[user].debugDescription)")
        window?.makeKeyAndVisible()

        return true
    }
}
