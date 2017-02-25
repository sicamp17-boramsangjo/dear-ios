//
//  User.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 15..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import Foundation
import RealmSwift

class Receiver: Object {
    dynamic var receiverID = ""
    dynamic var name = ""
    dynamic var phoneNumber = ""

    override class func primaryKey() -> String? {
        return "receiverID"
    }
}

class User: Object {
    dynamic var userName: String = ""
    dynamic var password: String = ""
    dynamic var phoneNumber: String = ""
    dynamic var birthDay: Double = 0
    dynamic var deviceToken: String = ""
    dynamic var profileImageUrl: String = ""
    dynamic var pushDuration: Double = 60*60*24
    dynamic var lastLoginAlarmDuration: Double = 60*60*24*365
    dynamic var isDead: Bool = false
    dynamic var readOnlyToken: String = ""
    let receivers = List<Receiver>()

    override class func primaryKey() -> String? {
        return "phoneNumber"
    }
}

class Answer: Object {
    dynamic var answerID: String = ""
    dynamic var answerText: String?
    dynamic var answerPhoto: String?
    dynamic var answerVideo: String?
    dynamic var mediaWidth: Int = 0
    dynamic var mediaHeight: Int = 0
    dynamic var modifiedAt: Double = 0
    dynamic var createdAt: Double = 0

    let willItem = LinkingObjects(fromType: WillItem.self, property: "answers")

    let receiverObjects = List<Receiver>()
    var receivers: [String] {
        get {
            return []
        }
        set {
            for receiverID in newValue {
                if let receiver = DataSource.instance.fetchReceiver(receiverID: receiverID) {
                    self.receiverObjects.append(receiver)
                }
            }
        }
    }

    func mediaSize() -> CGSize {
        return CGSize(width: self.mediaWidth, height: self.mediaHeight)
    }

    override static func ignoredProperties() -> [String] {
        return ["receivers"]
    }

    override class func primaryKey() -> String? {
        return "answerID"
    }
}

class WillItem: Object {
    dynamic var willitemID: String = ""
    dynamic var questionID: String = ""
    dynamic var text: String = ""
    dynamic var modifiedAt: Double = 0
    dynamic var createdAt: Double = 0

    let answers = List<Answer>()

    override class func primaryKey() -> String? {
        return "willitemID"
    }
}