//
//  RSChatMockStore.swift
//  ChatApp
//
//  Created by Pedro Alonso on 8/20/20.
//

import MessageKit
import UIKit

class RSChatMockStore {
    static let users = [
        RSUser(uid: "dan", firstName: "Dan", lastName: "Burkhardt", avatarURL: "https://cdn0.iconfinder.com/data/icons/avatar-2/500/man-2-512.png", email: "test@gigabitelabs.com", isOnline: false),
        RSUser(uid: "simulator", firstName: "iPhone", lastName: "Simulator", avatarURL: "https://cdn-images-1.medium.com/max/1000/1*QUmlH0_tRyjlbxVkSKtk3A.png", email: "testcristina@gmail.com", isOnline: true),
        RSUser(uid: "sandra", firstName: "Sandra", lastName: "O'Connor", avatarURL: "https://cdn0.iconfinder.com/data/icons/people-avatar-flat/64/girl_ginger_curly_people_woman_teenager_avatar-512.png", email: "testcristina@gmail.com", isOnline: true),
        RSUser(uid: "sam", firstName: "Sam", lastName: "Smith", avatarURL: "https://cdn1.iconfinder.com/data/icons/avatar-2-2/512/Programmer-512.png", email: "testcristina@gmail.com", isOnline: false),
        RSUser(uid: "tom", firstName: "Tom", lastName: "Bradley", avatarURL: "https://cdn3.iconfinder.com/data/icons/business-avatar-1/512/4_avatar-512.png", email: "testcristina@gmail.com", isOnline: true),
        ]
 
    // HEY AGAIN: set the users for stcSender and atcRecipient on one of these so that one is the user
    // for your simulator, the other one is your device
    static let threads = [
        RSChatMessage(messageId: "1", messageKind: MessageKind.text("TestThread"), createdAt: Date().yesterday, atcSender: users[2], recipient: users[0], seenByRecipient: false),// <- try this one
        RSChatMessage(messageId: "2", messageKind: MessageKind.text("\u{1F631} Wow, it's real time"), createdAt: Date().yesterday, atcSender: users[1], recipient: users[0], seenByRecipient: true)
    ]
}
