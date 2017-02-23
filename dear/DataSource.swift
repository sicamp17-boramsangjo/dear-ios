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

    static let modelRevision = 8

    var realm = try! Realm()

    static let instance = DataSource()
    private init() {

        print("Realm home: \(Realm.Configuration.defaultConfiguration.fileURL)")

#if DEBUG
        self.cleanAllDB()
#endif

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
    }

    func storeLoginUser(loginUserValue: [String: Any]) {
        let loginUser = User(value: loginUserValue)

        try! self.realm.write() {
            self.realm.add(loginUser, update: true)
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

    func hasUserInfo() -> Bool {
        return self.fetchLoginUser() != nil
    }

    func fetchLoginUser() -> User? {
        return self.realm.objects(User.self).first
    }

    func fetchAllWillItemList() -> Results<WillItem>? {
        return self.realm.objects(WillItem.self)
    }

    func fetchWillItem(willItemId: String) -> WillItem? {
        return self.realm.objects(WillItem.self).filter("willItemID = '\(willItemId)'").first
    }

    func fetchReceiver(receiverID: String) -> Receiver? {
        return self.realm.objects(Receiver.self).filter("receiverID = '\(receiverID)'").first
    }

}
