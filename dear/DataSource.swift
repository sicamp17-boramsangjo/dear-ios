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

    let realm = try! Realm()

    static let instance = DataSource()
    private init() {}

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

    func storeLoginUser(loginUser: [String: Any]) {
        try! self.realm.write() {
            self.realm.create(User.self, value: loginUser)
        }
    }

    func fetchLoginUser() -> User? {
        let searchResults = self.realm.objects(User.self)
        if searchResults.count > 0 {
            return searchResults[0]
        } else {
            return nil
        }
    }

    func isLogin() -> Bool {
        return self.fetchLoginUser() != nil
    }

    func storeWillItemList(willItemList: [[String:Any]]) {
        try! self.realm.write() {
            for willItem in willItemList {
                self.realm.create(WillItem.self, value: willItem)
            }
        }
    }

    func fetchAllWillItemList(completion: ([WillItem]) -> Void) {
        //return self.realm.objects(WillItem.self)
    }

    func fetchWillItem(willItemId: String, completion: (WillItem?) -> Void) {
        let searchResults = self.realm.objects(WillItem.self).filter("id = \(willItemId)")

        if searchResults.count > 0 {
            completion(searchResults[0])
        } else {
            completion(nil)
        }
    }

}
