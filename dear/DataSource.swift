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

    static let modelRevision = 6

    let realm = try! Realm()

    static let instance = DataSource()
    private init() {
        let currentModelRevision = ConfigManager.instance.dataModelRevision
        if currentModelRevision != DataSource.modelRevision {
            self.cleanAllDB()
            ConfigManager.instance.dataModelRevision = DataSource.modelRevision
        }

//#if DEBUG
//
//        self.cleanAllDB()
//
//        try! self.realm.write {
//            let receiver = Receiver(value: Receiver.fixture())
//            self.realm.add(receiver)
//            let answer = Answer(value: Answer.fixture())
//            self.realm.add(answer)
//            let willItem = WillItem(value: WillItem.fixture())
//            self.realm.add(willItem)
//            let user = User(value: User.fixture())
//            self.realm.add(user)
//        }
//
//        DispatchQueue.main.async {
//            let a = self.realm.objects(Receiver.self).first
//            let b = self.realm.objects(Answer.self).first
//            let c = self.realm.objects(WillItem.self).first
//            let d = self.realm.objects(User.self).first
//        }
//
//#endif

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
    }

    func storeLoginUser(loginUserValue: [String: Any]) {

        let loginUser = User(value: loginUserValue)

        try! self.realm.write() {
            self.realm.add(loginUser, update: true)
        }
    }

    func fetchLoginUser() -> User? {
        let searchResults = self.realm.objects(User.self)
        if searchResults.count > 0 {
            return searchResults.first
        } else {
            return nil
        }
    }

    func hasUserInfo() -> Bool {
        return self.fetchLoginUser() != nil
    }

    func storeWIllItem(willItemRawInfo:[String:Any]) {
        try! self.realm.write {
            let willItem = WillItem(value: willItemRawInfo)
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

    func fetchAllWillItemList() -> Results<WillItem>? {
        return self.realm.objects(WillItem.self)
    }

    func fetchWillItem(willItemId: String, completion: (WillItem?) -> Void) {
        let searchResults = self.realm.objects(WillItem.self).filter("willItemID = '\(willItemId)'")

        if searchResults.count > 0 {
            completion(searchResults.first)
        } else {
            completion(nil)
        }
    }

}
