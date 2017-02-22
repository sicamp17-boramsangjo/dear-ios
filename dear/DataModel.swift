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
    dynamic var readKey: String = ""
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
    dynamic var lastUpdate: Double = 0

    let receivers = List<Receiver>()

    override class func primaryKey() -> String? {
        return "answerID"
    }
}

class WillItem: Object {
    dynamic var willItemID: String = ""
    dynamic var questionID: String = ""
    dynamic var question: String = ""
    dynamic var lastUpdate: Double = 0

    let answers = List<Answer>()

    override class func primaryKey() -> String? {
        return "willItemID"
    }
}

extension Receiver {
    static func fixture() -> [String:Any] {
        return [
                "receiverID":"\(UUID().uuidString)",
                "name": "Hannah",
                "phoneNumber": "010-1234-1234"
        ]
    }
}

extension User {
    static func fixture() -> [String:Any] {
        return [
                "userName": "Kyungtaek",
                "password": "password",
                "phoneNumber": "821098769876",
                "birthDay":366508800,
                "deviceToken":"deviceToken",
                "profileImageUrl": "https://avatars3.githubusercontent.com/u/1677561?v=3&s=460",
                "pushDuration":60*60*24,
                "lastLoginAlarmDuration":60*60*24*365,
                "readKey":"readKeyRandom",
                "isDead":false,
                "receivers":[Receiver.fixture()]
        ]
    }
}

extension Answer {
    static func fixture() -> [String:Any] {
        return [
                "answerID":"\(UUID().uuidString)",
                "answerText": "싸움이 급하니 내 죽음을 알리지 말라",
                "answerPhoto":"http://cfile10.uf.tistory.com/image/247ECD4E5577CE25211A10",
                "answerVideo":"http://techslides.com/demos/sample-videos/small.mp4",
                "receivers":[Receiver.fixture()],
                "lastUpdate":1487439527
        ]
    }
}

extension WillItem {
    static func fixture() -> [String:Any] {
        return [
                "willItemID":"\(UUID().uuidString)",
                "questionID":"questionID",
                "question":"당신의 유언은?",
                "answers":[
                        Answer.fixture(),
                        Answer.fixture()
                ],
                "lastUpdate":1487439527
        ]
    }

    static func fixtureList() -> [String:Any] {
        return ["results":[
                WillItem.fixture(),
                WillItem.fixture(),
                WillItem.fixture(),
                WillItem.fixture(),
                WillItem.fixture(),
                WillItem.fixture()
        ]]
    }
}
