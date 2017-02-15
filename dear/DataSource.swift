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

    func storeWillItemList(willItemList: [WillItem]) {

    }

    func fetchAllWillItemList(completion: ([WillItem]) -> Void) {

    }

    func fetchWillItem(index: Int, completion: (WillItem) -> Void) {

    }

}
