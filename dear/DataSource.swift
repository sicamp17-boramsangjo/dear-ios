//
//  DataSource.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 15..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import Foundation
import RealmSwift

class DataSource {

    static let modelRevision = 2

    var realm = try! Realm()

    static let instance = DataSource()
    private init() {

        print("Realm home: \(Realm.Configuration.defaultConfiguration.fileURL)")

        let currentModelRevision = ConfigManager.instance.dataModelRevision
        if currentModelRevision != DataSource.modelRevision {
            self.cleanAllDB()
            ConfigManager.instance.dataModelRevision = DataSource.modelRevision
        }
    }

    func cleanAllDB() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [realmURL]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                print(error)
            }
        }

        self.realm = try! Realm()

        print("New Realm home: \(Realm.Configuration.defaultConfiguration.fileURL)")
    }

    func storeLoginUser(loginUserValue: [String: Any]) {
        let loginUser = User(value: loginUserValue)

        try! self.realm.write {
            self.realm.add(loginUser, update: true)
        }
    }

    func storeReceiver(receiverValue: [String: Any]) {
        let receiver = Receiver(value: receiverValue)

        try! self.realm.write {
            self.realm.add(receiver, update: true)
        }
    }

    func storeWIllItem(willItemRawInfo:[String:Any]) {
        let willItem = WillItem(value: willItemRawInfo)

        if let answerRawList = willItemRawInfo["answers"] as? Array<Dictionary<String, Any>> {
            for (index, item) in answerRawList.enumerated() {

                if let answerRaw = item as? Dictionary<String, Any> {
                    willItem.answers[index].receivers = answerRaw["receivers"] as! Array<String>
                }
            }
        }

        try! self.realm.write {
            self.realm.add(willItem, update: true)
        }
    }

    func storeWillItemList(willItemRawList: [Any]) {
        try! self.realm.write() {
            for item in willItemRawList {

                if let willItemRaw = item as? Dictionary<String, Any> {
                    let willItem = WillItem(value: willItemRaw)
                    self.realm.add(willItem, update: true)
                }

            }
        }
    }

    func deleteWillItem(willItemID: String) -> Bool {
        guard let willItem = self.fetchWillItem(willItemId: willItemID) else {
            return false
        }

        self.realm.delete(willItem)
        return true
    }

    func deleteAnswer(answerID: String) -> Bool {
        guard let answer = self.fetchAnswer(answerID: answerID) else {
            return false
        }

        self.realm.delete(answer)
        return true
    }

    func removeReceiver(receiverID: String) -> Bool {
        guard let receiver = self.fetchReceiver(receiverID: receiverID) else {
            return false
        }

        self.realm.delete(receiver)
        return true
    }

    func hasUserInfo() -> Bool {
        return self.fetchLoginUser() != nil
    }

    func fetchLoginUser() -> User? {
        return self.realm.objects(User.self).first
    }

    func fetchAllWillItemList() -> [WillItem] {
        return self.realm.objects(WillItem.self).toArray(WillItem)
    }

    func fetchWillItem(willItemId: String) -> WillItem? {
        return self.realm.objects(WillItem.self).filter("willItemID = '\(willItemId)'").first
    }

    func fetchAnswer(answerID: String) -> Answer? {
        return self.realm.objects(Answer.self).filter("answerID = '\(answerID)'").first
    }

    func fetchAllAnswers() -> [Answer] {
        return self.realm.objects(Answer.self).toArray(Answer)
    }


    func fetchAllReceivers() -> [Receiver] {
        return self.realm.objects(Receiver.self).toArray(Receiver)
    }

    func fetchReceiver(receiverID: String) -> Receiver? {
        return self.realm.objects(Receiver.self).filter("receiverID = '\(receiverID)'").first
    }

    func searchReceiver(receiverID: String) -> [Receiver] {
        return self.realm.objects(Receiver.self).filter("receiverID = '\(receiverID)'").toArray(Receiver)
    }

    func searchWIllItem(includeReceiverID:String) -> [WillItem] {

        let answerList = self.realm.objects(Answer.self)

        var result:[WillItem] = []
        for answer in answerList {
            var isFind = false
            for receiver in answer.receiverObjects {
                if receiver.receiverID == includeReceiverID {
                    isFind = true
                }
            }

            if isFind {
                guard let willItem = answer.willItem.first else {
                    continue
                }
                if result.contains(willItem) == false {
                    result.append(willItem)
                }

            }
        }

        return result
    }
}
