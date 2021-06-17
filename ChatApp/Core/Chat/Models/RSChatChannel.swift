//
//  RSChatChannel.swift
//  ChatApp
//
//  Created by Pedro Alonso on 8/26/20.
//

import FirebaseFirestore

struct RSChatChannel {

    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard let name = data["name"] as? String else {
            return nil
        }

        id = document.documentID
        self.name = name
    }
}

extension RSChatChannel: DatabaseRepresentation {

    var representation: [String : Any] {
        var rep = ["name": name]
        rep["id"] = id
        return rep
    }

}

extension RSChatChannel: Comparable {

    static func == (lhs: RSChatChannel, rhs: RSChatChannel) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: RSChatChannel, rhs: RSChatChannel) -> Bool {
        return lhs.name < rhs.name
    }

}
