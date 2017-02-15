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
    dynamic var name = ""
    dynamic var phoneNumber = ""
}

class User: Object {
    dynamic var name: String = ""
    dynamic var profileImage: String = ""
    //dynamic var password = ""
    dynamic var phoneNumber: String = ""
    dynamic var deviceToken: String = ""
    dynamic var birthDay = Date()
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
    var lastUpdate: Double = Date.timeIntervalBetween1970AndReferenceDate
}

class WillItem: Object {
    dynamic var question: String = ""
    dynamic var lastUpdate: Double = Date.timeIntervalBetween1970AndReferenceDate
    let anwsers = List<Answer>()
}

extension Answer {

}
