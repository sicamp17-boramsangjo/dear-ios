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
}

class User: Object {
    dynamic var name: String = ""
    dynamic var profileImage: String = ""
    dynamic var phoneNumber: String = ""
    dynamic var deviceToken: String = ""
    dynamic var birthDay: Double = 0
    dynamic var gender: String = "unknown"
    dynamic var isDead: Bool = false
    dynamic var pushDuration: Double = 60*60*24
    dynamic var lastLoginAlarmDuration: Double = 60*60*24*365
    dynamic var readKey: String = ""
    dynamic var receiver: Receiver?
}

class Answer: Object {
    var textContent: String?
    var imageContent: String?
    var videoContent: String?
    var lastUpdate: Double = 0
}

class WillItem: Object {
    dynamic var question: String = ""
    dynamic var lastUpdate: Double = 0
    let answers = List<Answer>()
}

extension Receiver {
    static func fixture() -> [String:Any] {
        return [
                "name": "Hannah",
                "phoneNumber": "010-1234-1234"
        ]
    }
}

extension User {
    static func fixture() -> [String:Any] {
        return [
                "name": "Kyungtaek",
                "profileImage": "https://avatars3.githubusercontent.com/u/1677561?v=3&s=460",
                "birthDay":366508800,
                "phoneNumber": "821098769876",
                "gender": "male",
                "receiver": Receiver.fixture()
        ]
    }
}

extension Answer {
    static func fixture() -> [String:Any] {
        return [
            "textContent": "싸움이 급하니 내 죽음을 ㅇ라리지 말라",
                "imageContent":"http://cfile10.uf.tistory.com/image/247ECD4E5577CE25211A10",
                "videoContent":"http://techslides.com/demos/sample-videos/small.mp4",
                "lastUpdate":1487439527
        ]
    }
}

extension WillItem {
    static func fixture() -> [String:Any] {
        return [
                "question":"당신의 유언은?",
                "answers":[
                    Answer.fixture(),
                    Answer.fixture()
                ],
                "lastUpdate":1487439527
        ]
    }
}
